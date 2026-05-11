import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../utils/extension.dart';
import '../../utils/u8a.dart';
import '../principal/principal.dart';
import 'agent/http/types.dart';
import 'request_id.dart';
import 'types.dart';

/// A Key Pair, containing a secret and public key.
@immutable
abstract class KeyPair {
  /// Creates a key pair from a [secretKey] and [publicKey].
  const KeyPair({required this.secretKey, required this.publicKey});

  /// Private key material used by the corresponding identity.
  final BinaryBlob secretKey;

  /// Public key associated with [secretKey].
  final PublicKey publicKey;
}

/// Public key material that can be serialized for IC requests.
@immutable
abstract class PublicKey {
  /// Creates a public key abstraction.
  const PublicKey();

  /// Returns the public key bytes encoded with DER.
  DerEncodedBlob toDer();
}

/// An entity that can identify itself to the Internet Computer.
///
/// Identities provide a [Principal] and can transform outgoing HTTP agent
/// requests into authenticated or anonymous request envelopes.
abstract class Identity {
  /// Creates an identity abstraction.
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

  /// Returns the IC ledger account identifier for this identity's principal.
  Uint8List getAccountId() {
    return Principal.selfAuthenticating(getPublicKey().toDer()).toAccountId();
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

/// An identity for anonymous IC requests.
///
/// Anonymous identities attach the anonymous principal and do not sign request
/// envelopes.
@immutable
class AnonymousIdentity implements Identity {
  /// Creates an anonymous identity.
  const AnonymousIdentity();

  @override
  Principal getPrincipal() => Principal.anonymous();

  @override
  Future<Map<String, dynamic>> transformRequest(HttpAgentRequest request) {
    return Future.value({
      ...request.toJson(),
      'body': {'content': request.body.toJson()},
    });
  }
}
