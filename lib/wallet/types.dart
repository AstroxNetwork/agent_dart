/// The network identifier specifies which network a particular object is
/// associated with.
class NetworkIdentifier {
  const NetworkIdentifier(
    this.blockchain,
    this.network,
    this.subNetworkIdentifier,
  );

  factory NetworkIdentifier.fromMap(Map<String, dynamic> map) {
    return NetworkIdentifier(
      map['blockchain'],
      map['network'],
      map['sub_network_identifier'] != null
          ? SubNetworkIdentifier.fromMap(map['sub_network_identifier'])
          : null,
    );
  }

  final String blockchain;

  /// If a blockchain has a specific chain-id or network identifier,
  /// it should go in this field. It is up to the client to determine which
  /// network-specific identifier is mainnet or testnet.
  final String network;
  final SubNetworkIdentifier? subNetworkIdentifier;

  Map<String, dynamic> toJson() => {
        'blockchain': blockchain,
        'network': network,
        'sub_network_identifier': subNetworkIdentifier?.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// In blockchains with sharded state, the SubNetworkIdentifier is required to
/// query some object on a specific shard. This identifier is optional for all
/// non-sharded blockchains.
class SubNetworkIdentifier {
  const SubNetworkIdentifier(this.network, this.metadata);

  factory SubNetworkIdentifier.fromMap(Map<String, dynamic> map) {
    return SubNetworkIdentifier(
      map['network'],
      map['metadata'],
    );
  }

  final String network;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {'network': network, 'metadata': metadata}
    ..removeWhere((key, dynamic value) => value == null);
}

/// The block_identifier uniquely identifies a block in a particular network.
class BlockIdentifier {
  const BlockIdentifier(this.index, this.hash);

  factory BlockIdentifier.fromMap(Map<String, dynamic> map) {
    return BlockIdentifier(map['index'], map['hash']);
  }

  /// This is also known as the block height.
  final int index;
  final String hash;

  Map<String, dynamic> toJson() => {'index': index, 'hash': hash}
    ..removeWhere((key, dynamic value) => value == null);
}

/// When fetching data by BlockIdentifier, it may be possible to only specify
/// the index or hash. If neither property is specified, it is assumed that
/// the client is making a request at the current block.
class PartialBlockIdentifier {
  const PartialBlockIdentifier(this.index, this.hash);

  factory PartialBlockIdentifier.fromMap(Map<String, dynamic> map) {
    return PartialBlockIdentifier(map['index'], map['hash']);
  }

  final int? index;
  final String? hash;

  Map<String, dynamic> toJson() => {'index': index, 'hash': hash}
    ..removeWhere((key, dynamic value) => value == null);
}

/// The transaction_identifier uniquely identifies a transaction in a particular
/// network and block or in the mem-pool.
class TransactionIdentifier {
  const TransactionIdentifier(this.hash);

  factory TransactionIdentifier.fromMap(Map<String, dynamic> map) {
    return TransactionIdentifier(map['hash']);
  }

  /// Any transactions that are attributable only to a block (ex: a block event)
  /// should use the hash of the block as the identifier.
  final String hash;

  Map<String, dynamic> toJson() =>
      {'hash': hash}..removeWhere((key, dynamic value) => value == null);
}

/// The operation_identifier uniquely identifies an operation within a transaction.
class OperationIdentifier {
  const OperationIdentifier(this.index, this.networkIndex);

  factory OperationIdentifier.fromMap(Map<String, dynamic> map) {
    return OperationIdentifier(map['index'], map['network_index']);
  }

  /// The operation index is used to ensure each operation has a unique
  /// identifier within a transaction. This index is only relative to the
  /// transaction and NOT GLOBAL. The operations in each transaction should
  /// start from index 0. To clarify, there may not be any notion of
  /// an operation index in the blockchain being described.
  final int index;

  /// Some blockchains specify an operation index that is essential for
  /// client use. For example, Bitcoin uses a network_index to identify which
  /// UTXO was used in a transaction. network_index should not be populated
  /// if there is no notion of an operation index in a blockchain
  /// (typically most account-based blockchains).
  final int? networkIndex;

  Map<String, dynamic> toJson() => {
        'index': index,
        'network_index': networkIndex
      }..removeWhere((key, dynamic value) => value == null);
}

/// The account identifier uniquely identifies an account within a network.
/// All fields in the [AccountIdentifier] are utilized to determine
/// this uniqueness (including the [metadata] field, if populated).
class AccountIdentifier {
  const AccountIdentifier(this.address, this.subAccount, this.metadata);

  factory AccountIdentifier.fromMap(Map<String, dynamic> map) {
    return AccountIdentifier(
      map['address'],
      map['sub_account'] != null
          ? SubAccountIdentifier.fromMap(map['sub_account'])
          : null,
      map['metadata'],
    );
  }

  /// The address may be a cryptographic public key (or some encoding of it)
  /// or a provided username.
  final String address;

  final SubAccountIdentifier? subAccount;

  /// Blockchains that utilize a username model
  /// (where the address is not a derivative of a cryptographic public key)
  /// should specify the public key(s) owned by the address in metadata.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'address': address,
        'sub_account': subAccount?.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// An account may have state specific to a contract address (ERC-20 token)
/// and/or a stake (delegated balance). The [SubAccountIdentifier] should
/// specify which state (if applicable) an account instantiation refers to.
class SubAccountIdentifier {
  const SubAccountIdentifier(this.address, this.metadata);

  factory SubAccountIdentifier.fromMap(Map<String, dynamic> map) {
    return SubAccountIdentifier(map['address'], map['metadata']);
  }

  /// The SubAccount address may be a cryptographic value or some other
  /// identifier (ex: bonded) that uniquely specifies a SubAccount.
  final String address;

  /// If the SubAccount address is not sufficient to uniquely specify a
  /// sub-account, any other identifying information can be stored here.
  /// It is important to note that two SubAccounts with identical addresses
  /// but differing metadata will not be considered equal by clients.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {'address': address, 'metadata': metadata}
    ..removeWhere((key, dynamic value) => value == null);
}

/// Blocks contain an array of Transactions that occurred at
/// a particular [BlockIdentifier]. A hard requirement for blocks returned by
/// Rosetta implementations is that they MUST be _unalterable_:
/// once a client has requested and received a block identified by a specific
/// [BlockIdentifier], all future calls for that same BlockIdentifier must
/// return the same block contents.
class Block {
  const Block(
    this.blockIdentifier,
    this.parentBlockIdentifier,
    this.timestamp,
    this.transactions,
    this.metadata,
  );

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
      BlockIdentifier.fromMap(map['block_identifier']),
      BlockIdentifier.fromMap(map['parent_block_identifier']),
      map['timestamp'],
      (map['transactions'] as List).map((e) => Transaction.fromMap(e)).toList(),
      map['metadata'],
    );
  }

  final BlockIdentifier blockIdentifier;
  final BlockIdentifier parentBlockIdentifier;
  final Timestamp timestamp;
  final List<Transaction> transactions;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'block_identifier': blockIdentifier.toJson(),
        'parent_block_identifier': parentBlockIdentifier.toJson(),
        'timestamp': timestamp,
        'transactions': transactions.map((e) => e.toJson()),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// Transactions contain an array of [Operation]s that are attributable to
/// the same [TransactionIdentifier].
class Transaction {
  const Transaction(this.transactionIdentifier, this.operations, this.metadata);

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      TransactionIdentifier.fromMap(map['transaction_identifier']),
      (map['operations'] as List).map((e) => Operation.fromMap(e)).toList(),
      map['metadata'],
    );
  }

  final TransactionIdentifier transactionIdentifier;
  final List<Operation> operations;

  /// Transactions that are related to other transactions
  /// (like a cross-shard transaction) should include the
  /// [TransactionIdentifier] of these transactions in the metadata.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'transaction_identifier': transactionIdentifier.toJson(),
        'operations': operations.map((e) => e.toJson()).toList(),
        'metadata': metadata,
      }..removeWhere((key, dynamic value) => value == null);
}

/// Operations contain all balance-changing information within a transaction.
/// They are always one-sided (only affect 1 AccountIdentifier) and can succeed
/// or fail independently from a Transaction. Operations are used both to
/// represent on-chain data (Data API) and to construct new transactions
/// (Construction API), creating a standard interface for reading
/// and writing to blockchains.
class Operation {
  const Operation(
    this.type,
    this.operationIdentifier,
    this.relatedOperations,
    this.status,
    this.account,
    this.amount,
    this.coinChange,
    this.metadata,
  );

