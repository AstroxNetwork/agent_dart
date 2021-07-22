import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/request_id.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:typed_data/typed_data.dart';

import 'agent/api.dart';
import 'crypto/bls.dart';
import 'errors.dart';

/// A certificate needs to be verified (using {@link Certificate.prototype.verify})
/// before it can be used.
class UnverifiedCertificateError extends AgentError {
  UnverifiedCertificateError() : super() {
    throw "Cannot lookup unverified certificate. Call 'verify()' first.";
  }
}

// type HashTree =
//   | [0]
//   | [1, HashTree, HashTree]
//   | [2, ArrayBuffer, HashTree]
//   | [3, ArrayBuffer]
//   | [4, ArrayBuffer];

class NodeId {
  // ignore: constant_identifier_names
  static const Empty = 0;
  // ignore: constant_identifier_names
  static const Fork = 1;
  // ignore: constant_identifier_names
  static const Labeled = 2;
  // ignore: constant_identifier_names
  static const Leaf = 3;
  // ignore: constant_identifier_names
  static const Pruned = 4;
}

class Cert {
  List? tree;
  Uint8List? signature;
  Delegation? delegation;

  Cert({this.tree, this.signature, this.delegation});
  factory Cert.fromJson(Map json) {
    return Cert(
        delegation: json["delegation"] != null
            ? Delegation.fromJson(Map<String, dynamic>.from(json["delegation"]))
            : null,
        signature: json["signature"] != null
            ? (json["signature"] as Uint8Buffer).buffer.asUint8List()
            : null,
        tree: json["tree"]);
  }
  toJson() {
    return {
      "tree": tree,
      "signature": signature,
      "delegation": delegation != null ? delegation!.toJson() : {}
    };
  }
}

/// Make a human readable string out of a hash tree.
/// @param tree
String hashTreeToString(List tree) {
  indent(String s) => s.split('\n').map((x) => '  ' + x).join('\n');

  switch (tree[0]) {
    case 0:
      return '()';
    case 1:
      {
        final left = hashTreeToString(tree[1] as List);
        final right = hashTreeToString(tree[2] as List);
        return "sub(\n left:\n${indent(left)}\n---\n right:\n${indent(right)}\n)";
      }
    case 2:
      {
        final label = u8aToString(tree[1] as Uint8List, useDartEncode: true);
        final sub = hashTreeToString(tree[2] as List);
        return "label(\n label:\n${indent(label)}\n sub:\n${indent(sub)}\n)";
      }
    case 3:
      {
        return "leaf(...${(tree[1] as Uint8List).lengthInBytes} bytes)";
      }
    case 4:
      {
        return "pruned(${blobToHex(blobFromUint8Array(tree[1] as Uint8List))}";
      }
    default:
      {
        return "unknown(${jsonEncode(tree[0])})";
      }
  }
}

class Delegation implements ReadStateResponse {
  // ignore: non_constant_identifier_names
  final Uint8List? subnet_id;
  @override
  BinaryBlob certificate;

  Delegation(this.subnet_id, this.certificate);
  factory Delegation.fromJson(Map<String, dynamic> json) {
    return Delegation(
        Uint8List.fromList(json["subnet_id"] as List<int>),
        json["certificate"] is Uint8List
            ? blobFromUint8Array(json["certificate"])
            : Uint8List.fromList([]));
  }
  toJson() {
    return {"subnet_id": subnet_id, "certificate": certificate};
  }
}

class Certificate {
  late Cert cert;
  bool verified = false;
  BinaryBlob? _rootKey;

  final Agent _agent;
  Certificate(ReadStateResponse response, this._agent) {
    cert = Cert.fromJson(cborDecode(response.certificate));
  }

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
    final res = await blsVerify(key, sig!, msg);
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

        throw "Agent does not have a rootKey. Do you need to call 'fetchRootKey'?";
      }
      return Future.value(_rootKey);
    }
    final Certificate cert = Certificate(d, _agent);
    if (!(await cert.verify())) {
      throw 'fail to verify delegation certificate';
    }

    final lookup = cert.lookupEx(['subnet', d.subnet_id, 'public_key']);
    if (lookup == null) {
      throw "ould not find subnet key for subnet 0x${d.subnet_id!.toHex(include0x: false)}";
    }
    return lookup;
  }
}

// ignore: non_constant_identifier_names
final DER_PREFIX =
    '308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7c05030201036100'.toU8a();
// ignore: constant_identifier_names
const KEY_LENGTH = 96;

Uint8List extractDER(Uint8List buf) {
  final expectedLength = DER_PREFIX.length + KEY_LENGTH;
  if (buf.length != expectedLength) {
    throw "BLS DER-encoded public key must be $expectedLength bytes long";
  }
  final prefix = buf.sublist(0, DER_PREFIX.length);
  if (!u8aEq(prefix, DER_PREFIX)) {
    throw "BLS DER-encoded public key is invalid. Expect the following prefix: $DER_PREFIX, but get $prefix";
  }
  return buf.sublist(DER_PREFIX.length);
}

Future<Uint8List> reconstruct(List t) async {
  switch (t[0] as int) {
    case NodeId.Empty:
      return Future.value(hash(domainSep('ic-hashtree-empty')));
    case NodeId.Pruned:
      return (t[1] as Uint8Buffer).buffer.asUint8List();
    case NodeId.Leaf:
      return Future.value(hash(
        u8aConcat([
          domainSep('ic-hashtree-leaf'),
          (t[1] as Uint8Buffer).buffer.asUint8List(),
        ]),
      ));
    case NodeId.Labeled:
      return Future.value(hash(u8aConcat([
        domainSep('ic-hashtree-labeled'),
        (t[1] as Uint8Buffer).buffer.asUint8List(),
        (await reconstruct(t[2] as List)),
      ])));
    case NodeId.Fork:
      return Future.value(hash(u8aConcat([
        domainSep('ic-hashtree-fork'),
        (await reconstruct(t[1] as List)),
        (await reconstruct(t[2] as List)),
      ])));
    default:
      throw 'unreachable';
  }
}

Uint8List domainSep(String s) {
  final buf = Uint8List.fromList(List<int>.filled(1, s.length));
  return u8aConcat([buf, s.plainToU8a(useDartEncode: true)]);
}

///
/// @param path
/// @param tree
Uint8List? lookupPathEx(
  List path,
  List tree,
) {
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

/// @param path
/// @param tree
Uint8List? lookupPath(List path, List tree) {
  if (path.isEmpty) {
    switch (tree[0]) {
      case NodeId.Leaf:
        {
          return tree[1] is Uint8List ? tree[1] : (tree[1] as Uint8Buffer).buffer.asUint8List();
        }
      default:
        {
          return null;
        }
    }
  }
  final t = findLabel(
      path[0] is ByteBuffer ? (path[0] as ByteBuffer).asUint8List() : path[0], flattenForks(tree));
  if (t != null) {
    return lookupPath(path.sublist(1), t);
  }
}

List<List> flattenForks(List t) {
  switch (t[0]) {
    case NodeId.Empty:
      return [];
    case NodeId.Fork:
      var res = flattenForks(t[1] as List);
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
  for (var t in trees) {
    if (t[0] == NodeId.Labeled) {
      var p = t[1] is Uint8List ? t[1] : (t[1] as Uint8Buffer).buffer.asUint8List();
      if (u8aEq(l, p)) {
        return t[2] as List;
      }
    }
  }
}
