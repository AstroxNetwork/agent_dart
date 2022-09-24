import 'dart:typed_data';

import 'package:agent_dart/agent/request_id.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/is.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:agent_dart/utils/extension.dart';

import './agent/http/types.dart';
import 'types.dart';

final _domainSeparator = '\x0Aic-request'.plainToU8a();

/// A Key Pair, containing a secret and public key.
abstract class KeyPair {
  const KeyPair({required this.secretKey, required this.publicKey});

  final BinaryBlob secretKey;
  final PublicKey publicKey;
}

abstract class PublicKey {
  const PublicKey();

  // Get the public key bytes encoded with DER.
  DerEncodedBlob toDer();
}

abstract class Identity {
  const Identity();

  /// Get the principal represented by this identity. Normally should be a
  /// `Principal.selfAuthenticating()`.
  Principal getPrincipal();

  /// Transform a request into a signed version of the request. This is done last
  /// after the transforms on the body of a request. The returned object can be
  /// anything, but must be serializable to CBOR.
  Future<dynamic> transformRequest(HttpAgentRequest request);
}

/// An Identity that can sign blobs.
abstract class SignIdentity implements Identity {
  Principal? _principal;

  /// Returns the public key that would match this identity's signature.
  PublicKey getPublicKey();

  /// Signs a blob of data, with this identity's private key.
  Future<BinaryBlob> sign(BinaryBlob blob);

  Uint8List getAccountId([Uint8List? subAccount]) {
    return Principal.selfAuthenticating(
      getPublicKey().toDer(),
    ).toAccountId(subAccount: subAccount);
  }

  /// Get the principal represented by this identity. Normally should be a
  /// `Principal.selfAuthenticating()`.
  @override
  Principal getPrincipal() {
    _principal ??= Principal.selfAuthenticating(getPublicKey().toDer());
    return _principal!;
  }

  /// Transform a request into a signed version of the request. This is done last
  /// after the transforms on the body of a request. The returned object can be
  /// anything, but must be serializable to CBOR.
  /// @param request - internet computer request to transform
  @override
  Future<dynamic> transformRequest(HttpAgentRequest request) async {
    final body = request.body;
    final requestId = requestIdOf(body.toJson());
    return {
      ...request.toJson(),
      'body': {
        'content': request.body.toJson(),
        'sender_pubkey': getPublicKey().toDer(),
        'sender_sig': await sign(
          u8aConcat([_domainSeparator, requestId.buffer]),
        ),
      },
    };
  }
}

class AnonymousIdentity implements Identity {
  const AnonymousIdentity();

  @override
  Principal getPrincipal() => Principal.anonymous();

  @override
  Future<Map<String, dynamic>> transformRequest(HttpAgentRequest request) {
    return Future.value({
      ...request.toJson(),
      'body': {'content': request.body.toJson()}
    });
  }
}

/// We need to communicate with other agents on the page about identities,
/// but those messages may need to go across boundaries where it's not possible
/// to serialize/deserialize object prototypes easily. So these are lightweight,
/// serializable objects that contain enough information to recreate
/// [SignIdentity]s, but don't commit to having all methods of [SignIdentity].
///
/// Use Case:
///  * DOM Events that let differently-versioned components communicate to
///    one another about [Identity], even if they're using slightly different
///    versions of agent packages to create/interpret them.
///
/// Create an IdentityDescriptor from a @dfinity/authentication Identity
/// @param identity - identity describe in returned descriptor
class IdentityDescriptor {
  const IdentityDescriptor({required this.type, this.publicKey});

  factory IdentityDescriptor.fromJson(Map<String, dynamic> json) {
    return IdentityDescriptor(
      type: json['type'] ?? 'AnonymousIdentity',
      publicKey: json['publicKey'],
    );
  }

  final String type;
  final String? publicKey;

  Map<String, dynamic> toJson() {
    return {'type': type, if (publicKey != null) 'publicKey': publicKey};
  }
}

IdentityDescriptor createIdentityDescriptor(Identity identity) {
  final isSignIdentity = identity is SignIdentity;
  final identityIndicator = {
    'type': isSignIdentity ? 'PublicKeyIdentity' : 'AnonymousIdentity',
    if (isSignIdentity) 'publicKey': identity.getPublicKey().toDer().toHex(),
  };
  return IdentityDescriptor.fromJson(identityIndicator);
}

/// Type Guard for whether the unknown value is an IdentityDescriptor or not.
/// @param value - value to type guard
bool isIdentityDescriptor(dynamic value) {
  if (value is IdentityDescriptor) {
    switch (value.type) {
      case 'AnonymousIdentity':
        return true;
      case 'PublicKeyIdentity':
        return isHex(value.publicKey);
    }
  }
  return false;
}
