import 'dart:typed_data';

import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:meta/meta.dart';

import 'agent/http/types.dart';
import 'request_id.dart';
import 'types.dart';

/// A Key Pair, containing a secret and public key.
@immutable
abstract class KeyPair {
  const KeyPair({required this.secretKey, required this.publicKey});

  final BinaryBlob secretKey;
  final PublicKey publicKey;
}

@immutable
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
          u8aConcat([
            '\x0Aic-request'.plainToU8a(), // Domain separator
            requestId.buffer,
          ]),
        ),
      },
    };
  }
}

@immutable
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
