import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/identity/ed25519.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:cbor/cbor.dart';
import 'package:typed_data/typed_buffers.dart';

final authDelegationDomainSeparator =
    ('\x1Aic-request-auth-delegation').plainToU8a();
final requestDomainSeparator = ('\x0Aic-request').plainToU8a();

class Delegation extends ToCBorable {
  final BinaryBlob pubkey;
  final BigInt expiration;
  List<Principal>? targets;
  Delegation(
    this.pubkey,
    this.expiration,
    this.targets,
  );

  @override
  void write(Encoder encoder) {
    var targetLists = targets?.map((e) => e.toUint8Array()).toList() ?? [];

    var _targets = targets != null ? {"targets": targetLists} : {};
    var res = {"pubkey": pubkey, "expiration": expiration.toInt(), ..._targets};

    encoder.writeMap(res);
  }

  Map<String, dynamic> toJSON() => {
        "expiration": expiration.toHex().hexStripPrefix(),
        "pubkey": pubkey.toHex(),
        "targets": targets?.map((e) => e.toHex()).toList(),
      }..removeWhere((key, value) => value == null);

  Map<String, dynamic> toMap() => {
        "expiration": expiration,
        "pubkey": pubkey,
        "targets": targets,
      }..removeWhere((key, value) => value == null);

  factory Delegation.fromMap(Map map) {
    return Delegation(
        map["pubkey"] is String
            ? (map["pubkey"] as String).toU8a()
            : Uint8List.fromList(map["pubkey"]),
        map["expiration"] is BigInt
            ? map["expiration"]
            : (map["expiration"] as String).hexToBn(),
        map["targets"] != null
            ? (map["targets"] as List).map((e) => Principal.fromHex(e)).toList()
            : null);
  }
}

class SignedDelegation {
  final Delegation? delegation;
  final BinaryBlob? signature;
  SignedDelegation({this.delegation, this.signature});
  factory SignedDelegation.fromMap(Map<String, dynamic> map) {
    return SignedDelegation(
        delegation: map["delegation"] is Delegation
            ? map["delegation"]
            : Delegation.fromMap(map["delegation"]),
        signature: map['signature'] is String
            ? (map["signature"] as String).toU8a()
            : Uint8List.fromList(map["signature"]));
  }
  Map<String, dynamic> toMap() {
    return {
      //
      "delegation": delegation,
      "signature": signature
    };
  }

