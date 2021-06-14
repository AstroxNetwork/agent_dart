import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/identity/delegation.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/utils/extension.dart';

// ignore: constant_identifier_names
const KEY_LOCALSTORAGE_KEY = 'identity';
// ignore: constant_identifier_names
const KEY_LOCALSTORAGE_DELEGATION = 'delegation';
// ignore: constant_identifier_names
const IDENTITY_PROVIDER_DEFAULT = 'https://identity.ic0.app';
// ignore: constant_identifier_names
const IDENTITY_PROVIDER_ENDPOINT = '#authorize';

class AuthClientCreateOptions {
  /// An identity to use as the base
  SignIdentity? identity;
}

class AuthClientLoginOptions {
  /// Identity provider. By default, use the identity service.
  Uri? identityProvider;

  /// Experiation of the authentication
  BigInt? maxTimeToLive;

  /// Callback once login has completed
  void Function()? onSuccess;

  /// Callback in case authentication fails
  void Function(String? error)? onError;
}

class InternetIdentityAuthRequest {
  final String kind = 'authorize-client';
  late Uint8List sessionPublicKey;
  BigInt? maxTimeToLive;
}

class AuthPayload {
  final String url;
  final String scheme;
  AuthPayload(this.url, this.scheme);
}

class DelegationWithSignature {
  late Delegation delegation;
  late Uint8List signature;
}

abstract class AuthResponse {
  late String kind;
}

class AuthResponseSuccess extends AuthResponse {
  @override
  final String kind = 'authorize-client-success';
  late List<DelegationWithSignature> delegations;
  late Uint8List userPublicKey;
}

class AuthResponseFailure extends AuthResponse {
  @override
  final String kind = 'authorize-client-failure';
  late String text;
}

typedef AuthFunction = Future<String> Function(AuthPayload paylod);

class AuthClient {
  // public static async create(options: AuthClientCreateOptions = {}): Promise<AuthClient> {
  //   const storage = options.storage ?? new LocalStorage('ic-');

  //   let key: null | SignIdentity = null;
  //   if (options.identity) {
  //     key = options.identity;
  //   } else {
  //     const maybeIdentityStorage = await storage.get(KEY_LOCALSTORAGE_KEY);
  //     if (maybeIdentityStorage) {
  //       try {
  //         key = Ed25519KeyIdentity.fromJSON(maybeIdentityStorage);
  //       } catch (e) {
  //         // Ignore this, this means that the localStorage value isn't a valid Ed25519KeyIdentity
  //         // serialization.
  //       }
  //     }
  //   }

  //   let identity = new AnonymousIdentity();
  //   let chain: null | DelegationChain = null;

  //   if (key) {
  //     try {
  //       const chainStorage = await storage.get(KEY_LOCALSTORAGE_DELEGATION);

  //       if (chainStorage) {
  //         chain = DelegationChain.fromJSON(chainStorage);

  //         // Verify that the delegation isn't expired.
  //         if (!isDelegationValid(chain)) {
  //           await _deleteStorage(storage);
  //           key = null;
  //         } else {
  //           identity = DelegationIdentity.fromDelegation(key, chain);
  //         }
  //       }
  //     } catch (e) {
  //       console.error(e);
  //       // If there was a problem loading the chain, delete the key.
  //       await _deleteStorage(storage);
  //       key = null;
  //     }
  //   }

  //   return new this(identity, key, chain, storage);
  // }

  Identity? identity;
  SignIdentity? key;
  DelegationChain? chain;
  // A handle on the IdP window.
  Uri? authUri;
  String scheme;
  String path = "";
  // The event handler for processing events from the IdP.
  AuthFunction authFunction;

  AuthClient(
      {required this.scheme,
      required this.authFunction,
      this.identity,
      this.path = "",
      this.key,
      this.chain,
      this.authUri});

  void _handleSuccess(AuthResponseSuccess message, void Function()? onSuccess) {
    var delegations = message.delegations.map((signedDelegation) {
      return SignedDelegation.fromMap({
        "delegation": Delegation(
          blobFromUint8Array(signedDelegation.delegation.pubkey),
          signedDelegation.delegation.expiration,
          signedDelegation.delegation.targets,
        ),
        "signature": blobFromUint8Array(signedDelegation.signature),
      });
    }).toList();

    final delegationChain = DelegationChain.fromDelegations(
      delegations,
      derBlobFromBlob(blobFromUint8Array(message.userPublicKey)),
    );

    if (key == null) {
      return;
    }

    chain = delegationChain;
    identity = DelegationIdentity.fromDelegation(key!, chain!);
    onSuccess?.call();
  }

  void _handleFailure(String? errorMessage, void Function(String? error)? onError) {
    onError?.call(errorMessage);
  }

  Identity? getIdentity() {
    return identity;
  }

  Future<bool> isAuthenticated() async {
    return getIdentity() != null && !getIdentity()!.getPrincipal().isAnonymous() && chain != null;
  }

  Future<void> login([AuthClientLoginOptions? options]) async {
    key ??= Ed25519KeyIdentity.generate(null);

    // Create the URL of the IDP. (e.g. https://XXXX/#authorize)
    var payload = _createAuthPayload(options);

    var result = await authFunction(payload);

    var parsedResult = Uri.parse(result);

    if ((parsedResult.queryParameters["success"] is String &&
            parsedResult.queryParameters["success"] == "false") ||
        parsedResult.queryParameters["success"] == null) {
      var data = parsedResult.queryParameters["data"];
      var decoded = cborDecode<Map>((data as String).toU8a());

      _handleFailure(jsonEncode(decoded), options?.onError);
    } else {
      var data = parsedResult.queryParameters["data"];
      var decoded = cborDecode<Map>((data as String).toU8a());
      var message = Map<String, dynamic>.from(decoded);
      var delegations = message["delegations"] as List;

      var delegationList = delegations.map((e) {
        return DelegationWithSignature()
          ..delegation = Delegation.fromMap(e["delegation"])
          ..signature = Uint8List.fromList(e["signature"]);
      }).toList();
      var userPublicKey = Uint8List.fromList(message["userPublicKey"]);
      var response = AuthResponseSuccess()
        ..delegations = delegationList
        ..userPublicKey = userPublicKey;

      _handleSuccess(response, options?.onSuccess);
    }
  }

  AuthPayload _createAuthPayload(AuthClientLoginOptions? options) {
    var defaultUri = Uri.parse(IDENTITY_PROVIDER_DEFAULT + IDENTITY_PROVIDER_ENDPOINT);
    var callbackScheme = scheme + "://" + path;
    var identityProviderUrl = Uri(
        host: options?.identityProvider?.host ?? authUri?.host ?? defaultUri.host,
        scheme: options?.identityProvider?.scheme ?? authUri?.scheme ?? defaultUri.scheme,
        port: options?.identityProvider?.port ?? authUri?.port ?? defaultUri.port,
        fragment: options?.identityProvider?.fragment ?? authUri?.fragment ?? defaultUri.fragment,
        queryParameters: {
          "callback_uri": callbackScheme,
          "sessionPublicKey": identity != null
              ? (identity as Ed25519KeyIdentity).getPublicKey().toDer().buffer.asUint8List().toHex()
              : null
        });

    return AuthPayload(identityProviderUrl.toString(), scheme);
  }
}