  factory Operation.fromMap(Map<String, dynamic> map) {
    return Operation(
      map['type'],
      OperationIdentifier.fromMap(map['operation_identifier']),
      map['related_operations'] != null
          ? (map['related_operations'] as List)
              .map((e) => OperationIdentifier.fromMap(e))
              .toList()
          : null,
      map['status'],
      map['account'] != null ? AccountIdentifier.fromMap(map['account']) : null,
      map['amount'] != null ? Amount.fromMap(map['amount']) : null,
      map['coin_change'] != null
          ? CoinChange.fromMap(map['coin_change'])
          : null,
      map['metadata'],
    );
  }

  /// Type is the network-specific type of the operation. Ensure that any type
  /// that can be returned here is also specified in
  /// the [NetworkOptionsResponse]. This can be very useful to
  /// downstream consumers that parse all block data.
  final String type;

  final OperationIdentifier operationIdentifier;

  /// Restrict referenced related_operations to
  /// identifier indexes < the current [OperationIdentifier.index].
  /// This ensures there exists a clear DAG-structure of relations.
  /// Since operations are one-sided, one could imagine relating operations in
  /// a single transfer or linking operations in a call tree.
  final List<OperationIdentifier>? relatedOperations;

  /// Status is the network-specific status of the operation.
  /// Status is not defined on the transaction object because blockchains with
  /// smart contracts may have transactions that partially apply
  /// (some operations are successful and some are not).
  /// Blockchains with atomic transactions
  /// (all operations succeed or all operations fail)
  /// will have the same status for each operation. On-chain operations
  /// (operations retrieved in the `/block` and `/block/transaction` endpoints)
  /// MUST have a populated status field
  /// (anything on-chain must have succeeded or failed).
  /// However, operations provided during transaction construction
  /// (often times called "intent" in the documentation)
  /// MUST NOT have a populated status field
  /// (operations yet to be included on-chain have not yet succeeded or failed).
  final String? status;
  final AccountIdentifier? account;
  final Amount? amount;

  final CoinChange? coinChange;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'type': type,
        'operation_identifier': operationIdentifier.toJson(),
        'related_operations':
            relatedOperations?.map((e) => e.toJson()).toList(),
        'status': status,
        'account': account?.toJson(),
        'amount': amount?.toJson(),
        'coin_change': coinChange?.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// Amount is some Value of a Currency. It is considered invalid to specify a Value without a Currency.
class Amount {
  const Amount(this.value, this.currency, this.metadata);

  factory Amount.fromMap(Map<String, dynamic> map) {
    return Amount(
      map['value'],
      Currency.fromMap(map['currency']),
      map['metadata'],
    );
  }

  /// Value of the transaction in atomic units represented
  /// as an arbitrary-sized signed integer.
  /// For example, 1 BTC would be represented by a value of 100000000.
  final String value;
  final Currency currency;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'value': value,
        'currency': currency.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// Currency is composed of a canonical Symbol and Decimals.
/// This Decimals value is used to convert an Amount.Value from atomic units
/// (Satoshi) to standard units (Bitcoin).
class Currency {
  const Currency(this.symbol, this.decimals, this.metadata);

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(map['symbol'], map['decimals'], map['metadata']);
  }

  /// Canonical symbol associated with a currency.
  final String symbol;

  /// Number of decimal places in the standard unit representation of the amount.
  /// For example, BTC has 8 decimals. Note that it is not possible to represent
  /// the value of some currency in atomic units that is not base 10.
  final int decimals;

  /// Any additional information related to the currency itself.
  /// For example, it would be useful to populate this object with the
  /// contract address of an ERC-20 token.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'decimals': decimals,
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// SyncStatus is used to provide additional context about an implementation's
/// sync status. It is often used to indicate that an implementation is healthy
/// when it cannot be queried  until some sync phase occurs.
/// If an implementation is immediately queryable,
/// this model is often not populated.
class SyncStatus {
  const SyncStatus(this.currentIndex, this.targetIndex, this.stage);

  factory SyncStatus.fromMap(Map<String, dynamic> map) {
    return SyncStatus(map['current_index'], map['target_index'], map['stage']);
  }

  /// CurrentIndex is the index of the last synced block in the current stage.
  final int currentIndex;

  /// TargetIndex is the index of the block that the implementation
  /// is attempting to sync to in the current stage.
  final int? targetIndex;

  /// Stage is the phase of the sync process.
  final String? stage;

  Map<String, dynamic> toJson() => {
        'current_index': currentIndex,
        'target_index': targetIndex,
        'stage': stage
      }..removeWhere((key, dynamic value) => value == null);
}

/// A Peer is a representation of a node's peer.
class Peer {
  const Peer(this.peerId, this.metadata);

  factory Peer.fromMap(Map<String, dynamic> map) {
    return Peer(map['peer_id'], map['metadata']);
  }

  final String peerId;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {'peer_id': peerId, 'metadata': metadata}
    ..removeWhere((key, dynamic value) => value == null);
}

/// The Version object is utilized to inform the client of the versions of
/// different components of the Rosetta implementation.
class Version {
  const Version(
    this.rosettaVersion,
    this.nodeVersion,
    this.middlewareVersion,
    this.metadata,
  );

  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      map['rosetta_version'],
      map['node_version'],
      map['middleware_version'],
      map['metadata'],
    );
  }

  /// The rosetta_version is the version of the Rosetta interface
  /// the implementation adheres to. This can be useful for clients looking to
  /// reliably parse responses.
  final String rosettaVersion;

  /// The node_version is the canonical version of the node runtime.
  /// This can help clients manage deployments.
  final String nodeVersion;

  /// When a middleware server is used to adhere to the Rosetta interface,
  /// it should return its version here.
  /// This can help clients manage deployments.
  final String? middlewareVersion;

  /// Any other information that may be useful about versioning of
  /// dependent services should be returned here.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'rosetta_version': rosettaVersion,
        'node_version': nodeVersion,
        'middleware_version': middlewareVersion,
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// Allow specifies supported Operation status, Operation types,
/// and all possible error statuses. This Allow object is used by clients to
/// validate the correctness of a Rosetta Server implementation.
/// It is expected that these clients will error if they receive some response
/// that contains any of the above information that is not specified here.
class Allow {
  const Allow(
    this.operationStatus,
    this.operationTypes,
    this.errors,
    this.historicalBalanceLookup,
    this.callMethods,
    this.balanceExemptions,
    this.mempoolCoins,
    this.timestampStartIndex,
  );

  factory Allow.fromMap(Map<String, dynamic> map) {
    return Allow(
      (map['operation_statuses'] as List)
          .map((e) => OperationStatus.fromMap(e))
          .toList(),
      (map['operation_types'] as List).map((e) => e.toString()).toList(),
      (map['errors'] as List).map((e) => RosettaError.fromMap(e)).toList(),
      map['historical_balance_lookup'],
      (map['call_methods'] as List).map((e) => e.toString()).toList(),
      (map['balance_exemptions'] as List)
          .map((e) => BalanceExemption.fromMap(e))
          .toList(),
      map['mempool_coins'],
      map['timestamp_start_index'],
    );
  }

  /// All [Operation.status] this implementation supports.
  /// Any status that is returned during parsing that is not listed here
  /// will cause client validation to error.
  final List<OperationStatus> operationStatus;

  /// All [Operation]s. Type this implementation supports.
  /// Any type that is returned during parsing that is not listed here
  /// will cause client validation to error.
  final List<String> operationTypes;

  /// All [RosettaError] that this implementation could return.
  /// Any error that is returned during parsing that is not listed here
  /// will cause client validation to error.
  final List<RosettaError> errors;

  /// Any Rosetta implementation that supports querying the balance of
  /// an account at any height in the past should set this to true.
  final bool historicalBalanceLookup;

  /// If populated, [timestampStartIndex] indicates the first block index
  /// where block timestamps are considered valid (i.e. all blocks less than
  /// [timestampStartIndex] could have invalid timestamps). This is useful
  /// when the genesis block (or blocks) of a network have timestamp 0. If not
  /// populated, block timestamps are assumed valid for all available blocks.
  final int? timestampStartIndex;

  /// All methods that are supported by the /call endpoint.
  /// Communicating which parameters should be provided to /call is
  /// the responsibility of the implementer (this is en lieu of defining an
  /// entire type system and requiring the implementer to define that in [Allow]).
  final List<String> callMethods;

