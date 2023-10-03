import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/auth.dart';
import 'package:agent_dart_base/agent/cbor.dart';
import 'package:agent_dart_base/authentication/authentication.dart';
import 'package:agent_dart_base/identity/delegation.dart';
import 'package:agent_dart_base/identity/identity.dart';
import 'package:agent_dart_base/utils/extension.dart';
import 'package:meta/meta.dart';

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

@immutable
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

  factory AuthClient.fromJson(
    String scheme,
    AuthFunction authFunction,
    Map<String, dynamic> map,
    Uri? authUri,
  ) {
    final fromStorageResult = AuthClient.fromStorage(jsonEncode(map));
    final Identity? identity = fromStorageResult.delegationIdentity;

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
    final map = Map<String, dynamic>.from(jsonDecode(str));
    final identityString = map[keyLocalStorageKey] as String?;
    final delegationString = map[keyLocalStorageDelegation] as String?;
    SignIdentity? key = identityString != null
        ? Ed25519KeyIdentity.fromJSON(identityString)
        : null;
    final DelegationChain? chain = delegationString != null
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
    final delegations = message.delegations.map((signedDelegation) {
      return SignedDelegation.fromJson({
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
    final payload = _createAuthPayload(options);
    final result = await authFunction(payload);
    final parsedResult = Uri.parse(result);
    if ((parsedResult.queryParameters['success'] is String &&
            parsedResult.queryParameters['success'] == 'false') ||
        parsedResult.queryParameters['success'] == null) {
      if (parsedResult.queryParameters['json'] == null) {
        final data = parsedResult.queryParameters['data'];
        final decoded = cborDecode<Map>((data as String).toU8a());
        handleFailure(jsonEncode(decoded), options?.onError);
      } else {
        handleFailure(
          jsonEncode(parsedResult.queryParameters['json']),
          options?.onError,
        );
      }
    } else if (parsedResult.queryParameters['json'] == null) {
      final data = parsedResult.queryParameters['data'];
      final decoded = cborDecode<Map>((data as String).toU8a());
      final message = Map<String, dynamic>.from(decoded);
      final delegations = message['delegations'] as List;
      final delegationList = delegations
          .map(
            (e) => DelegationWithSignature(
              delegation: Delegation.fromJson(e['delegation']),
              signature: Uint8List.fromList(e['signature']),
            ),
          )
          .toList();
      final userPublicKey = Uint8List.fromList(message['userPublicKey']);
      final response = AuthResponseSuccess(
        delegations: delegationList,
        userPublicKey: userPublicKey,
      );
      handleSuccess(response, options?.onSuccess);
    } else {
      final data = parsedResult.queryParameters['json'];
      final message = Map<String, dynamic>.from(jsonDecode(data as String));
      final delegationChain = DelegationChain.fromJSON(message);
      chain = delegationChain;
      identity = DelegationIdentity.fromDelegation(key!, chain!);
      options?.onSuccess?.call();
    }
  }

  AuthPayload _createAuthPayload(AuthClientLoginOptions? options) {
    final defaultUri = Uri.parse(
      '$identityProviderDefault/$identityProviderEndpoint',
    );
    final callbackScheme = '$scheme://$path';
    final identityProviderUrl = Uri(
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
            ? jsonEncode((key as Ed25519KeyIdentity).toJson())
            : null,
        keyLocalStorageDelegation:
            chain != null ? jsonEncode(chain!.toJson()) : null,
      }..removeWhere((key, value) => value == null),
    );
  }
}

Uint8List parseStringToU8a(String str) {
  final s1 = str.replaceAll('[', '');
  final s2 = s1.replaceAll(']', '');
  final newList = s2.split(',');
  return Uint8List.fromList(newList.map((e) => int.parse(e)).toList());
}
