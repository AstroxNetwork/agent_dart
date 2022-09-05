import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/authentication/authentication.dart';
import 'package:agent_dart/identity/delegation.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/utils/extension.dart';

const keyLocalStorageKey = 'identity';
const keyLocalStorageDelegation = 'delegation';
const identityProviderDefault = 'https://identity.ic0.app';
const identityProviderEndpoint = '#authorize';

class AuthClientCreateOptions {
  const AuthClientCreateOptions({this.identity});

  /// An identity to use as the base.
  final SignIdentity? identity;
}

class AuthClientLoginOptions {
  const AuthClientLoginOptions({
    this.identityProvider,
    this.maxTimeToLive,
    this.canisterId,
    this.onSuccess,
    this.onError,
  });

  /// Identity provider. By default, use the identity service.
  final Uri? identityProvider;

  /// Expiration of the authentication
  final BigInt? maxTimeToLive;

  ///
  final String? canisterId;

  /// Callback once login has completed
  final void Function()? onSuccess;

  /// Callback in case authentication fails
  final void Function(String? error)? onError;
}

class AuthPayload {
  const AuthPayload(this.url, this.scheme);

  final String url;
  final String scheme;
}

class DelegationWithSignature {
  const DelegationWithSignature({
    required this.delegation,
    required this.signature,
  });

  final Delegation delegation;
  final Uint8List signature;
}

class FromStorageResult {
  const FromStorageResult({
    this.delegationChain,
    this.signIdentity,
    this.delegationIdentity,
  });

  final DelegationIdentity? delegationIdentity;
  final SignIdentity? signIdentity;
  final DelegationChain? delegationChain;
}

abstract class AuthResponse {
  const AuthResponse({required this.kind});

  final String kind;
}

class AuthResponseSuccess extends AuthResponse {
  const AuthResponseSuccess({
    required this.delegations,
    required this.userPublicKey,
    super.kind = 'authorize-client-success',
  });

  final List<DelegationWithSignature> delegations;
  final Uint8List userPublicKey;
}

class AuthResponseFailure extends AuthResponse {
  const AuthResponseFailure({
    required this.text,
    super.kind = 'authorize-client-failure',
  });

  final String text;
}

typedef AuthFunction = Future<String> Function(AuthPayload paylod);

class AuthClient {
  AuthClient({
    required this.scheme,
    required this.authFunction,
    this.path = '',
    this.key,
    this.chain,
    this.authUri,
    Identity? identity,
  }) : identity = identity ?? const AnonymousIdentity();

  factory AuthClient.fromMap(
    String scheme,
    AuthFunction authFunction,
    Map<String, dynamic> map,
    Uri? authUri,
  ) {
    var fromStorageResult = AuthClient.fromStorage(jsonEncode(map));
    Identity? identity = fromStorageResult.delegationIdentity;

    return AuthClient(
      scheme: scheme,
      authFunction: authFunction,
      identity: identity ?? const AnonymousIdentity(),
      key: fromStorageResult.signIdentity,
      chain: fromStorageResult.delegationChain,
      authUri: authUri,
    );
  }

  final String scheme;

  // The event handler for processing events from the IdP.
  final AuthFunction authFunction;

  // A handle on the IdP window.
  final Uri? authUri;
  final String path;

  SignIdentity? key;
  Identity? identity;
  DelegationChain? chain;