  /// BalanceExemptions is an array of [BalanceExemption] indicating
  /// which account balances could change without a corresponding [Operation].
  /// [balanceExemptions] should be used sparingly as they may introduce
  /// significant complexity for integrators that attempt to reconcile
  /// all account balance changes. If your implementation relies on any
  /// [BalanceExemption]s, you MUST implement historical balance lookup
  /// (the ability to query an account balance at any [BlockIdentifier]).
  final List<BalanceExemption> balanceExemptions;

  /// Any Rosetta implementation that can update an [AccountIdentifier]'s
  /// unspent coins based on the contents of the mem-pool should populate
  /// this field as true. If false, requests to `/account/coins` that set
  /// `include_mempool` as true will be automatically rejected.
  final bool mempoolCoins;

  Map<String, dynamic> toJson() => {
        'operation_statuses': operationStatus.map((e) => e.toJson()).toList(),
        'operation_types': operationTypes.map((e) => e.toString()).toList(),
        'errors': errors.map((e) => e.toJson()).toList(),
        'historical_balance_lookup': historicalBalanceLookup,
        'call_methods': callMethods.map((e) => e.toString()).toList(),
        'balance_exemptions':
            balanceExemptions.map((e) => e.toString()).toList(),
        'mempool_coins': mempoolCoins,
        'timestamp_start_index': timestampStartIndex
      }..removeWhere((key, dynamic value) => value == null);
}

/// OperationStatus is utilized to indicate which Operation status are considered successful.
class OperationStatus {
  const OperationStatus(this.status, this.successful);

  factory OperationStatus.fromMap(Map<String, dynamic> map) {
    return OperationStatus(map['status'], map['successful']);
  }

  /// The status is the network-specific status of the operation.
  final String status;

  /// An [Operation] is considered successful if the [Operation.Amount]
  /// should affect the Operation.Account.
  /// Some blockchains (like Bitcoin) only include successful operations
  /// in blocks but other blockchains (like Ethereum) include
  /// unsuccessful operations that incur a fee. To reconcile
  /// the computed balance from the stream of [Operations], it is critical
  /// to understand which [Operation.Status] indicate an [Operation]
  /// is successful and should affect an account.
  final bool successful;

  Map<String, dynamic> toJson() => {'status': status, 'successful': successful}
    ..removeWhere((key, dynamic value) => value == null);
}

/// The timestamp of the block in milliseconds since the Unix Epoch.
/// The timestamp is stored in milliseconds because some blockchains produce
/// blocks more often than once a second.
typedef Timestamp = int;

/// PublicKey contains a public key byte array for a particular [CurveType]
/// encoded in hex. Note that there is no PrivateKey struct as this is
/// NEVER the concern of an implementation.
class PublicKey {
  // "secp256k1" | "secp256r1" | "edwards25519" | "tweedle";
  const PublicKey(this.hexBytes, this.curveType);

  factory PublicKey.fromMap(Map<String, dynamic> map) {
    return PublicKey(map['hex_bytes'], map['curve_type']);
  }

  /// Hex-encoded public key bytes in the format specified by the [CurveType].
  final String hexBytes;
  final String curveType;

  Map<String, dynamic> toJson() => {
        'hex_bytes': hexBytes,
        'curve_type': curveType
      }..removeWhere((key, dynamic value) => value == null);
}

/// [CurveType] is the type of cryptographic curve associated with a PublicKey.
///   * secp256k1: SEC compressed - `33 bytes` (https://secg.org/sec1-v2.pdf#subsubsection.2.3.3)
///   * secp256r1: SEC compressed - `33 bytes` (https://secg.org/sec1-v2.pdf#subsubsection.2.3.3)
///   * edwards25519: `y (255-bits) || x-sign-bit (1-bit)` - `32 bytes` (https://ed25519.cr.yp.to/ed25519-20110926.pdf)
///   * tweedle: 1st pk : Fq.t (32 bytes) || 2nd pk : Fq.t (32 bytes) (https://github.com/CodaProtocol/coda/blob/develop/rfcs/0038-rosetta-construction-api.md#marshal-keys)
///
/// [SigningPayload] is signed by the client with the keypair associated with an
/// [AccountIdentifier] using the specified [signatureType].
/// [signatureType] can be optionally populated if there is a restriction on the
/// signature scheme that can be used to sign the payload.
class SigningPayload {
  const SigningPayload(
    this.hexBytes,
    this.address,
    this.accountIdentifier,
    this.signatureType,
  );

  factory SigningPayload.fromMap(Map<String, dynamic> map) {
    return SigningPayload(
      map['hex_bytes'],
      map['address'],
      map['account_identifier'] != null
          ? AccountIdentifier.fromMap(map['account_identifier'])
          : null,
      map['signature_type'],
    );
  }

  /// [DEPRECATED by `account_identifier` in `v1.4.4`]
  /// The network-specific address of the account that should sign the payload.
  final String hexBytes;
  final String? address;
  final AccountIdentifier? accountIdentifier;
  final String? signatureType;

  Map<String, dynamic> toJson() => {
        'hex_bytes': hexBytes,
        'address': address,
        'account_identifier': accountIdentifier?.toJson(),
        'signature_type': signatureType
      }..removeWhere((key, dynamic value) => value == null);
}

/// Signature contains the payload that was signed, the public keys of the
/// key-pairs used to produce the signature, the signature (encoded in hex),
/// and the SignatureType. PublicKey is often times not known during
/// construction of the signing payloads but may be needed to
/// combine signatures properly.
class Signature {
  const Signature(
    this.signingPayload,
    this.publicKey,
    this.signatureType,
    this.hexBytes,
  );

  factory Signature.fromMap(Map<String, dynamic> map) {
    return Signature(
      SigningPayload.fromMap(map['signing_payload']),
      PublicKey.fromMap(map['public_key']),
      map['signature_type'],
      map['hex_bytes'],
    );
  }

  final SigningPayload signingPayload;
  final PublicKey publicKey;

  /// export type SignatureType =
  ///   | "ecdsa"
  ///   | "ecdsa_recovery"
  ///   | "ed25519"
  ///   | "schnorr_1"
  ///   | "schnorr_poseidon";
  final String signatureType;
  final String hexBytes;

  Map<String, dynamic> toJson() => {
        'signing_payload': signingPayload.toJson(),
        'public_key': publicKey.toJson(),
        'signature_type': signatureType,
        'hex_bytes': hexBytes
      }..removeWhere((key, dynamic value) => value == null);
}

/// CoinIdentifier uniquely identifies a Coin.
class CoinIdentifier {
  const CoinIdentifier(this.identifier);

  factory CoinIdentifier.fromMap(Map<String, dynamic> map) =>
      CoinIdentifier(map['identifier']);

  /// Identifier should be populated with a globally unique identifier of a Coin.
  /// In Bitcoin, this identifier would be transaction_hash:index.
  final String identifier;

  Map<String, dynamic> toJson() => {'identifier': identifier}
    ..removeWhere((key, dynamic value) => value == null);
}

/// CoinChange is used to represent a change in state of a some coin identified
/// by a [coinIdentifier]. This object is part of the [Operation] model
/// and must be populated for UTXO-based blockchains. Coincidentally,
/// this abstraction of UTXOs allows for supporting both account-based transfers
/// and UTXO-based transfers on the same blockchain
/// (when a transfer is account-based, don't poputhis model).
class CoinChange {
  /// "coin_created" | "coin_spent";
  const CoinChange(this.coinAction, this.coinIdentifier);

  factory CoinChange.fromMap(Map<String, dynamic> map) {
    return CoinChange(
      map['coin_action'],
      CoinIdentifier.fromMap(map['coin_identifier']),
    );
  }

  final String coinAction;
  final CoinIdentifier coinIdentifier;