  Map<String, dynamic> toJson() {
    return {
      //
      "delegation": delegation?.toJSON(),
      "signature": signature?.toHex()
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
  Delegation delegation = Delegation(
    to.toDer(),
    BigInt.from(expiration.millisecondsSinceEpoch) *
        BigInt.from(1000000), // In nanoseconds.
    targets,
  );
  // The signature is calculated by signing the concatenation of the domain separator
  // and the message.
  // Note: To ensure Safari treats this as a user gesture, ensure to not use async methods
  // besides the actualy webauthn functionality (such as `sign`). Safari will de-register
  // a user gesture if you await an async call thats not fetch, xhr, or setTimeout.

  final challenge = u8aConcat(
      [authDelegationDomainSeparator, requestIdOf(delegation.toMap())]);

  final signature = await from.sign(challenge);

  // print("\n=========");
  // print((from as Ed25519KeyIdentity).toJSON());
  // print(from.getPublicKey().toDer().toHex());
  // print(signature.toHex());
  // print("verifiable?: ${(from as Ed25519KeyIdentity).verify(signature, challenge)}");
  // print("=========");

  return SignedDelegation.fromMap({
    "delegation": delegation,
    "signature": signature,
  });
}

class IJsonnableDelegationChain {
  String publicKey;
  List<SignedDelegation> deligations;
  IJsonnableDelegationChain(this.publicKey, this.deligations);
  toJson() {
    return {
      "publicKey": publicKey,
      "deligations": deligations.map((e) => e.toJson()).toList()
    };
  }
}

/// A chain of delegations. This is JSON Serializable.
/// This is the object to serialize and pass to a DelegationIdentity. It does not keep any
/// private keys.
class DelegationChain {
  /// Create a delegation chain between two (or more) keys. By default, the expiration time
  /// will be very short (15 minutes).
  ///
  /// To build a chain of more than 2 identities, this function needs to be called multiple times,
  /// passing the previous delegation chain into the options argument. For example:
  ///
  /// @example
  /// const rootKey = createKey();
  /// const middleKey = createKey();
  /// const bottomeKey = createKey();
  ///
  /// const rootToMiddle = await DelegationChain.create(
  ///   root, middle.getPublicKey(), Date.parse('2100-01-01'),
  /// );
  /// const middleToBottom = await DelegationChain.create(
  ///   middle, bottom.getPublicKey(), Date.parse('2100-01-01'), { previous: rootToMiddle },
  /// );
  ///
  /// // We can now use a delegation identity that uses the delegation above:
  /// const identity = DelegationIdentity.fromDelegation(bottomKey, middleToBottom);
  ///
  /// @param from The identity that will delegate.
  /// @param to The identity that gets delegated. It can now sign messages as if it was the
  ///           identity above.
  /// @param expiration The length the delegation is valid. By default, 15 minutes from calling
  ///                   this function.
  /// @param options A set of options for this delegation. expiration and previous
  /// @param options.previous - Another DelegationChain that this chain should start with.
  /// @param options.targets - targets that scope the delegation (e.g. Canister Principals)
  static Future<DelegationChain> create(
      SignIdentity from, PublicKey to, DateTime? expiration,
      {DelegationChain? previous, List<Principal>? targets}) async {
    expiration ??= DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 15 * 60 * 1000);
    final delegation =
        await _createSingleDelegation(from, to, expiration, targets);

    return DelegationChain(
      [...(previous?.delegations ?? []), delegation],
      previous?.publicKey ?? from.getPublicKey().toDer(),
    );
  }

  /// Creates a DelegationChain object from a JSON string.
  ///
  /// @param json The JSON string to parse.
  factory DelegationChain.fromJSON(dynamic obj) {
    var json = obj is String
        ? Map<String, dynamic>.from(jsonDecode(obj))
        : Map<String, dynamic>.from(obj);
    if (json["delegations"] is! List) {
      throw 'Invalid delegations.';
    }

    var publicKey = json["publicKey"] as String;
    var delegations = json["delegations"] as List<dynamic>;

    final parsedDelegations = delegations.map((map) {
      var signedDelegation = SignedDelegation.fromMap(map);
      final delegation = signedDelegation.delegation,
          signature = signedDelegation.signature;
      var pubkey = delegation?.pubkey,
          expiration = delegation?.expiration,
          targets = delegation?.targets;

      if (targets != null && (targets is! List)) {
        throw 'Invalid targets.';
      }

      return SignedDelegation.fromMap({
        "delegation": Delegation(
          pubkey!,
          expiration!, // expiration in JSON is an hexa string (See toJSON() below).
          targets,
        ),
        "signature": signature,
      });
    }).toList();

    return DelegationChain(
        parsedDelegations, derBlobFromBlob(blobFromHex(publicKey)));
  }

  /// Creates a DelegationChain object from a list of delegations and a DER-encoded public key.
  ///
  /// @param delegations The list of delegations.
  /// @param publicKey The DER-encoded public key of the key-pair signing the first delegation.
  static DelegationChain fromDelegations(
    List<SignedDelegation> delegations,
    DerEncodedBlob publicKey,
  ) {
    return DelegationChain(delegations, publicKey);
  }

  final List<SignedDelegation> delegations;
  final DerEncodedBlob publicKey;

  DelegationChain(
    this.delegations,
    this.publicKey,
  );

  toJSON() {
    return {
      "delegations": delegations.map((signedDelegation) {
        return signedDelegation.toJson();
      }).toList(),
      "publicKey": publicKey.toHex(),
    };
  }
}

/// An Identity that adds delegation to a request. Everywhere in this class, the name
/// innerKey refers to the SignIdentity that is being used to sign the requests, while
/// originalKey is the identity that is being borrowed. More identities can be used
/// in the middle to delegate.
class DelegationIdentity extends SignIdentity {
  /// Create a delegation without having access to delegateKey.
  ///
  /// @param key The key used to sign the reqyests.
  /// @param delegation A delegation object created using `createDelegation`.
  static DelegationIdentity fromDelegation(
    SignIdentity key,
    DelegationChain delegation,
  ) {
    return DelegationIdentity(key, delegation);
  }

  final SignIdentity _inner;
  final DelegationChain _delegation;

  DelegationIdentity(
    this._inner,
    this._delegation,
  ) : super();

  DelegationChain getDelegation() {
    return _delegation;
  }

  @override
  PublicKey getPublicKey() {
    return DelegationIdentityPublicKey(_delegation.publicKey);
  }

  @override
  Future<BinaryBlob> sign(BinaryBlob blob) => _inner.sign(blob);

  @override
  Future<dynamic> transformRequest(HttpAgentRequest request) async {
    var body = request.body;
    var requestId = requestIdOf(body.toJson());

    return {
      ...request.toJson(),
      "body": {
        "content": request.body.toJson(),
        "sender_sig":
            await sign(u8aConcat([requestDomainSeparator, requestId])),
        "sender_delegation":
            _delegation.delegations.map((e) => e.toMap()).toList(),
        "sender_pubkey": _delegation.publicKey,
      },
    };
  }
}

class DelegationIdentityPublicKey extends PublicKey {
  final DerEncodedBlob _result;
  DelegationIdentityPublicKey(this._result);

  @override
  DerEncodedBlob toDer() {
    return _result;
  }
}
