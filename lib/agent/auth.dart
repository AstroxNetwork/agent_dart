import 'dart:convert';

import 'dart:typed_data';

import 'package:agent_dart/agent/request_id.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/u8a.dart';

import './agent/http/types.dart';
import 'types.dart';

final domainSeparator = Uint8List.fromList(utf8.encode('\x0Aic-request'));

/// A Key Pair, containing a secret and public key.
abstract class KeyPair {
  late BinaryBlob secretKey;
  late PublicKey publicKey;
}

abstract class PublicKey {
  // Get the public key bytes encoded with DER.
  DerEncodedBlob toDer();
}

abstract class Identity {
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

  /// Get the principal represented by this identity. Normally should be a
  /// `Principal.selfAuthenticating()`.
  @override
  Principal getPrincipal() {
    _principal ??= Principal.selfAuthenticating(getPublicKey().toDer().buffer);
    return _principal!;
  }

  /// Transform a request into a signed version of the request. This is done last
  /// after the transforms on the body of a request. The returned object can be
  /// anything, but must be serializable to CBOR.
  /// @param request - internet computer request to transform
  @override
  Future<dynamic> transformRequest(HttpAgentRequest request) async {
    var body = request.body;

    var requestId = requestIdOf(body.toJson());

    return {
      ...request.toJson(),
      "body": {
        "content": (request as HttpAgentQueryRequest).body,
        "sender_pubkey": getPublicKey().toDer(),
        "sender_sig":
            await sign(blobFromBuffer(u8aConcat([domainSeparator, requestId.buffer]).buffer)),
      },
    };
  }
}