  Map<String, dynamic> toJson() => {
        'coin_identifier': coinIdentifier.toJson(),
        'coin_action': coinAction
      }..removeWhere((key, dynamic value) => value == null);
}

/// Coin contains its unique identifier and the amount it represents.
class Coin {
  const Coin(this.amount, this.coinIdentifier);

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      Amount.fromMap(map['amount']),
      CoinIdentifier.fromMap(map['coin_identifier']),
    );
  }

  final CoinIdentifier coinIdentifier;
  final Amount amount;

  Map<String, dynamic> toJson() => {
        'coin_identifier': coinIdentifier.toJson(),
        'amount': amount.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [BalanceExemption] indicates that the balance for an exempt account
/// could change without a corresponding [Operation]. This typically occurs with
/// staking rewards, vesting balances, and Currencies with a dynamic supply.
/// Currently, it is possible to exempt an account from strict reconciliation
/// by [SubAccountIdentifier.Address] or by [Currency]. This means that any account
/// with [SubAccountIdentifier.Address] would be exempt or any balance of a
/// particular [Currency] would be exempt, respectively. [BalanceExemption]s
/// should be used sparingly as they may introduce significant complexity for
/// integrators that attempt to reconcile all account balance changes.
/// If your implementation relies on any [BalanceExemption]s, you MUST implement
/// historical balance lookup
/// (the ability to query an account balance at any [BlockIdentifier]).
class BalanceExemption {
  /// "greater_or_equal" | "less_or_equal" | "dynamic";
  const BalanceExemption(
    this.subAccountAddress,
    this.currency,
    this.exemptionType,
  );

  factory BalanceExemption.fromMap(Map<String, dynamic> map) {
    return BalanceExemption(
      map['sub_account_address'],
      map['currency'] != null ? Currency.fromMap(map['currency']) : null,
      map['exemption_type'],
    );
  }

  /// [subAccountAddress] is the [SubAccountIdentifier.Address]
  /// that the [BalanceExemption] applies to
  /// (regardless of the value of [SubAccountIdentifier.Metadata]).
  final String? subAccountAddress;
  final Currency? currency;

  /// [exemptionType] is used to indicate if the live balance for
  /// an account subject to a [BalanceExemption] could increase above,
  /// decrease below, or equal the computed balance.
  ///   * greater_or_equal: The live balance may increase above or equal
  ///     the computed balance. This typically occurs with staking rewards that
  ///     accrue on each block.
  ///   * less_or_equal: The live balance may decrease below or equal
  ///     the computed balance. This typically occurs as balance moves from
  ///     locked to spendable on a vesting account.
  ///   * dynamic: The live balance may increase above, decrease below, or equal
  ///     the computed balance. This typically occurs with tokens that have a
  ///     dynamic supply.
  ///
  /// ```typescript
  /// export type ExemptionType = "greater_or_equal" | "less_or_equal" | "dynamic";
  /// ```
  final String? exemptionType;

  Map<String, dynamic> toJson() => {
        'sub_account_address': subAccountAddress,
        'currency': currency?.toJson(),
        'exemption_type': exemptionType
      }..removeWhere((key, dynamic value) => value == null);
}

/// [BlockEvent] represents the addition or removal of a [BlockIdentifier]
/// from storage. Streaming [BlockEvent]s allows lightweight clients to update
/// their own state without needing to implement their own syncing logic.
class BlockEvent {
  // "block_added" | "block_removed"
  const BlockEvent(this.sequence, this.blockIdentifier, this.type);

  factory BlockEvent.fromMap(Map<String, dynamic> map) {
    return BlockEvent(
      map['sequence'],
      BlockIdentifier.fromMap(map['block_identifier']),
      map['type'],
    );
  }

  /// [sequence] is the unique identifier of a [BlockEvent]
  /// within the context of a [NetworkIdentifier].
  final int sequence;
  final BlockIdentifier blockIdentifier;
  final String type;

  Map<String, dynamic> toJson() => {
        'sequence': sequence,
        'block_identifier': blockIdentifier.toJson(),
        'type': type
      }..removeWhere((key, dynamic value) => value == null);
}

/// BlockTransaction contains a populated Transaction and the BlockIdentifier that contains it.
class BlockTransaction {
  const BlockTransaction(this.blockIdentifier, this.transaction);

  factory BlockTransaction.fromMap(Map<String, dynamic> map) {
    return BlockTransaction(
      BlockIdentifier.fromMap(map['block_identifier']),
      Transaction.fromMap(map['transaction']),
    );
  }

  final BlockIdentifier blockIdentifier;
  final Transaction transaction;

  Map<String, dynamic> toJson() => {
        'block_identifier': blockIdentifier.toJson(),
        'transaction': transaction.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// An [AccountBalanceRequest] is utilized to make a balance request
/// on the /account/balance endpoint.
/// If the [blockIdentifier] is populated, a historical balance query
/// should be performed.
class AccountBalanceRequest {
  const AccountBalanceRequest(
    this.networkIdentifier,
    this.accountIdentifier,
    this.blockIdentifier,
    this.currencies,
  );

  factory AccountBalanceRequest.fromMap(Map<String, dynamic> map) {
    return AccountBalanceRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      AccountIdentifier.fromMap(map['account_identifier']),
      PartialBlockIdentifier.fromMap(map['block_identifier']),
      map['currencies'] != null
          ? (map['currencies'] as List).map((e) => Currency.fromMap(e)).toList()
          : null,
    );
  }

  final NetworkIdentifier networkIdentifier;
  final AccountIdentifier accountIdentifier;
  final PartialBlockIdentifier? blockIdentifier;

  /// In some cases, the caller may not want to retrieve all available balances
  /// for an [AccountIdentifier]. If the currencies field is populated,
  /// only balances for the specified currencies will be returned.
  /// If not populated, all available balances will be returned.
  final List<Currency>? currencies;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'account_identifier': accountIdentifier.toJson(),
        'block_identifier': blockIdentifier?.toJson(),
        'currencies': currencies?.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// An [AccountBalanceResponse] is returned on the /account/balance endpoint.
/// If an account has a balance for each [AccountIdentifier] describing it
/// (ex: an ERC-20 token balance on a few smart contracts),
/// an account balance request must be made with each [AccountIdentifier].
class AccountBalanceResponse {
  const AccountBalanceResponse(
    this.blockIdentifier,
    this.balances,
    this.metadata,
  );

  factory AccountBalanceResponse.fromMap(Map<String, dynamic> map) {
    return AccountBalanceResponse(
      BlockIdentifier.fromMap(map['block_identifier']),
      (map['balances'] as List).map((e) => Amount.fromMap(e)).toList(),
      map['metadata'],
    );
  }

  final BlockIdentifier blockIdentifier;

  /// A single account may have a balance in multiple currencies.
  final List<Amount> balances;

  /// Account-based blockchains that utilize a nonce or sequence number should
  /// include that number in the metadata. This number could be unique to the
  /// identifier or global across the account address.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'block_identifier': blockIdentifier.toJson(),
        'balances': balances.map((e) => e.toJson()).toList(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// [AccountCoinsRequest] is utilized to make a request
/// on the /account/coins endpoint.
class AccountCoinsRequest {
  const AccountCoinsRequest(
    this.networkIdentifier,
    this.accountIdentifier,
    this.includeMempool,
    this.currencies,
  );

  factory AccountCoinsRequest.fromMap(Map<String, dynamic> map) {
    return AccountCoinsRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      AccountIdentifier.fromMap(map['account_identifier']),
      map['include_mempool'],
      map['currencies'] != null
          ? (map['currencies'] as List).map((e) => Currency.fromMap(e)).toList()
          : null,
    );
  }

  final NetworkIdentifier networkIdentifier;
  final AccountIdentifier accountIdentifier;

  /// Include state from the mempool when looking up an account's unspent coins.
  /// Note, using this functionality breaks any guarantee of idempotency.
  final bool includeMempool;

  /// In some cases, the caller may not want to retrieve coins for
  /// all currencies for an [AccountIdentifier]. If the currencies field
  /// is populated, only coins for the specified currencies will be returned.
  /// If not populated, all unspent coins will be returned.
  final List<Currency>? currencies;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'account_identifier': accountIdentifier.toJson(),
        'include_mempool': includeMempool,
        'currencies': currencies?.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [AccountCoinsResponse] is returned on the /account/coins endpoint and
/// includes all unspent [Coin]s owned by an [AccountIdentifier].
class AccountCoinsResponse {
  const AccountCoinsResponse(this.blockIdentifier, this.coins, this.metadata);

  factory AccountCoinsResponse.fromMap(Map<String, dynamic> map) {
    return AccountCoinsResponse(
      BlockIdentifier.fromMap(map['block_identifier']),
      (map['coins'] as List).map((e) => Coin.fromMap(e)).toList(),
      map['metadata'],
    );
  }

  final BlockIdentifier blockIdentifier;

  /// If a blockchain is UTXO-based, all unspent [Coin]s owned
  /// by an [AccountIdentifier] should be returned alongside the balance.
  /// It is highly recommended to poputhis field so that users of
  /// the Rosetta API implementation don't need to maintain their own indexer
  /// to track their UTXOs.
  final List<Coin> coins;

  /// Account-based blockchains that utilize a nonce or sequence number should
  /// include that number in the metadata. This number could be unique to the
  /// identifier or global across the account address.
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'block_identifier': blockIdentifier.toJson(),
        'coins': coins.map((e) => e.toJson()).toList(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [BlockRequest] is utilized to make a block request on the /block endpoint.
class BlockRequest {
  const BlockRequest(this.networkIdentifier, this.blockIdentifier);

  factory BlockRequest.fromMap(Map<String, dynamic> map) {
    return BlockRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      PartialBlockIdentifier.fromMap(map['block_identifier']),
    );
  }

  final NetworkIdentifier networkIdentifier;
  final PartialBlockIdentifier blockIdentifier;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'block_identifier': blockIdentifier.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [BlockResponse] includes a fully-populated block or a partially-populated
/// [block] with a list of other transactions to fetch [otherTransactions].
/// As a result of the consensus algorithm of some blockchains,
/// blocks can be omitted (i.e. certain block indexes can be skipped).
/// If a query for one of these omitted indexes is made, the response should not
/// include a [Block] object. It is VERY important to note that blocks MUST
/// still form a canonical, connected chain of blocks where each block has a
/// unique index. In other words, the [PartialBlockIdentifier] of a block after
/// an omitted block should reference the last non-omitted block.
class BlockResponse {
  /// Some blockchains may require additional transactions to be fetched that
  /// weren't returned in the block response
  /// (ex: block only returns transaction hashes).
  /// For blockchains with a lot of transactions in each block,
  /// this can be very useful as consumers can concurrently fetch all
  /// transactions returned.
  const BlockResponse(this.block, this.otherTransactions);

  factory BlockResponse.fromMap(Map<String, dynamic> map) {
    return BlockResponse(
      map['block'] != null ? Block.fromMap(map['block']) : null,
      map['other_transactions'] != null
          ? (map['other_transactions'] as List)
              .map((e) => TransactionIdentifier.fromMap(e))
              .toList()
          : null,
    );
  }

  final Block? block;
  final List<TransactionIdentifier>? otherTransactions;

  Map<String, dynamic> toJson() => {
        'block': block?.toJson(),
        'other_transactions': otherTransactions?.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [BlockTransactionRequest] is used to fetch a [Transaction] included in
/// a block that is not returned in a [BlockResponse].
class BlockTransactionRequest {
  const BlockTransactionRequest(
    this.networkIdentifier,
    this.blockIdentifier,
    this.transactionIdentifier,
  );

  factory BlockTransactionRequest.fromMap(Map<String, dynamic> map) {
    return BlockTransactionRequest(
      map['network_identifier'],
      map['block_identifier'],
      map['transaction_identifier'],
    );
  }

  final NetworkIdentifier networkIdentifier;
  final BlockIdentifier blockIdentifier;
  final TransactionIdentifier transactionIdentifier;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'block_identifier': blockIdentifier.toJson(),
        'transaction_identifier': transactionIdentifier.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [BlockTransactionResponse] contains information about a block transaction.
class BlockTransactionResponse {
  const BlockTransactionResponse(this.transaction);

  factory BlockTransactionResponse.fromMap(Map<String, dynamic> map) {
    return BlockTransactionResponse(Transaction.fromMap(map['transaction']));
  }

  final Transaction transaction;

  Map<String, dynamic> toJson() => {'transaction': transaction.toJson()}
    ..removeWhere((key, dynamic value) => value == null);
}

/// A [MempoolResponse] contains all transaction identifiers in the mempool
/// for a particular [NetworkIdentifier].
class MempoolResponse {
  const MempoolResponse(this.transactionIdentifiers);

  factory MempoolResponse.fromMap(Map<String, dynamic> map) {
    return MempoolResponse(
      (map['transaction_identifiers'] as List)
          .map((e) => TransactionIdentifier.fromMap(e))
          .toList(),
    );
  }

  final List<TransactionIdentifier> transactionIdentifiers;

  Map<String, dynamic> toJson() => {
        'transaction_identifiers':
            transactionIdentifiers.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [MempoolTransactionRequest] is utilized to retrieve a transaction
/// from the mempool.
class MempoolTransactionRequest {
  const MempoolTransactionRequest(
    this.networkIdentifier,
    this.transactionIdentifier,
  );

  factory MempoolTransactionRequest.fromMap(Map<String, dynamic> map) {
    return MempoolTransactionRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      TransactionIdentifier.fromMap(map['transaction_identifier']),
    );
  }

  final NetworkIdentifier networkIdentifier;
  final TransactionIdentifier transactionIdentifier;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'transaction_identifier': transactionIdentifier.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A MempoolTransactionResponse contains an estimate of a mempool transaction.
/// It may not be possible to know the full impact of a transaction
/// in the mempool (ex: fee paid).
class MempoolTransactionResponse {
  const MempoolTransactionResponse(this.transaction, this.metadata);

  factory MempoolTransactionResponse.fromMap(Map<String, dynamic> map) {
    return MempoolTransactionResponse(
      Transaction.fromMap(map['transaction']),
      map['metadata'],
    );
  }

  final Transaction transaction;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'transaction': transaction.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [MetadataRequest] is utilized in any request where the only argument
/// is optional metadata.
class MetadataRequest {
  const MetadataRequest(this.metadata);

  factory MetadataRequest.fromMap(Map<String, dynamic> map) {
    return MetadataRequest(map['metadata']);
  }

  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {'metadata': metadata}
    ..removeWhere((key, dynamic value) => value == null);
}

/// A [NetworkListResponse] contains all [NetworkIdentifier]s that the node
/// can serve information for.
class NetworkListResponse {
  const NetworkListResponse(this.networkIdentifiers);

  factory NetworkListResponse.fromMap(Map<String, dynamic> map) {
    return NetworkListResponse(
      (map['network_identifiers'] as List)
          .map((e) => NetworkIdentifier.fromMap(e))
          .toList(),
    );
  }

  final List<NetworkIdentifier> networkIdentifiers;

  Map<String, dynamic> toJson() => {
        'network_identifiers':
            networkIdentifiers.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [NetworkRequest] is utilized to retrieve some data specific exclusively
/// to a [NetworkIdentifier].
class NetworkRequest {
  const NetworkRequest(this.networkIdentifier, this.metadata);

  factory NetworkRequest.fromMap(Map<String, dynamic> map) {
    return NetworkRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['metadata'],
    );
  }

  final NetworkIdentifier networkIdentifier;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// [NetworkStatusResponse] contains basic information about the node's view of
/// a blockchain network. It is assumed that any [BlockIdentifier.Index]
/// less than or equal to [CurrentBlockIdentifier.Index] can be queried.
/// If a Rosetta implementation prunes historical state,
/// it should populate the optional `oldest_block_identifier` field with
/// the oldest block available to query. If this is not populated,
/// it is assumed that the `genesis_block_identifier` is the oldest
/// queryable block. If a Rosetta implementation performs some pre-sync
/// before it is possible to query blocks, sync_status should be populated
/// so that clients can still monitor healthiness. Without this field, it may
/// appear that the implementation is stuck syncing and needs to be terminated.
class NetworkStatusResponse {
  const NetworkStatusResponse(
    this.currentBlockIdentifier,
    this.currentBlockTimestamp,
    this.genesisBlockIdentifier,
    this.peers,
    this.oldestBlockIdentifier,
    this.syncStatus,
  );

  factory NetworkStatusResponse.fromMap(Map<String, dynamic> map) {
    return NetworkStatusResponse(
      BlockIdentifier.fromMap(map['current_block_identifier']),
      map['current_block_timestamp'],
      BlockIdentifier.fromMap(map['genesis_block_identifier']),
      (map['peers'] as List).map((e) => Peer.fromMap(e)).toList(),
      map['oldest_block_identifier'],
      map['sync_status'],
    );
  }

  final BlockIdentifier currentBlockIdentifier;
  final Timestamp currentBlockTimestamp;
  final BlockIdentifier genesisBlockIdentifier;
  final BlockIdentifier? oldestBlockIdentifier;
  final SyncStatus? syncStatus;
  final List<Peer> peers;

  Map<String, dynamic> toJson() => {
        'current_block_identifier': currentBlockIdentifier.toJson(),
        'current_block_timestamp': currentBlockTimestamp,
        'genesis_block_identifier': genesisBlockIdentifier.toJson(),
        'peers': peers.map((e) => e.toJson()).toList(),
        'oldest_block_identifier': oldestBlockIdentifier?.toJson(),
        'sync_status': syncStatus?.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [NetworkOptionsResponse] contains information about the versioning
/// of the node and the allowed operation statuses, operation types, and errors.
class NetworkOptionsResponse {
  const NetworkOptionsResponse(this.version, this.allow);

  factory NetworkOptionsResponse.fromMap(Map<String, dynamic> map) {
    return NetworkOptionsResponse(
      Version.fromMap(map['version']),
      Allow.fromMap(map['allow']),
    );
  }

  final Version version;
  final Allow allow;

  Map<String, dynamic> toJson() => {
        'version': version.toJson(),
        'allow': allow.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

/// A [ConstructionMetadataRequest] is utilized to get information required to
/// construct a transaction. The [options] object used to specify which metadata
/// to return is left purposely unstructured to allow flexibility
/// for implementers. [options] is not required in the case that there is
/// network-wide metadata of interest. Optionally, the request can also include
/// an array of [PublicKey]s associated with the
/// [AccountIdentifiers] returned in [ConstructionPreprocessResponse].
class ConstructionMetadataRequest {
  const ConstructionMetadataRequest(
    this.networkIdentifier,
    this.options,
    this.publicKeys,
  );

  factory ConstructionMetadataRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionMetadataRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['options'],
      map['public_keys'] != null
          ? (map['public_keys'] as List)
              .map((e) => PublicKey.fromMap(e))
              .toList()
          : null,
    );
  }

  final NetworkIdentifier networkIdentifier;

  /// Some blockchains require different metadata for different types of
  /// transaction construction (ex: delegation versus a transfer).
  /// Instead of requiring a blockchain node to return all possible types of
  /// metadata for construction (which may require multiple node fetches),
  /// the client can populate an options object to limit the metadata returned
  /// to only the subset required.
  final Map<String, dynamic>? options;

  final List<PublicKey>? publicKeys;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'options': options,
        'public_keys': publicKeys?.map((e) => e.toJson())
      }..removeWhere((key, dynamic value) => value == null);
}

/// The [ConstructionMetadataResponse] returns network-specific metadata
/// used for transaction construction. Optionally, the implementer can return
/// the suggested fee associated with the transaction being constructed.
/// The caller may use this info to adjust the intent of the transaction or
/// to create a transaction with a different account that can pay the
/// suggested fee. Suggested fee is an array in case fee payment must occur
/// in multiple currencies.
class ConstructionMetadataResponse {
  const ConstructionMetadataResponse(this.metadata, this.suggestedFee);

  factory ConstructionMetadataResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionMetadataResponse(
      map['metadata'],
      map['suggested_fee'] != null
          ? (map['suggested_fee'] as List)
              .map((e) => Amount.fromMap(e))
              .toList()
          : null,
    );
  }

  final Map<String, dynamic> metadata;

  final List<Amount>? suggestedFee;

  Map<String, dynamic> toJson() => {
        'metadata': metadata,
        'suggested_fee': suggestedFee?.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionDeriveRequest] is passed to the `/construction/derive` endpoint.
/// Network is provided in the request because some blockchains have
/// different address formats for different networks. Metadata is provided
/// in the request because some blockchains allow for multiple address types
/// (i.e. different address for validators vs normal accounts).
class ConstructionDeriveRequest {
  const ConstructionDeriveRequest(
    this.networkIdentifier,
    this.publicKey,
    this.metadata,
  );

  factory ConstructionDeriveRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionDeriveRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      PublicKey.fromMap(map['public_key']),
      map['metadata'],
    );
  }

  final NetworkIdentifier networkIdentifier;

  final PublicKey publicKey;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'public_key': publicKey.toJson(),
        'meta_data': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionDeriveResponse] is returned by the
/// `/construction/derive` endpoint.
class ConstructionDeriveResponse {
  const ConstructionDeriveResponse(
    this.address,
    this.accountIdentifier,
    this.metadata,
  );

  factory ConstructionDeriveResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionDeriveResponse(
      map['address'],
      AccountIdentifier.fromMap(map['account_identifier']),
      map['metadata'],
    );
  }

  /// [DEPRECATED by `account_identifier` in `v1.4.4`]
  /// Address in network-specific format.
  final String? address;
  final AccountIdentifier? accountIdentifier;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'address': address,
        'account_identifier': accountIdentifier?.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionPreprocessRequest] is passed to the
/// `/construction/preprocess` endpoint so that a Rosetta implementation
/// can determine which [metadata] it needs to request for construction.
/// [metadata] provided in this object should NEVER be a product of live data
/// (i.e. the caller must follow some network-specific data fetching strategy
/// outside of the Construction API to populate required [metadata]).
/// If live data is required for construction, it MUST be fetched in the call
/// to `/construction/metadata`. The caller can provide a max fee they are
/// willing to pay for a transaction. This is an array in the case fees must be
/// paid in multiple currencies. The caller can also provide a suggested
/// fee multiplier to indicate that the suggested fee should be scaled.
/// This may be used to set higher fees for urgent transactions or to pay lower
/// fees when there is less urgency. It is assumed that providing a very low
/// multiplier (like 0.0001) will never lead to a transaction being created with
/// a fee less than the minimum network fee (if applicable). In the case that
/// the caller provides both a max fee and a suggested fee multiplier,
/// the max fee will set an upper bound on the suggested fee
/// (regardless of the multiplier provided).
class ConstructionPreprocessRequest {
  const ConstructionPreprocessRequest(
    this.networkIdentifier,
    this.operations,
    this.metadata,
    this.maxFee,
    this.suggestedFeeMultiplier,
  );

  factory ConstructionPreprocessRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionPreprocessRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      (map['operations'] as List).map((e) => Operation.fromMap(e)).toList(),
      map['metadata'],
      map['max_fee'] != null
          ? (map['max_fee'] as List).map((e) => Amount.fromMap(e)).toList()
          : null,
      map['suggested_fee_multiplier'],
    );
  }

  final NetworkIdentifier networkIdentifier;
  final List<Operation> operations;
  final Map<String, dynamic>? metadata;
  final List<Amount>? maxFee;
  final int? suggestedFeeMultiplier;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'operations': operations.map((e) => e.toJson()),
        'metadata': metadata,
        'max_fee': maxFee?.map((e) => e.toJson()),
        'suggested_fee_multiplier': suggestedFeeMultiplier
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionPreprocessResponse] contains `options`
/// that will be sent unmodified to `/construction/metadata`.
/// If it is not necessary to make a request to `/construction/metadata`,
/// `options` should be omitted.
///
/// Some blockchains require the [PublicKey] of
/// particular [AccountIdentifier]s to construct a valid transaction.
/// To fetch these [PublicKey]s, populate `required_public_keys` with the
/// [AccountIdentifier]s associated with the desired [PublicKey]s.
/// If it is not necessary to retrieve any [PublicKey]s for construction,
/// `required_public_keys` should be omitted.
class ConstructionPreprocessResponse {
  const ConstructionPreprocessResponse(
    this.options,
    this.requiredPublicKeys,
  );

  factory ConstructionPreprocessResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionPreprocessResponse(
      map['options'],
      map['required_public_keys'] != null
          ? (map['required_public_keys'] as List)
              .map((e) => AccountIdentifier.fromMap(e))
              .toList()
          : null,
    );
  }

  /// The options that will be sent directly to `/construction/metadata`
  /// by the caller.
  final Map<String, dynamic>? options;
  final List<AccountIdentifier>? requiredPublicKeys;
}

/// [ConstructionPayloadsRequest] is the request to `/construction/payloads`.
/// It contains the network, a slice of operations, and arbitrary metadata
/// that was returned by the call to `/construction/metadata`.
/// Optionally, the request can also include an array of [PublicKey]s associated
/// with the [AccountIdentifier]s returned in [ConstructionPreprocessResponse].
class ConstructionPayloadsRequest {
  const ConstructionPayloadsRequest(
    this.networkIdentifier,
    this.operations,
    this.metadata,
    this.publicKeys,
  );

  factory ConstructionPayloadsRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionPayloadsRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      (map['operations'] as List).map((e) => Operation.fromMap(e)).toList(),
      map['metadata'],
      map['public_keys'] != null
          ? (map['public_keys'] as List)
              .map((e) => PublicKey.fromMap(e))
              .toList()
          : null,
    );
  }

  final NetworkIdentifier networkIdentifier;
  final List<Operation> operations;
  final Map<String, dynamic>? metadata;
  final List<PublicKey>? publicKeys;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'operations': operations.map((e) => e.toJson()).toList(),
        'public_keys': publicKeys?.map((e) => e.toJson()).toList(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

abstract class SignablePayload {
  const SignablePayload(this.unsignedTransaction, this.payloads);

  final String unsignedTransaction;
  final List<SigningPayload> payloads;

  Map<String, dynamic> toJson();
}

/// [ConstructionTransactionResponse] is returned by `/construction/payloads`.
/// It contains an unsigned transaction blob (that is usually needed to
/// construct the a network transaction from a collection of signatures) and
/// an array of payloads that must be signed by the caller.
class ConstructionPayloadsResponse extends SignablePayload {
  const ConstructionPayloadsResponse(
    super.unsignedTransaction,
    super.payloads,
  );

  factory ConstructionPayloadsResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionPayloadsResponse(
      map['unsigned_transaction'],
      (map['payloads'] as List).map((e) => SigningPayload.fromMap(e)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'unsigned_transaction': unsignedTransaction,
        'payloads': payloads.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionCombineRequest] is the input to the
/// `/construction/combine` endpoint. It contains the unsigned transaction blob
/// returned by `/construction/payloads` and all required signatures to
/// create a network transaction.
class ConstructionCombineRequest {
  const ConstructionCombineRequest(
    this.networkIdentifier,
    this.unsignedTransaction,
    this.signatures,
  );

  factory ConstructionCombineRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionCombineRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['unsigned_transaction'],
      (map['signatures'] as List).map((e) => Signature.fromMap(e)).toList(),
    );
  }

  final NetworkIdentifier networkIdentifier;
  final String unsignedTransaction;
  final List<Signature> signatures;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'unsigned_transaction': unsignedTransaction,
        'signatures': signatures.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

class ConstructionCombineRequestPart {
  const ConstructionCombineRequestPart(
    this.networkIdentifier,
    this.unsignedTransaction,
    this.signatures,
  );

  factory ConstructionCombineRequestPart.fromMap(Map<String, dynamic> map) {
    return ConstructionCombineRequestPart(
      map['network_identifier'] != null
          ? NetworkIdentifier.fromMap(map['network_identifier'])
          : null,
      map['unsigned_transaction'],
      (map['signatures'] as List).map((e) => Signature.fromMap(e)).toList(),
    );
  }

  final NetworkIdentifier? networkIdentifier;
  final String unsignedTransaction;
  final List<Signature> signatures;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier?.toJson(),
        'unsigned_transaction': unsignedTransaction,
        'signatures': signatures.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionCombineResponse] is returned by `/construction/combine`.
/// The network payload will be sent directly to the
/// `construction/submit` endpoint.
class ConstructionCombineResponse {
  const ConstructionCombineResponse(this.signedTransaction);

  factory ConstructionCombineResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionCombineResponse(map['signed_transaction']);
  }

  final String signedTransaction;

  Map<String, dynamic> toJson() => {'signed_transaction': signedTransaction}
    ..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionParseRequest] is the input to the `/construction/parse` endpoint.
/// It allows the caller to parse either an unsigned or signed transaction.
class ConstructionParseRequest {
  const ConstructionParseRequest(
    this.networkIdentifier,
    this.signed,
    this.transaction,
  );

  factory ConstructionParseRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionParseRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['signed'],
      map['transaction'],
    );
  }

  final NetworkIdentifier networkIdentifier;

  /// Signed is a boolean indicating whether the transaction is signed.
  final bool signed;

  /// This must be either the unsigned transaction blob returned by
  /// `/construction/payloads` or the signed transaction blob returned by
  /// `/construction/combine`.
  final String transaction;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'signed': signed,
        'transaction': transaction
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionParseResponse] contains an array of operations that occur in
/// a transaction blob. This should match the array of operations provided to
/// `/construction/preprocess` and `/construction/payloads`.
class ConstructionParseResponse {
  const ConstructionParseResponse(
    this.operations,
    this.signers,
    this.accountIdentifierSigners,
    this.metadata,
  );

  factory ConstructionParseResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionParseResponse(
      (map['operations'] as List).map((e) => Operation.fromMap(e)).toList(),
      map['signers'] != null
          ? (map['signers'] as List).map((e) => e.toString()).toList()
          : null,
      map['account_identifier_signers'] != null
          ? (map['account_identifier_signers'] as List)
              .map((e) => AccountIdentifier.fromMap(e))
              .toList()
          : null,
      map['metadata'],
    );
  }

  final List<Operation> operations;

  /// [DEPRECATED by `account_identifier_signers` in `v1.4.4`]
  /// All signers (addresses) of a particular transaction.
  /// If the transaction is unsigned, it should be empty.
  final List<String>? signers;
  final List<AccountIdentifier>? accountIdentifierSigners;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'operations': operations.map((e) => e.toJson()).toList(),
        'signers': signers?.map((e) => e.toString()).toList(),
        'account_identifier_signers':
            accountIdentifierSigners?.map((e) => e.toJson()).toList(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// [ConstructionHashRequest] is the input to the `/construction/hash` endpoint.
class ConstructionHashRequest {
  const ConstructionHashRequest(this.networkIdentifier, this.signedTransaction);

  factory ConstructionHashRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionHashRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['signed_transaction'],
    );
  }

  final NetworkIdentifier networkIdentifier;
  final String signedTransaction;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'signed_transaction': signedTransaction
      }..removeWhere((key, dynamic value) => value == null);
}

/// The transaction submission request includes a signed transaction.
class ConstructionSubmitRequest {
  const ConstructionSubmitRequest(
    this.networkIdentifier,
    this.signedTransaction,
  );

  factory ConstructionSubmitRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionSubmitRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['signed_transaction'],
    );
  }

  final NetworkIdentifier networkIdentifier;
  final String signedTransaction;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'signed_transaction': signedTransaction
      }..removeWhere((key, dynamic value) => value == null);
}

/// [TransactionIdentifierResponse] contains the [transactionIdentifier] of
/// a transaction that was submitted to either `/construction/hash`
/// or `/construction/submit`.
class TransactionIdentifierResponse {
  const TransactionIdentifierResponse(
    this.transactionIdentifier,
    this.metadata,
  );

  factory TransactionIdentifierResponse.fromMap(Map<String, dynamic> map) {
    return TransactionIdentifierResponse(
      TransactionIdentifier.fromMap(map['transaction_identifier']),
      map['metadata'],
    );
  }

  final TransactionIdentifier transactionIdentifier;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'transaction_identifier': transactionIdentifier.toJson(),
        'metadata': metadata
      }..removeWhere((key, dynamic value) => value == null);
}

/// [CallRequest] is the input to the `/call` endpoint.
class CallRequest {
  const CallRequest(this.networkIdentifier, this.method, this.parameters);

  factory CallRequest.fromMap(Map<String, dynamic> map) {
    return CallRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['method'],
      map['parameters'],
    );
  }

  final NetworkIdentifier networkIdentifier;

  /// Method is some network-specific procedure call.
  /// This method could map to a network-specific RPC endpoint, a method in
  /// a SDK generated from a smart contract, or some hybrid of the two.
  /// The implementation must define all available methods in the Allow object.
  /// However, it is up to the caller to determine which parameters to provide
  /// when invoking `/call`.
  final String method;

  /// Parameters is some network-specific argument for a method. It is up to the
  /// caller to determine which parameters to provide when invoking `/call`.
  final Map<String, dynamic> parameters;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'method': method,
        'parameters': parameters
      }..removeWhere((key, dynamic value) => value == null);
}

