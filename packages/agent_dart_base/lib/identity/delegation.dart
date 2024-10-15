import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';

import '../agent/agent/http/types.dart';
import '../agent/auth.dart';
import '../agent/cbor.dart';
import '../agent/request_id.dart';
import '../agent/types.dart';
import '../principal/principal.dart';
import '../utils/extension.dart';
import '../utils/u8a.dart';

final authDelegationDomainSeparator =
    '\x1Aic-request-auth-delegation'.plainToU8a();
final requestDomainSeparator = '\x0Aic-request'.plainToU8a();

class Delegation extends ToCborable {
  const Delegation(this.pubkey, this.expiration, this.targets);

  factory Delegation.fromJson(Map map) {
    return Delegation(
      map['pubkey'] is String
          ? (map['pubkey'] as String).toU8a()
          : Uint8List.fromList(map['pubkey']),
      map['expiration'] is BigInt
          ? map['expiration']
          : (map['expiration'] as String).hexToBn(),
      map['targets'] != null
          ? (map['targets'] as List).map((e) => Principal.fromHex(e)).toList()
          : null,
    );
  }

  final BinaryBlob pubkey;
  final BigInt expiration;
  final List<Principal>? targets;

  @override
  void write(Encoder encoder) {
    final res = {
      'pubkey': pubkey,
      'expiration': expiration.toInt(),
      if (targets != null)
        'targets': targets?.map((e) => e.toUint8List()).toList(),
    };
    encoder.writeMap(res);
  }

  Map<String, dynamic> toJson() {
    return {
      'expiration': expiration.toHex(),
      'pubkey': pubkey.toHex(),
      'targets': targets?.map((e) => e.toHex()).toList(),
    }..removeWhere((key, value) => value == null);
  }
}

class SignedDelegation {
  const SignedDelegation({this.delegation, this.signature});

  factory SignedDelegation.fromJson(Map<String, dynamic> map) {
    return SignedDelegation(
      delegation: map['delegation'] is Delegation
          ? map['delegation']
          : Delegation.fromJson(map['delegation']),
      signature: map['signature'] is String
          ? (map['signature'] as String).toU8a()
          : Uint8List.fromList(map['signature']),
    );
  }

  final Delegation? delegation;
  final BinaryBlob? signature;

  Map<String, dynamic> toJson() {
    return {
      'delegation': delegation?.toJson(),
      'signature': signature?.toHex(),
    };
  }
}

// Promise<SignedDelegation>
Future<SignedDelegation> _createSingleDelegation(
  SignIdentity from,
  PublicKey to,
  DateTime expiration,
  List<Principal>? targets,
) async {
  final Delegation delegation = Delegation(
    to.toDer(),
    BigInt.from(expiration.millisecondsSinceEpoch) *
        BigInt.from(1000000), // In nanoseconds.
    targets,
  );
  // The signature is calculated by signing the concatenation of
  // the domain separator and the message.
  final challenge = u8aConcat([
    authDelegationDomainSeparator,
    requestIdOf(
      {
        'expiration': delegation.expiration,
        'pubkey': delegation.pubkey,
        'targets': delegation.targets,
      }..removeWhere((_, v) => v == null),
    ),
  ]);

  final signature = await from.sign(challenge);
  return SignedDelegation.fromJson({
    'delegation': delegation,
    'signature': signature,
  });
}

/// A chain of delegations. This is JSON Serializable.
/// This is the object to serialize and pass to a [DelegationIdentity].
/// It does not keep any private keys.
class DelegationChain {
  const DelegationChain(this.delegations, this.publicKey);