  static FromStorageResult fromStorage(String str) {
    var map = Map<String, dynamic>.from(jsonDecode(str));
    var identityString = map[keyLocalStorageKey] as String?;
    var delegationString = map[keyLocalStorageDelegation] as String?;
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
      delegationIdentity: identity,
    );
  }

  void handleSuccess(AuthResponseSuccess message, void Function()? onSuccess) {
    var delegations = message.delegations.map((signedDelegation) {
      return SignedDelegation.fromMap({
        'delegation': Delegation(
          signedDelegation.delegation.pubkey,
          signedDelegation.delegation.expiration,
          signedDelegation.delegation.targets,
        ),
        'signature': signedDelegation.signature,
      });
    }).toList();
    final delegationChain = DelegationChain.fromDelegations(
      delegations,
      message.userPublicKey,
    );
    if (key == null) {
      return;
    }
    chain = delegationChain;
    identity = DelegationIdentity.fromDelegation(key!, chain!);
    onSuccess?.call();
  }

  void handleFailure(
    String? errorMessage,
    void Function(String? error)? onError,
  ) {
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
    key ??= await Ed25519KeyIdentity.generate(null);
    // Create the URL of the IDP. (e.g. https://XXXX/#authorize)
    var payload = _createAuthPayload(options);
    var result = await authFunction(payload);
    var parsedResult = Uri.parse(result);
    if ((parsedResult.queryParameters['success'] is String &&
            parsedResult.queryParameters['success'] == 'false') ||
        parsedResult.queryParameters['success'] == null) {
      if (parsedResult.queryParameters['json'] == null) {
        var data = parsedResult.queryParameters['data'];
        var decoded = cborDecode<Map>((data as String).toU8a());
        handleFailure(jsonEncode(decoded), options?.onError);
      } else {
        handleFailure(
          jsonEncode(parsedResult.queryParameters['json']),
          options?.onError,
        );
      }
    } else if (parsedResult.queryParameters['json'] == null) {
      var data = parsedResult.queryParameters['data'];
      var decoded = cborDecode<Map>((data as String).toU8a());
      var message = Map<String, dynamic>.from(decoded);
      var delegations = message['delegations'] as List;
      var delegationList = delegations
          .map(
            (e) => DelegationWithSignature(
              delegation: Delegation.fromMap(e['delegation']),
              signature: Uint8List.fromList(e['signature']),
            ),
          )
          .toList();
      var userPublicKey = Uint8List.fromList(message['userPublicKey']);
      var response = AuthResponseSuccess(
        delegations: delegationList,
        userPublicKey: userPublicKey,
      );
      handleSuccess(response, options?.onSuccess);
    } else {
      var data = parsedResult.queryParameters['json'];
      var message = Map<String, dynamic>.from(jsonDecode(data as String));
      var delegationChain = DelegationChain.fromJSON(message);
      chain = delegationChain;
      identity = DelegationIdentity.fromDelegation(key!, chain!);
      options?.onSuccess?.call();
    }
  }

  AuthPayload _createAuthPayload(AuthClientLoginOptions? options) {
    var defaultUri = Uri.parse(
      '$identityProviderDefault/$identityProviderEndpoint',
    );
    var callbackScheme = '$scheme://$path';
    var identityProviderUrl = Uri(
      host: options?.identityProvider?.host ?? authUri?.host ?? defaultUri.host,
      scheme: options?.identityProvider?.scheme ??
          authUri?.scheme ??
          defaultUri.scheme,
      port: options?.identityProvider?.port ?? authUri?.port ?? defaultUri.port,
      fragment: options?.identityProvider?.fragment ??
          authUri?.fragment ??
          defaultUri.fragment,
      path: options?.identityProvider?.path ?? authUri?.path ?? defaultUri.path,
      queryParameters: {
        'callback_uri': callbackScheme,
        'sessionPublicKey': key != null
            ? (key as SignIdentity).getPublicKey().toDer().toHex()
            : null,
        'canisterId': options?.canisterId
      },
    );
    return AuthPayload(identityProviderUrl.toString(), scheme);
  }

  String toStorage() {
    return jsonEncode(
      {
        keyLocalStorageKey: key != null
            ? jsonEncode((key as Ed25519KeyIdentity).toJSON())
            : null,
        keyLocalStorageDelegation:
            chain != null ? jsonEncode(chain!.toJSON()) : null,
      }..removeWhere((key, value) => value == null),
    );
  }
}

Uint8List parseStringToU8a(String str) {
  var s1 = str.replaceAll('[', '');
  var s2 = s1.replaceAll(']', '');
  var newList = s2.split(',');
  return Uint8List.fromList(newList.map((e) => int.parse(e)).toList());
}