/// [CallResponse] contains the result of a `/call` invocation.
class CallResponse {
  const CallResponse(this.result, this.idempotent);

  factory CallResponse.fromMap(Map<String, dynamic> map) {
    return CallResponse(map['result'], map['idempotent']);
  }

  /// Result contains the result of the `/call` invocation.
  /// This result will not be inspected or interpreted by Rosetta tooling
  /// and is left to the caller to decode.
  final Map<String, dynamic> result;

  /// Idempotent indicates that if `/call` is invoked with the same
  /// [CallRequest] again, at any point in time, it will return the same
  /// [CallResponse]. Integrators may cache the CallResponse if this is set to
  /// true to avoid making unnecessary calls to the Rosetta implementation.
  /// For this reason, implementers should be very conservative about returning
  /// true here or they could cause issues for the caller.
  final bool idempotent;

  Map<String, dynamic> toJson() => {'result': result, 'idempotent': idempotent}
    ..removeWhere((key, dynamic value) => value == null);
}

/// [EventsBlocksRequest] is utilized to fetch a sequence of [BlockEvent]s
/// indicating which blocks were added and removed from storage to reach
/// the current state.
class EventsBlocksRequest {
  const EventsBlocksRequest(this.networkIdentifier, this.offset, this.limit);

  factory EventsBlocksRequest.fromMap(Map<String, dynamic> map) {
    return EventsBlocksRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['offset'],
      map['limit'],
    );
  }

  final NetworkIdentifier networkIdentifier;

  /// The offset into the event stream to sync events from. If this field is not
  /// populated, we return the limit events backwards from tip. If this is
  /// set to 0, we start from the beginning.
  final int? offset;

  /// The maximum number of events to fetch in one call.
  /// The implementation may return <= limit events.
  final int? limit;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'offset': offset,
        'limit': limit
      }..removeWhere((key, dynamic value) => value == null);
}