  /// Creates a DelegationChain object from a JSON string.
  factory DelegationChain.fromJSON(dynamic obj) {
    final json = obj is String
        ? Map<String, dynamic>.from(jsonDecode(obj))
        : Map<String, dynamic>.from(obj);
    if (json['delegations'] is! List) {
      throw ArgumentError('Invalid delegations type.', json['delegations']);
    }
    final publicKey = json['publicKey'] as String;
    final delegations = json['delegations'] as List<dynamic>;
    final parsedDelegations = delegations.map((map) {
      final signedDelegation = SignedDelegation.fromJson(map);
      final delegation = signedDelegation.delegation,
          signature = signedDelegation.signature;
      final pubkey = delegation?.pubkey,
          expiration = delegation?.expiration,
          targets = delegation?.targets;
      return SignedDelegation.fromJson({
        'delegation': Delegation(
          pubkey!,
          // expiration in JSON is a hex string.
          expiration!,
          targets,
        ),
        'signature': signature,
      });
    }).toList();
    return DelegationChain(parsedDelegations, blobFromHex(publicKey));
  }

  /// Create a delegation chain between two (or more) keys.
  /// By default, the expiration time will be very short (15 minutes).
  ///
  /// To build a chain of more than 2 identities, this function needs to
  /// be called multiple times, passing the previous delegation chain into
  /// the options argument.
  static Future<DelegationChain> create(
    SignIdentity from,
    PublicKey to,
    DateTime? expiration, {
    DelegationChain? previous,
    List<Principal>? targets,
  }) async {
    expiration ??= DateTime.now().add(const Duration(minutes: 15));
    final delegation = await _createSingleDelegation(
      from,
      to,
      expiration,
      targets,
    );
    return DelegationChain(
      [...?previous?.delegations, delegation],
      previous?.publicKey ?? from.getPublicKey().toDer(),
    );
  }

  /// Creates a DelegationChain object from a list of delegations and
  /// a DER-encoded public key.
  ///
  /// [delegations] is the list of delegations.
  /// [publicKey] is the DER-encoded public key of the key-pair signing
  /// the first delegation.
  static DelegationChain fromDelegations(
    List<SignedDelegation> delegations,
    DerEncodedBlob publicKey,
  ) {
    return DelegationChain(delegations, publicKey);
  }

  final List<SignedDelegation> delegations;
  final DerEncodedBlob publicKey;

  Map<String, dynamic> toJson() {
    return {
      'delegations': delegations
          .map((signedDelegation) => signedDelegation.toJson())
          .toList(),
      'publicKey': publicKey.toHex(),
    };
  }
}

/// An [Identity] that adds delegation to a request. Everywhere in this class,
/// the name innerKey refers to the [SignIdentity] that is being used to
/// sign the requests, while originalKey is the identity that is being borrowed.
/// More identities can be used in the middle to delegate.
class DelegationIdentity extends SignIdentity {
  DelegationIdentity(this._inner, this._delegation);

  final SignIdentity _inner;
  final DelegationChain _delegation;

  /// Create a delegation without having access to delegate key.
  static DelegationIdentity fromDelegation(
    SignIdentity key,
    DelegationChain delegation,
  ) {
    return DelegationIdentity(key, delegation);
  }

  DelegationChain getDelegation() => _delegation;

  @override
  PublicKey getPublicKey() {
    return DelegationIdentityPublicKey(_delegation.publicKey);
  }

  @override
  Future<BinaryBlob> sign(BinaryBlob blob) => _inner.sign(blob);

  @override
  Future<dynamic> transformRequest(HttpAgentRequest request) async {
    final body = request.body;
    final requestId = requestIdOf(body.toJson());

    return {
      ...request.toJson(),
      'body': {
        'content': request.body.toJson(),
        'sender_sig':
            await sign(u8aConcat([requestDomainSeparator, requestId])),
        'sender_delegation': _delegation.delegations
            .map((e) => {'delegation': e.delegation, 'signature': e.signature})
            .toList(),
        'sender_pubkey': _delegation.publicKey,
      },
    };
  }
}

class DelegationIdentityPublicKey extends PublicKey {
  const DelegationIdentityPublicKey(this._result);

  final DerEncodedBlob _result;

  @override
  DerEncodedBlob toDer() => _result;
}
