import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/delegation.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/principal/principal.dart';

// ignore: constant_identifier_names
const DEFAULT_IDENTITY_PROVIDER_URL = 'https://auth.ic0.app/authorize';

_getDefaultLocation() {
  return '';
}

/// Options for {@link createAuthenticationRequestUrl}. All these options may be limited
/// further by the identity provider, or an error can happen.
class CreateUrlOptions {
  /// The public key to delegate to. This should be the public key of the session key.
  late PublicKey publicKey;

  /// The scope of the delegation. This must contain at least one key and a maximum
  /// of four. This is validated in {@link createAuthenticationRequestUrl} but also
  /// will be validated as part of the identity provider.
  late List<dynamic> scope;

  /// The URI to redirect to, after authentication. By default, `window.location.origin`.
  Uri? redirectUri; //URI

  /// The URL base to use for the identity provider.
  /// By default, this is "https://auth.ic0.app/authorize".
  String? identityProvider;
}

/// List of things to check for a delegation chain validity.
class DelegationValidChecks {
  /// Check that the scope is amongst the scopes that this delegation has access to.
  dynamic scope; //?: Principal | string | Array<Principal | string>;
}

// export type AccessToken = string & { _BRAND: 'access_token' };

/// Create a URL that can be used to redirect the browser to request authentication (e.g. using
/// the authentication provider). Will throw if some options are invalid.
/// @param options An option with all options for the authentication request.
Uri createAuthenticationRequestUrl(CreateUrlOptions options) {
  var url = Uri.parse(options.identityProvider?.toString() ?? DEFAULT_IDENTITY_PROVIDER_URL);
  url.queryParameters.addEntries([
    const MapEntry('response_type', 'token'),
    MapEntry('login_hint', options.publicKey.toDer().toHex()),
    MapEntry('redirect_uri', options.redirectUri ?? _getDefaultLocation()),
    MapEntry(
      'scope',
      options.scope
          .map((p) {
            if (p is String) {
              return Principal.fromText(p);
            } else {
              return p;
            }
          })
          .map((p) => p.toString())
          .join(' '),
    ),
    const MapEntry('state', '')
  ]);

  return url;
}

/// Returns an AccessToken from the Window object. This cannot be used in Node, instead use
/// the {@link getAccessTokenFromURL} function.
///
/// An access token is needed to create a DelegationChain object.
getAccessTokenFromWindow(dynamic link) {
  // in flutter , we use deeplink to pass the uri, we just save here
  return getAccessTokenFromURL(link);
}

/// Analyze a URL and try to extract an AccessToken from it.
/// @param url The URL to look into.
String? getAccessTokenFromURL(dynamic url) {
  try {
    Uri uri = url is String ? Uri.parse(url) : url;
    var query =
        Uri.tryParse(uri.fragment.startsWith("/") ? uri.fragment.substring(1) : uri.fragment)
            ?.queryParameters;
    return query?["access_token"];
  } catch (e) {
    rethrow;
  }
}

/// Create a DelegationChain from an AccessToken extracted from a redirect URL.
/// @param accessToken The access token extracted from a redirect URL.
DelegationChain createDelegationChainFromAccessToken(String accessToken) {
  // Transform the HEXADECIMAL string into the JSON it represents.
  if (!isHexadecimal(accessToken) || (accessToken.length % 2) != 0) {
    throw 'Invalid hexadecimal string for accessToken.';
  }

  var strList = accessToken.split("");

  var value = List<String>.from([], growable: true);

  List<String> combineFunc(List<String> acc, String curr, int i) {
    var index = (i ~/ 2) | 0;
    var resultAcc = List<String>.from(acc);

    if (index < resultAcc.length) {
      resultAcc[index] = resultAcc[index] + curr;
    } else {
      resultAcc.add('' + curr);
    }
    return resultAcc;
  }

  for (var i = 0; i < strList.length; i += 1) {
    value = combineFunc(value, strList[i], i);
  }

  var chainJson = value
      .map((e) => int.parse(e, radix: 16))
      .toList()
      .map((e) => String.fromCharCode(e))
      .join("");

  return DelegationChain.fromJSON(chainJson);
}

/// Analyze a DelegationChain and validate that it's valid, ie. not expired and apply to the
/// scope.
/// @param chain The chain to validate.
/// @param checks Various checks to validate on the chain.
isDelegationValid(DelegationChain chain, DelegationValidChecks? checks) {
  // Verify that the no delegation is expired. If any are in the chain, returns false.
  for (var d in chain.delegations) {
    var delegation = d.delegation!;
    var exp = delegation.expiration;
    var t = exp / BigInt.from(1000000);
    // prettier-ignore
    if (DateTime.fromMillisecondsSinceEpoch(t.toInt()).isBefore(DateTime.now())) {
      return false;
    }
  }

  // Check the scopes.
  var scopes = <Principal>[];

  var maybeScope = checks?.scope;

  if (maybeScope != null) {
    if (maybeScope is List) {
      scopes.addAll(
          maybeScope.map((s) => (s is String ? Principal.fromText(s) : (s as Principal))).toList());
    } else {
      scopes.addAll(maybeScope is String ? Principal.fromText(maybeScope) : maybeScope);
    }
  }

  for (var s in scopes) {
    var scope = s.toText();
    for (var d in chain.delegations) {
      var delegation = d.delegation;
      if (delegation == null || delegation.targets == null) {
        continue;
      }

      var none = true;
      var targets = delegation.targets;
      for (var target in targets!) {
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
