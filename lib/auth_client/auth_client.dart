import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/identity/delegation.dart';

class AuthClientCreateOptions {
  /// An identity to use as the base
  SignIdentity? identity;

  /// Optional storage with get, set, and remove. Uses LocalStorage by default
  // AuthClientStorage? storage;
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

  late Identity identity;
  SignIdentity? key;
  DelegationChain? chain;
  // AuthClientStorage   _storage,
  // A handle on the IdP window.
  String? authUri;
  // The event handler for processing events from the IdP.

  AuthClient({required this.identity, this.key, this.chain, this.authUri});

  //  _handleSuccess(message: InternetIdentityAuthResponseSuccess, onSuccess?: () => void) {
  //   const delegations = message.delegations.map(signedDelegation => {
  //     return {
  //       delegation: new Delegation(
  //         blobFromUint8Array(signedDelegation.delegation.pubkey),
  //         signedDelegation.delegation.expiration,
  //         signedDelegation.delegation.targets,
  //       ),
  //       signature: blobFromUint8Array(signedDelegation.signature),
  //     };
  //   });

  //   const delegationChain = DelegationChain.fromDelegations(
  //     delegations,
  //     derBlobFromBlob(blobFromUint8Array(message.userPublicKey)),
  //   );

  //   const key = this._key;
  //   if (!key) {
  //     return;
  //   }

  //   this._chain = delegationChain;
  //   this._identity = DelegationIdentity.fromDelegation(key, this._chain);

  //   this._idpWindow?.close();
  //   onSuccess?.();
  //   this._removeEventListener();
  // }

  // public getIdentity(): Identity {
  //   return this._identity;
  // }

  // public async isAuthenticated(): Promise<boolean> {
  //   return !this.getIdentity().getPrincipal().isAnonymous() && this._chain !== null;
  // }

  // public async login(options?: AuthClientLoginOptions): Promise<void> {
  //   let key = this._key;
  //   if (!key) {
  //     // Create a new key (whether or not one was in storage).
  //     key = Ed25519KeyIdentity.generate();
  //     this._key = key;
  //     await this._storage.set(KEY_LOCALSTORAGE_KEY, JSON.stringify(key));
  //   }

  //   // Create the URL of the IDP. (e.g. https://XXXX/#authorize)
  //   const identityProviderUrl = new URL(
  //     options?.identityProvider?.toString() || IDENTITY_PROVIDER_DEFAULT,
  //   );
  //   // Set the correct hash if it isn't already set.
  //   identityProviderUrl.hash = IDENTITY_PROVIDER_ENDPOINT;

  //   // If `login` has been called previously, then close/remove any previous windows
  //   // and event listeners.
  //   this._idpWindow?.close();
  //   this._removeEventListener();

  //   // Add an event listener to handle responses.
  //   this._eventHandler = this._getEventHandler(identityProviderUrl, options);
  //   window.addEventListener('message', this._eventHandler);

  //   // Open a new window with the IDP provider.
  //   this._idpWindow = window.open(identityProviderUrl.toString(), 'idpWindow') ?? undefined;
  // }

  // private _getEventHandler(identityProviderUrl: URL, options?: AuthClientLoginOptions) {
  //   return async (event: MessageEvent) => {
  //     if (event.origin !== identityProviderUrl.origin) {
  //       return;
  //     }

  //     const message = event.data as IdentityServiceResponseMessage;

  //     switch (message.kind) {
  //       case 'authorize-ready': {
  //         // IDP is ready. Send a message to request authorization.
  //         const request: InternetIdentityAuthRequest = {
  //           kind: 'authorize-client',
  //           sessionPublicKey: this._key?.getPublicKey().toDer() as Uint8Array,
  //           maxTimeToLive: options?.maxTimeToLive,
  //         };
  //         this._idpWindow?.postMessage(request, identityProviderUrl.origin);
  //         break;
  //       }
  //       case 'authorize-client-success':
  //         // Create the delegation chain and store it.
  //         try {
  //           this._handleSuccess(message, options?.onSuccess);

  //           // Setting the storage is moved out of _handleSuccess to make
  //           // it a sync function. Having _handleSuccess as an async function
  //           // messes up the jest tests for some reason.
  //           if (this._chain) {
  //             await this._storage.set(
  //               KEY_LOCALSTORAGE_DELEGATION,
  //               JSON.stringify(this._chain.toJSON()),
  //             );
  //           }
  //         } catch (err) {
  //           this._handleFailure(err.message, options?.onError);
  //         }
  //         break;
  //       case 'authorize-client-failure':
  //         this._handleFailure(message.text, options?.onError);
  //         break;
  //       default:
  //         break;
  //     }
  //   };
  // }

  // private _handleFailure(errorMessage?: string, onError?: (error?: string) => void): void {
  //   this._idpWindow?.close();
  //   onError?.(errorMessage);
  //   this._removeEventListener();
  // }

  // private _removeEventListener() {
  //   if (this._eventHandler) {
  //     window.removeEventListener('message', this._eventHandler);
  //   }
  //   this._eventHandler = undefined;
  // }

  // public async logout(options: { returnTo?: string } = {}): Promise<void> {
  //   _deleteStorage(this._storage);

  //   // Reset this auth client to a non-authenticated state.
  //   this._identity = new AnonymousIdentity();
  //   this._key = null;
  //   this._chain = null;

  //   if (options.returnTo) {
  //     try {
  //       window.history.pushState({}, '', options.returnTo);
  //     } catch (e) {
  //       window.location.href = options.returnTo;
  //     }
  //   }
  // }
}