/// [EventsBlocksResponse] contains an ordered collection of [BlockEvent]s
/// and the max retrievable sequence.
class EventsBlocksResponse {
  const EventsBlocksResponse(this.maxSequence, this.events);

  factory EventsBlocksResponse.fromMap(Map<String, dynamic> map) {
    return EventsBlocksResponse(
      map['max_sequence'],
      (map['events'] as List).map((e) => BlockEvent.fromMap(e)).toList(),
    );
  }

  /// The maximum available sequence number to fetch.
  final int maxSequence;

  /// An array of [BlockEvent]s indicating the order to add and remove blocks
  /// to maintain a canonical view of blockchain state. Lightweight clients can
  /// use this event stream to update state without implementing their own
  /// block syncing logic.
  final List<BlockEvent> events;

  Map<String, dynamic> toJson() => {
        'max_sequence': maxSequence,
        'events': events.map((e) => e.toJson()).toList()
      }..removeWhere((key, dynamic value) => value == null);
}

/// [SearchTransactionsRequest] is used to search for transactions matching
/// a set of provided conditions in canonical blocks.
class SearchTransactionsRequest {
  const SearchTransactionsRequest(
    this.networkIdentifier,
    this.operator,
    this.maxBlock,
    this.offset,
    this.limit,
    this.transactionIdentifier,
    this.accountIdentifier,
    this.coinIdentifier,
    this.currency,
    this.status,
    this.type,
    this.address,
    this.success,
  );

