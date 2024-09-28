import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/auth_client/auth_client.dart'
    show identityProviderDefault;
import 'package:agent_dart/identity/delegation.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/is.dart';

/// Options for {@link createAuthenticationRequestUrl}.
/// All these options may be limited further by the identity provider,
/// or an error can happen.
class CreateUrlOptions {
  const CreateUrlOptions({
    required this.publicKey,
    required this.scope,
    this.redirectUri,
    this.identityProvider,
  });

  /// The public key to delegate to. This should be the public key of the
  /// session key.
  final PublicKey publicKey;

  /// The scope of the delegation. This must contain at least one key and
  /// a maximum of four. This is validated in [createAuthenticationRequestUrl]
  /// but also will be validated as part of the identity provider.
  final List<dynamic> scope;

  /// The URI to redirect to, after authentication. By default,
  /// `window.location.origin`.
  final Uri? redirectUri;

  /// The URL base to use for the identity provider.
  /// By default, this is "https://auth.ic0.app/authorize".
  final String? identityProvider;
}

/// List of things to check for a delegation chain validity.
class DelegationValidChecks {
  const DelegationValidChecks({required this.scope});

  /// Check that the scope is amongst the scopes that this delegation
  /// has access to.
  final dynamic scope; //?: Principal | string | Array<Principal | string>;
}

// export type AccessToken = string & { _BRAND: 'access_token' };

/// Create a URL that can be used to redirect the browser to request
/// authentication (e.g. using the authentication provider). Will throw if some
/// options are invalid.
Uri createAuthenticationRequestUrl(CreateUrlOptions options) {
  final url = Uri.parse(
    options.identityProvider?.toString() ??
        '$identityProviderDefault/authorize',
  );
  url.queryParameters.addEntries([
    const MapEntry('response_type', 'token'),
    MapEntry('login_hint', options.publicKey.toDer().toHex()),
    MapEntry('redirect_uri', options.redirectUri?.toString() ?? ''),
    MapEntry(
      'scope',
      options.scope
          .map((p) => p is String ? Principal.fromText(p) : p)
          .map((p) => p.toString())
          .join(' '),
    ),
    const MapEntry('state', ''),
  ]);

  return url;
}

/// Returns an AccessToken from the Window object. This cannot be used in Node,
/// instead use the {@link getAccessTokenFromURL} function.
///
/// An access token is needed to create a DelegationChain object.
String? getAccessTokenFromWindow(dynamic link) {
  // In flutter , we use deeplink to pass the uri, we just save here.
  return getAccessTokenFromURL(link);
}

/// Analyze a URL and try to extract an AccessToken from it.
/// @param url The URL to look into.
String? getAccessTokenFromURL(dynamic url) {
  final uri = url is String ? Uri.parse(url) : url;
  final query = Uri.tryParse(
    uri.fragment.startsWith('/') ? uri.fragment.substring(1) : uri.fragment,
  )?.queryParameters;
  return query?['access_token'];
}

/// Create a DelegationChain from an AccessToken extracted from a redirect URL.
/// @param accessToken The access token extracted from a redirect URL.
DelegationChain createDelegationChainFromAccessToken(String accessToken) {
  // Transform the HEXADECIMAL string into the JSON it represents.
  if (!isHex(accessToken)) {
    throw ArgumentError.value(
      accessToken,
      'accessToken',
      'Invalid hexadecimal string',
    );
  }
  final strList = accessToken.split('');
  List<String> value = List<String>.from([]);

  List<String> combineFunc(List<String> acc, String curr, int i) {
    final index = (i ~/ 2) | 0;
    final resultAcc = List<String>.from(acc);

    if (index < resultAcc.length) {
      resultAcc[index] = resultAcc[index] + curr;
    } else {
      resultAcc.add(curr);
    }
    return resultAcc;
  }

  for (int i = 0; i < strList.length; i += 1) {
    value = combineFunc(value, strList[i], i);
  }

  final chainJson = value
      .map((e) => int.parse(e, radix: 16))
      .toList()
      .map((e) => String.fromCharCode(e))
      .join();

  return DelegationChain.fromJSON(chainJson);
}

/// Analyze a DelegationChain and validate that it's valid, ie. not expired and
/// apply to the scope.
///
/// @param chain The chain to validate.
/// @param checks Various checks to validate on the chain.
bool isDelegationValid(DelegationChain chain, DelegationValidChecks? checks) {
  // Verify that the no delegation is expired.
  // If any are in the chain, returns false.
  for (final d in chain.delegations) {
    final delegation = d.delegation!;
    final exp = delegation.expiration;
    final t = exp / BigInt.from(1000000);
    // prettier-ignore
    if (DateTime.fromMillisecondsSinceEpoch(t.toInt())
        .isBefore(DateTime.now())) {
      return false;
    }
  }

  // Check the scopes.
  final scopes = <Principal>[];
  final maybeScope = checks?.scope;
  if (maybeScope != null) {
    if (maybeScope is List) {
      scopes.addAll(
        maybeScope
            .map(
              (s) => s is String ? Principal.fromText(s) : (s as Principal),
            )
            .toList(),
      );
    } else {
      scopes.addAll(
        maybeScope is String ? Principal.fromText(maybeScope) : maybeScope,
      );
    }
  }
  for (final s in scopes) {
    final scope = s.toText();
    for (final d in chain.delegations) {
      final delegation = d.delegation;
      if (delegation == null || delegation.targets == null) {
        continue;
      }
      bool none = true;
      final targets = delegation.targets;
      for (final target in targets!) {
        if (target.toText() == scope) {
          none = false;
          break;
        }
      }
      if (none) {
        return false;
      }
    }
  }
  return true;
}
