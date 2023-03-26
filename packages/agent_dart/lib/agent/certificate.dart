import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/request_id.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:typed_data/typed_data.dart';

import '../src/ffi/bls.base.dart';
import 'agent/api.dart';
import 'errors.dart';

final BaseBLS _bls = BaseBLS();

/// A certificate needs to be verified (using Certificate.prototype.verify)
/// before it can be used.
class UnverifiedCertificateError extends AgentFetchError {
  UnverifiedCertificateError();

  @override
  String toString() => 'Cannot lookup unverified certificate. '
      "Try to call 'verify()' again.";
}

/// type HashTree =
///   | [0]
///   | [1, HashTree, HashTree]
///   | [2, ArrayBuffer, HashTree]
///   | [3, ArrayBuffer]
///   | [4, ArrayBuffer];
enum NodeId {
  empty(0),
  fork(1),
  labeled(2),
  leaf(3),
  pruned(4);

  const NodeId(this._value);

  factory NodeId.fromValue(int value) {
    return values.singleWhere((e) => e._value == value);
  }

  final int _value;
}

class Cert {
  const Cert({this.tree, this.signature, this.delegation});

  factory Cert.fromJson(Map json) {
    return Cert(
      delegation: json['delegation'] != null
          ? Delegation.fromJson(Map<String, dynamic>.from(json['delegation']))
          : null,
      signature: json['signature'] != null
          ? (json['signature'] as Uint8Buffer).buffer.asUint8List()
          : null,
      tree: json['tree'],
    );
  }

  final List? tree;
  final Uint8List? signature;
  final Delegation? delegation;

  Map<String, dynamic> toJson() {
    return {
      'tree': tree,
      'signature': signature,
      'delegation': delegation?.toJson() ?? {}
    };
  }
}

/// Make a human readable string out of a hash tree.
/// @param tree
String hashTreeToString(List tree) {
  String indent(String s) => s.split('\n').map((x) => '  $x').join('\n');

  switch (tree[0]) {
    case 0:
      return '()';
    case 1:
      final left = hashTreeToString(tree[1] as List);
      final right = hashTreeToString(tree[2] as List);
      return 'sub(\n left:\n${indent(left)}\n---\n right:\n${indent(right)}\n)';
    case 2:
      final label = u8aToString(tree[1] as Uint8List, useDartEncode: true);
      final sub = hashTreeToString(tree[2] as List);
      return 'label(\n label:\n${indent(label)}\n sub:\n${indent(sub)}\n)';
    case 3:
      return 'leaf(...${(tree[1] as Uint8List).lengthInBytes} bytes)';
    case 4:
      return 'pruned(${blobToHex(tree[1] as Uint8List)}';
    default:
      return 'unknown(${jsonEncode(tree[0])})';
  }
}

class Delegation extends ReadStateResponse {
  const Delegation(
    this.subnetId,
    BinaryBlob certificate,
  ) : super(certificate: certificate);

  factory Delegation.fromJson(Map<String, dynamic> json) {
    return Delegation(
      Uint8List.fromList(json['subnet_id'] as List<int>),
      json['certificate'] is Uint8List || json['certificate'] is Uint8Buffer
          ? Uint8List.fromList(json['certificate'])
          : Uint8List.fromList([]),
    );
  }

  final Uint8List? subnetId;

  Map<String, dynamic> toJson() {
    return {'subnet_id': subnetId, 'certificate': certificate};
  }
}

class Certificate {
  Certificate(
    ReadStateResponse response,
    this._agent,
  ) : cert = Cert.fromJson(cborDecode(response.certificate));

  final Agent _agent;
  final Cert cert;
  bool verified = false;
  BinaryBlob? _rootKey;

  Uint8List? lookupEx(List path) {
    checkState();
    return lookupPathEx(path, cert.tree!);
  }

  Uint8List? lookup(List path) {
    checkState();
    return lookupPath(path, cert.tree!);
  }

  Future<bool> verify() async {
    final rootHash = await reconstruct(cert.tree!);
    final derKey = await _checkDelegation(cert.delegation);
    final sig = cert.signature;
    final key = extractDER(derKey);
    final msg = u8aConcat([domainSep('ic-state-root'), rootHash]);
    final res = await _bls.blsVerify(key, sig!, msg);
    verified = res;
    return res;
  }

  void checkState() {
    if (!verified) {
      throw UnverifiedCertificateError();
    }
  }