  factory SearchTransactionsRequest.fromMap(Map<String, dynamic> map) {
    return SearchTransactionsRequest(
      NetworkIdentifier.fromMap(map['network_identifier']),
      map['operator'],
      map['max_block'],
      map['offset'],
      map['limit'],
      map['transaction_identifier'] != null
          ? TransactionIdentifier.fromMap(map['transaction_identifier'])
          : null,
      map['account_identifier'] != null
          ? AccountIdentifier.fromMap(map['account_identifier'])
          : null,
      map['coin_identifier'] != null
          ? CoinIdentifier.fromMap(map['coin_identifier'])
          : null,
      map['currency'] != null ? Currency.fromMap(map['currency']) : null,
      map['status'],
      map['type'],
      map['address'],
      map['success'],
    );
  }

  final NetworkIdentifier networkIdentifier;
  final String? operator; // "or" | "and";
  /// The largest block index to consider when searching for transactions.
  /// If this field is not populated, the current block is considered
  /// he [maxBlock]. If you do not specify a [maxBlock], it is possible a newly
  /// synced block will interfere with paginated transaction queries
  /// (as the offset could become invalid with newly added rows).
  final int? maxBlock;

  /// The offset into the query result to start returning transactions.
  /// If any search conditions are changed, the query offset will change and
  /// you must restart your search iteration.
  final int? offset;

