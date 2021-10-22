import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/authentication/authentication.dart';
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

  ///
  String? canisterId;

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

class FromStorageResult {
  DelegationIdentity? delegationIdentity;
  SignIdentity? signIdentity;
  DelegationChain? delegationChain;
  FromStorageResult(
      {this.delegationChain, this.signIdentity, this.delegationIdentity});
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
  Identity? identity;
  SignIdentity? key;
  DelegationChain? chain;
  // A handle on the IdP window.
  Uri? authUri;
  String scheme;
  String path = "";
  // The event handler for processing events from the IdP.
  AuthFunction authFunction;

  AuthClient({
    required this.scheme,
    required this.authFunction,
    this.identity,
    this.path = "",
    this.key,
    this.chain,
    this.authUri,
  }) {
    identity ??= AnonymousIdentity();
  }

  static FromStorageResult fromStorage(String str) {
    var map = Map<String, dynamic>.from(jsonDecode(str));
    var identityString = map[KEY_LOCALSTORAGE_KEY] as String?;
    var delegationString = map[KEY_LOCALSTORAGE_DELEGATION] as String?;

    SignIdentity? key = identityString != null
        ? Ed25519KeyIdentity.fromJSON(identityString)
        : null;
    DelegationChain? chain = delegationString != null
        ? DelegationChain.fromJSON(delegationString)
        : null;

    DelegationIdentity? identity;

    if (chain != null && !isDelegationValid(chain, null)) {
      key = null;
    } else {
      identity = DelegationIdentity.fromDelegation(key!, chain!);
    }
    return FromStorageResult(
        delegationChain: chain,
        signIdentity: key,
        delegationIdentity: identity);
  }

  factory AuthClient.fromMap(String scheme, AuthFunction authFunction,
      Map<String, dynamic> map, Uri? authUri) {
    var fromStorageResult = AuthClient.fromStorage(jsonEncode(map));
    Identity? identity = fromStorageResult.delegationIdentity;

    return AuthClient(
        scheme: scheme,
        authFunction: authFunction,
        identity: identity ?? AnonymousIdentity(),
        key: fromStorageResult.signIdentity,
        chain: fromStorageResult.delegationChain,
        authUri: authUri);
  }

  void handleSuccess(AuthResponseSuccess message, void Function()? onSuccess) {
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

  void handleFailure(
      String? errorMessage, void Function(String? error)? onError) {
    onError?.call(errorMessage);
  }

  Identity? getIdentity() {
    return identity;
  }

  Future<bool> isAuthenticated() async {
    return getIdentity() != null &&
        !getIdentity()!.getPrincipal().isAnonymous() &&
        chain != null;
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
      if (parsedResult.queryParameters["json"] == null) {
        var data = parsedResult.queryParameters["data"];
        var decoded = cborDecode<Map>((data as String).toU8a());
        handleFailure(jsonEncode(decoded), options?.onError);
      } else {
        handleFailure(
            jsonEncode(parsedResult.queryParameters["json"]), options?.onError);
      }
    } else if (parsedResult.queryParameters["json"] == null) {
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

      handleSuccess(response, options?.onSuccess);
    } else {
      var data = parsedResult.queryParameters["json"];
      var message = Map<String, dynamic>.from(jsonDecode(data as String));
      var delegationChain = DelegationChain.fromJSON(message);
      chain = delegationChain;
      identity = DelegationIdentity.fromDelegation(key!, chain!);
      options?.onSuccess?.call();
    }
  }

  AuthPayload _createAuthPayload(AuthClientLoginOptions? options) {
    var defaultUri =
        Uri.parse(IDENTITY_PROVIDER_DEFAULT + '/' + IDENTITY_PROVIDER_ENDPOINT);
    var callbackScheme = scheme + "://" + path;
    var identityProviderUrl = Uri(
        host:
            options?.identityProvider?.host ?? authUri?.host ?? defaultUri.host,
        scheme: options?.identityProvider?.scheme ??
            authUri?.scheme ??
            defaultUri.scheme,
        port:
            options?.identityProvider?.port ?? authUri?.port ?? defaultUri.port,
        fragment: options?.identityProvider?.fragment ??
            authUri?.fragment ??
            defaultUri.fragment,
        path:
            options?.identityProvider?.path ?? authUri?.path ?? defaultUri.path,
        queryParameters: {
          "callback_uri": callbackScheme,
          "sessionPublicKey": key != null
              ? (key as SignIdentity).getPublicKey().toDer().toHex()
              : null,
          "canisterId": options?.canisterId
        });

    return AuthPayload(identityProviderUrl.toString(), scheme);
  }

  String toStorage() {
    return jsonEncode({
      KEY_LOCALSTORAGE_KEY: identity != null
          ? jsonEncode((identity as Ed25519KeyIdentity).toJSON())
          : null,
      KEY_LOCALSTORAGE_DELEGATION:
          chain != null ? jsonEncode(chain!.toJSON()) : null,
    }..removeWhere((key, value) => value == null));
  }
}

Uint8List parseStringToU8a(String str) {
  var s1 = str.replaceAll("[", "");
  var s2 = s1.replaceAll("]", "");
  var newList = s2.split(",");
  return Uint8List.fromList(newList.map((e) => int.parse(e)).toList());
}