  Future<Uint8List> _checkDelegation(Delegation? d) async {
    if (d == null) {
      if (_rootKey == null) {
        if (_agent.rootKey != null) {
          _rootKey = _agent.rootKey;
          return Future.value(_rootKey);
        }
        throw StateError(
          'The rootKey is not exist. Try to call `fetchRootKey` again.',
        );
      }
      return Future.value(_rootKey);
    }
    final Certificate cert = Certificate(d, _agent);
    if (!(await cert.verify())) {
      throw StateError('Fail to verify certificate.');
    }

    final lookup = cert.lookupEx(['subnet', d.subnetId, 'public_key']);
    if (lookup == null) {
      throw StateError('Cannot find subnet key for 0x${d.subnetId!.toHex()}.');
    }
    return lookup;
  }
}

final _derPrefix =
    '308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7c05030201036100'
        .toU8a();

const _keyLength = 96;

Uint8List extractDER(Uint8List buf) {
  final expectedLength = _derPrefix.length + _keyLength;
  if (buf.length != expectedLength) {
    throw RangeError.value(
      buf.length,
      'Expected $expectedLength-bytes long but got ${buf.length}.',
    );
  }
  final prefix = buf.sublist(0, _derPrefix.length);
  if (!u8aEq(prefix, _derPrefix)) {
    throw StateError('Expected prefix $_derPrefix but got $prefix.');
  }
  return buf.sublist(_derPrefix.length);
}

Future<Uint8List> reconstruct(List t) async {
  final nodeId = NodeId.fromValue(t[0]);
  switch (nodeId) {
    case NodeId.empty:
      return Future.value(hash(domainSep('ic-hashtree-empty')));
    case NodeId.pruned:
      return (t[1] as Uint8Buffer).buffer.asUint8List();
    case NodeId.leaf:
      return Future.value(
        hash(
          u8aConcat([
            domainSep('ic-hashtree-leaf'),
            (t[1] as Uint8Buffer).buffer.asUint8List(),
          ]),
        ),
      );
    case NodeId.labeled:
      return Future.value(
        hash(
          u8aConcat([
            domainSep('ic-hashtree-labeled'),
            (t[1] as Uint8Buffer).buffer.asUint8List(),
            (await reconstruct(t[2] as List)),
          ]),
        ),
      );
    case NodeId.fork:
      return Future.value(
        hash(
          u8aConcat([
            domainSep('ic-hashtree-fork'),
            (await reconstruct(t[1] as List)),
            (await reconstruct(t[2] as List)),
          ]),
        ),
      );
  }
}

Uint8List domainSep(String s) {
  final buf = Uint8List.fromList(List<int>.filled(1, s.length));
  return u8aConcat([buf, s.plainToU8a(useDartEncode: true)]);
}

Uint8List? lookupPathEx(List path, List tree) {
  final maybeReturn = lookupPath(
    path.map((p) {
      if (p is String) {
        return blobFromText(p).buffer;
      } else {
        return blobFromUint8Array(p).buffer;
      }
    }).toList(),
    tree,
  );
  return maybeReturn;
}

Uint8List? lookupPath(List path, List tree) {
  if (path.isEmpty) {
    final NodeId nodeId = NodeId.fromValue(tree[0]);
    switch (nodeId) {
      case NodeId.leaf:
        return tree[1] is Uint8List
            ? tree[1]
            : (tree[1] as Uint8Buffer).buffer.asUint8List();
      default:
        return null;
    }
  }
  final t = findLabel(
    path[0] is ByteBuffer ? (path[0] as ByteBuffer).asUint8List() : path[0],
    flattenForks(tree),
  );
  if (t != null) {
    return lookupPath(path.sublist(1), t);
  }
  return null;
}

List<List> flattenForks(List t) {
  final NodeId nodeId = NodeId.fromValue(t[0]);
  switch (nodeId) {
    case NodeId.empty:
      return [];
    case NodeId.fork:
      final res = flattenForks(t[1] as List);
      res.addAll(flattenForks(t[2] as List));
      return res;
    default:
      return [t];
  }
}

List? findLabel(Uint8List l, List<List> trees) {
  if (trees.isEmpty) {
    return null;
  }
  for (final t in trees) {
    final NodeId nodeId = NodeId.fromValue(t[0]);
    if (nodeId == NodeId.labeled) {
      final p =
          t[1] is Uint8List ? t[1] : (t[1] as Uint8Buffer).buffer.asUint8List();
      if (u8aEq(l, p)) {
        return t[2] as List;
      }
    }
  }
  return null;
}