  /// The maximum number of transactions to return in one call.
  /// The implementation may return <= limit transactions.
  final int? limit;

  final TransactionIdentifier? transactionIdentifier;

  final AccountIdentifier? accountIdentifier;

  final CoinIdentifier? coinIdentifier;
  final Currency? currency;

  /// The network-specific operation type.
  final String? status;

  /// The network-specific operation type.
  final String? type;

  /// [AccountIdentifier.address]. This is used to get all transactions related
  /// to an [AccountIdentifier.Address], regardless of [SubAccountIdentifier].
  final String? address;

  /// A synthetic condition populated by parsing network-specific
  /// operation statuses (using the mapping provided in `/network/options`).
  final bool? success;

  Map<String, dynamic> toJson() => {
        'network_identifier': networkIdentifier.toJson(),
        'operator': operator,
        'max_block': maxBlock,
        'offset': offset,
        'limit': limit,
        'transaction_identifier': transactionIdentifier?.toJson(),
        'account_identifier': accountIdentifier?.toJson(),
        'coin_identifier': coinIdentifier?.toJson(),
        'currency': currency?.toJson(),
        'status': status,
        'type': type,
        'address': address,
        'success': success
      }..removeWhere((key, dynamic value) => value == null);
}

/// [SearchTransactionsResponse] contains an ordered collection of
/// [BlockTransaction]s that match the query in [SearchTransactionsRequest].
/// These [BlockTransaction]s are sorted from most recent block to oldest block.
class SearchTransactionsResponse {
  const SearchTransactionsResponse(
    this.transactions,
    this.totalCount,
    this.nextOffset,
  );

  factory SearchTransactionsResponse.fromMap(Map<String, dynamic> map) {
    return SearchTransactionsResponse(
      (map['transactions'] as List)
          .map((e) => BlockTransaction.fromMap(e))
          .toList(),
      map['total_count'] as int,
      map['next_offset'],
    );
  }

  /// The next offset to use when paginating through transaction results.
  /// If this field is not populated, there are no more transactions to query.
  final int? nextOffset;

  /// A list of [BlockTransaction]s sorted by most recent [BlockIdentifier]
  /// (meaning that transactions in recent blocks appear first).
  /// If there are many transactions for a particular search,
  /// transactions may not contain all matching transactions.
  /// It is up to the caller to paginate these transactions using the
  /// [maxBlock] field.
  final List<BlockTransaction> transactions;

  final int? totalCount;

  Map<String, dynamic> toJson() => {
        'transactions': transactions.map((e) => e.toJson()),
        'total_count': totalCount ?? transactions.length,
        'next_offset': nextOffset
      }..removeWhere((key, dynamic value) => value == null);
}

/// Instead of utilizing HTTP status codes to describe node errors
/// (which often do not have a good analog),
/// rich errors are returned using this object.
/// Both the code and message fields can be individually used to correctly
/// identify an error. Implementations MUST use unique values for both fields.
class RosettaError {
  const RosettaError(
    this.code,
    this.message,
    this.retriable,
    this.description,
    this.details,
  );

  factory RosettaError.fromMap(Map<String, dynamic> map) {
    return RosettaError(
      map['code'],
      map['message'],
      map['retriable'],
      map['description'],
      map['details'],
    );
  }

  /// Code is a network-specific error code. If desired, this code can be
  /// equivalent to an HTTP status code.
  final int code;

  /// Message is a network-specific error message. The message MUST NOT change
  /// for a given code. In particular, this means that any contextual
  /// information should be included in the details field.
  final String message;

  /// Description allows the implementer to optionally provide
  /// additional information about an error. In many cases, the content of
  /// this field will be a copy-and-paste from existing developer documentation.
  /// Description can ONLY be populated with generic information about
  /// a particular type of error. It MUST NOT be populated with information
  /// about a particular instantiation of an error (use `details` for this).
  /// Whereas the content of Error.Message should stay stable across releases,
  /// the content of Error.Description will likely change across releases
  /// (as implementers improve error documentation).For this reason, the content
  /// in this field is not part of any type assertion (unlike Error.Message).
  final String? description;

  /// An error is retriable if the same request may succeed if submitted again.
  final bool retriable;

  /// Often times it is useful to return context specific to the request that
  /// caused the error (i.e. a sample of the stack trace or impacted account)
  /// in addition to the standard error message.
  final Map<String, dynamic>? details;

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'retriable': retriable,
        'description': description,
        'details': details
      }..removeWhere((key, dynamic value) => value == null);
}
