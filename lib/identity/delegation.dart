import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:cbor/cbor.dart';

final domainSeparator = ('\x1Aic-request-auth-delegation').plainToU8a(useDartEncode: true);
final requestDomainSeparator = ('\x0Aic-request').plainToU8a(useDartEncode: true);

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
    var pub = cborEncode(pubkey);
    var exp = cborEncode(expiration.toInt());
    var targetLists = targets?.map((e) => e.toUint8Array()).toList() ?? [];

    List<Uint8List> newList = List<Uint8List>.from([], growable: true);
    for (var i = 0; i < targetLists.length; i += 1) {
      newList.add(cborEncode(targetLists[i]));
    }
    var _targets = targets != null ? {"targets": newList} : {};
    encoder.writeMap({"pubkey": pub, "expiration": exp, ..._targets});
  }

  toJSON() {
    // every string should be hex and once-de-hexed,
    // discoverable what it is (e.g. de-hex to get JSON with a 'type' property, or de-hex to DER with an OID)
    // After de-hex, if it's not obvious what it is, it's an ArrayBuffer.
    // var _targets = targets != null ? {"target": targets?.map((e) => e.toHex())} : null;
    if (targets != null) {
      return {
        "expiration": expiration.toHex().hexStripPrefix(),
        "pubkey": pubkey.toHex(),
        "targets": targets?.map((e) => e.toHex()).toList(),
      };
    } else {
      return {
        "expiration": expiration.toHex().hexStripPrefix(),
        "pubkey": pubkey.toHex(),
      };
    }
  }

  toMap() {
    // every string should be hex and once-de-hexed,
    // discoverable what it is (e.g. de-hex to get JSON with a 'type' property, or de-hex to DER with an OID)
    // After de-hex, if it's not obvious what it is, it's an ArrayBuffer.
    // var _targets = targets != null ? {"target": targets?.map((e) => e.toHex())} : null;
    if (targets != null) {
      return {
        "expiration": expiration,
        "pubkey": pubkey,
        "targets": targets?.map((e) => e.toHex()).toList(),
      };
    } else {
      return {
        "expiration": expiration,
        "pubkey": pubkey,
      };
    }
  }

  factory Delegation.fromMap(Map map) {
    return Delegation(
        map["pubkey"] is String ? (map["pubkey"] as String).toU8a() : map["pubkey"],
        (map["expiration"] as String).hexToBn(),
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
        signature:
            map['signature'] is String ? (map["signature"] as String).toU8a() : map["signature"]);
  }
  toJson() {
    return {"delegation": delegation?.toJSON(), "signature": signature?.toHex()};
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
    BigInt.from(expiration.millisecondsSinceEpoch) * BigInt.from(1000000), // In nanoseconds.
    targets,
  );
  // The signature is calculated by signing the concatenation of the domain separator
  // and the message.
  // Note: To ensure Safari treats this as a user gesture, ensure to not use async methods
  // besides the actualy webauthn functionality (such as `sign`). Safari will de-register
  // a user gesture if you await an async call thats not fetch, xhr, or setTimeout.

  final challenge = u8aConcat([domainSeparator, requestIdOf(delegation.toMap())]);
  final signature = await from.sign(blobFromUint8Array(challenge));

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
    return {"publicKey": publicKey, "deligations": deligations.map((e) => e.toJson()).toList()};
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
  static Future<DelegationChain> create(SignIdentity from, PublicKey to, DateTime? expiration,
      {DelegationChain? previous, List<Principal>? targets}) async {
    expiration ??=
        DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 15 * 60 * 1000);
    final delegation = await _createSingleDelegation(from, to, expiration, targets);

    return DelegationChain(
      [...(previous?.delegations ?? []), delegation],
      previous?.publicKey ?? from.getPublicKey().toDer(),
    );
  }

  /// Creates a DelegationChain object from a JSON string.
  ///
  /// @param json The JSON string to parse.
  factory DelegationChain.fromJSON(dynamic obj) {
    var json =
        obj is String ? Map<String, dynamic>.from(jsonDecode(obj)) : Map<String, dynamic>.from(obj);
    if (json["delegations"] is! List) {
      throw 'Invalid delegations.';
    }

    var publicKey = json["publicKey"] as String;
    var delegations = json["delegations"] as List<dynamic>;

    final parsedDelegations = delegations.map((map) {
      var signedDelegation = SignedDelegation.fromMap(map);
      final delegation = signedDelegation.delegation, signature = signedDelegation.signature;
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
        "signature": (signature),
      });
    }).toList();

    return DelegationChain(parsedDelegations, derBlobFromBlob(blobFromHex(publicKey)));
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
