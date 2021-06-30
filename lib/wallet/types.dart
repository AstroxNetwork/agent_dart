/// The network_identifier specifies which network a particular object is associated with.
class NetworkIdentifier {
  String blockchain;

  /// If a blockchain has a specific chain-id or network identifier, it should go in this field. It is up to the client to determine which network-specific identifier is mainnet or testnet.
  String network;
  // ignore: non_constant_identifier_names
  SubNetworkIdentifier? sub_network_identifier;
  NetworkIdentifier(this.blockchain, this.network, this.sub_network_identifier);

  factory NetworkIdentifier.fromMap(Map<String, dynamic> map) => NetworkIdentifier(
      map["blockchain"],
      map["network"],
      map["sub_network_identifier"] != null
          ? SubNetworkIdentifier.fromMap(map["sub_network_identifier"])
          : null);

  Map<String, dynamic> toJson() => {
        "blockchain": blockchain,
        "network": network,
        "sub_network_identifier": sub_network_identifier?.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// In blockchains with sharded state, the SubNetworkIdentifier is required to query some object on a specific shard. This identifier is optional for all non-sharded blockchains.
class SubNetworkIdentifier {
  String network;
  Map<String, dynamic>? metadata;
  SubNetworkIdentifier(this.network, this.metadata);
  factory SubNetworkIdentifier.fromMap(Map<String, dynamic> map) =>
      SubNetworkIdentifier(map["network"], map["metadata"]);
  Map<String, dynamic> toJson() => {"network": network, "metadata": metadata}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The block_identifier uniquely identifies a block in a particular network.
class BlockIdentifier {
  /// This is also known as the block height.
  int index;
  String hash;
  BlockIdentifier(this.index, this.hash);
  factory BlockIdentifier.fromMap(Map<String, dynamic> map) =>
      BlockIdentifier(map["index"], map["hash"]);
  Map<String, dynamic> toJson() => {"index": index, "hash": hash}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// When fetching data by BlockIdentifier, it may be possible to only specify the index or hash. If neither property is specified, it is assumed that the client is making a request at the current block.
class PartialBlockIdentifier {
  int? index;
  String? hash;
  PartialBlockIdentifier(this.index, this.hash);
  factory PartialBlockIdentifier.fromMap(Map<String, dynamic> map) =>
      PartialBlockIdentifier(map["index"], map["hash"]);
  Map<String, dynamic> toJson() => {"index": index, "hash": hash}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The transaction_identifier uniquely identifies a transaction in a particular network and block or in the mempool.
class TransactionIdentifier {
  /// Any transactions that are attributable only to a block (ex: a block event) should use the hash of the block as the identifier.
  String hash;
  TransactionIdentifier(this.hash);
  factory TransactionIdentifier.fromMap(Map<String, dynamic> map) =>
      TransactionIdentifier(map["hash"]);
  Map<String, dynamic> toJson() =>
      {"hash": hash}..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The operation_identifier uniquely identifies an operation within a transaction.
class OperationIdentifier {
  /// The operation index is used to ensure each operation has a unique identifier within a transaction. This index is only relative to the transaction and NOT GLOBAL. The operations in each transaction should start from index 0. To clarify, there may not be any notion of an operation index in the blockchain being described.
  int index;

  /// Some blockchains specify an operation index that is essential for client use. For example, Bitcoin uses a network_index to identify which UTXO was used in a transaction. network_index should not be populated if there is no notion of an operation index in a blockchain (typically most account-based blockchains).
  // ignore: non_constant_identifier_names
  int? network_index;

  OperationIdentifier(this.index, this.network_index);
  factory OperationIdentifier.fromMap(Map<String, dynamic> map) =>
      OperationIdentifier(map["index"], map["network_index"]);
  Map<String, dynamic> toJson() => {"index": index, "network_index": network_index}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The account_identifier uniquely identifies an account within a network. All fields in the account_identifier are utilized to determine this uniqueness (including the metadata field, if populated).
class AccountIdentifier {
  /// The address may be a cryptographic public key (or some encoding of it) or a provided username.
  String address;
  // ignore: non_constant_identifier_names
  SubAccountIdentifier? sub_account;

  /// Blockchains that utilize a username model (where the address is not a derivative of a cryptographic public key) should specify the public key(s) owned by the address in metadata.
  Map<String, dynamic>? metadata;
  AccountIdentifier(this.address, this.sub_account, this.metadata);
  factory AccountIdentifier.fromMap(Map<String, dynamic> map) => AccountIdentifier(
      map["address"],
      map["sub_account"] != null ? SubAccountIdentifier.fromMap(map["sub_account"]) : null,
      map["metadata"]);
  Map<String, dynamic> toJson() => {
        "address": address,
        "sub_account": sub_account?.toJson(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// An account may have state specific to a contract address (ERC-20 token) and/or a stake (delegated balance). The sub_account_identifier should specify which state (if applicable) an account instantiation refers to.
class SubAccountIdentifier {
  /// The SubAccount address may be a cryptographic value or some other identifier (ex: bonded) that uniquely specifies a SubAccount.
  String address;

  /// If the SubAccount address is not sufficient to uniquely specify a SubAccount, any other identifying information can be stored here. It is important to note that two SubAccounts with identical addresses but differing metadata will not be considered equal by clients.
  Map<String, dynamic>? metadata;
  SubAccountIdentifier(this.address, this.metadata);
  factory SubAccountIdentifier.fromMap(Map<String, dynamic> map) =>
      SubAccountIdentifier(map["address"], map["metadata"]);
  Map<String, dynamic> toJson() => {"address": address, "metadata": metadata}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Blocks contain an array of Transactions that occurred at a particular BlockIdentifier. A hard requirement for blocks returned by Rosetta implementations is that they MUST be _inalterable_: once a client has requested and received a block identified by a specific BlockIndentifier, all future calls for that same BlockIdentifier must return the same block contents.
class Block {
  // ignore: non_constant_identifier_names
  BlockIdentifier block_identifier;
  // ignore: non_constant_identifier_names
  BlockIdentifier parent_block_identifier;
  Timestamp timestamp;
  List<Transaction> transactions;
  Map<String, dynamic>? metadata;

  Block(this.block_identifier, this.parent_block_identifier, this.timestamp, this.transactions,
      this.metadata);
  factory Block.fromMap(Map<String, dynamic> map) => Block(
      BlockIdentifier.fromMap(map["block_identifier"]),
      BlockIdentifier.fromMap(map["parent_block_identifier"]),
      map["timestamp"],
      (map["transactions"] as List).map((e) => Transaction.fromMap(e)).toList(),
      map["metadata"]);

  Map<String, dynamic> toJson() => {
        "block_identifier": block_identifier.toJson(),
        "parent_block_identifier": parent_block_identifier.toJson(),
        "timestamp": timestamp,
        "transactions": transactions.map((e) => e.toJson()),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Transactions contain an array of Operations that are attributable to the same TransactionIdentifier.
class Transaction {
  // ignore: non_constant_identifier_names
  TransactionIdentifier transaction_identifier;
  List<Operation> operations;

  /// Transactions that are related to other transactions (like a cross-shard transaction) should include the tranaction_identifier of these transactions in the metadata.
  Map<String, dynamic>? metadata;

  Transaction(this.transaction_identifier, this.operations, this.metadata);
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(TransactionIdentifier.fromMap(map["transaction_identifier"]),
        (map["operations"] as List).map((e) => Operation.fromMap(e)).toList(), map["metadata"]);
  }
  Map<String, dynamic> toJson() => {
        "transaction_identifier": transaction_identifier.toJson(),
        "operations": operations.map((e) => e.toJson()).toList(),
        "metadata": metadata,
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Operations contain all balance-changing information within a transaction. They are always one-sided (only affect 1 AccountIdentifier) and can succeed or fail independently from a Transaction. Operations are used both to represent on-chain data (Data API) and to construct new transactions (Construction API), creating a standard interface for reading and writing to blockchains.
class Operation {
  /// Type is the network-specific type of the operation. Ensure that any type that can be returned here is also specified in the NetworkOptionsResponse. This can be very useful to downstream consumers that parse all block data.
  String type;
  // ignore: non_constant_identifier_names
  OperationIdentifier operation_identifier;

  /// Restrict referenced related_operations to identifier indexes < the current operation_identifier.index. This ensures there exists a clear DAG-structure of relations. Since operations are one-sided, one could imagine relating operations in a single transfer or linking operations in a call tree.
  // ignore: non_constant_identifier_names
  List<OperationIdentifier>? related_operations;

  /// Status is the network-specific status of the operation. Status is not defined on the transaction object because blockchains with smart contracts may have transactions that partially apply (some operations are successful and some are not). Blockchains with atomic transactions (all operations succeed or all operations fail) will have the same status for each operation. On-chain operations (operations retrieved in the `/block` and `/block/transaction` endpoints) MUST have a populated status field (anything on-chain must have succeeded or failed). However, operations provided during transaction construction (often times called "intent" in the documentation) MUST NOT have a populated status field (operations yet to be included on-chain have not yet succeeded or failed).
  String? status;
  AccountIdentifier? account;
  Amount? amount;
  // ignore: non_constant_identifier_names
  CoinChange? coin_change;
  Map<String, dynamic>? metadata;
  Operation(this.type, this.operation_identifier, this.related_operations, this.status,
      this.account, this.amount, this.coin_change, this.metadata);

  factory Operation.fromMap(Map<String, dynamic> map) {
    return Operation(
      map["type"],
      OperationIdentifier.fromMap(map["operation_identifier"]),
      map["related_operations"] != null
          ? (map["related_operations"] as List).map((e) => OperationIdentifier.fromMap(e)).toList()
          : null,
      map["status"],
      map["account"] != null ? AccountIdentifier.fromMap(map["account"]) : null,
      map["amount"] != null ? Amount.fromMap(map["amount"]) : null,
      map["coin_change"] != null ? CoinChange.fromMap(map["coin_change"]) : null,
      map["metadata"],
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "operation_identifier": operation_identifier.toJson(),
        "related_operations": related_operations?.map((e) => e.toJson()).toList(),
        "status": status,
        "account": account?.toJson(),
        "amount": amount?.toJson(),
        "coin_change": coin_change?.toJson(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Amount is some Value of a Currency. It is considered invalid to specify a Value without a Currency.
class Amount {
  /// Value of the transaction in atomic units represented as an arbitrary-sized signed integer. For example, 1 BTC would be represented by a value of 100000000.
  String value;
  Currency currency;
  Map<String, dynamic>? metadata;

  Amount(this.value, this.currency, this.metadata);
  factory Amount.fromMap(Map<String, dynamic> map) =>
      Amount(map["value"], Currency.fromMap(map["currency"]), map["metadata"]);
  Map<String, dynamic> toJson() => {
        "value": value,
        "currency": currency.toJson(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Currency is composed of a canonical Symbol and Decimals. This Decimals value is used to convert an Amount.Value from atomic units (Satoshis) to standard units (Bitcoins).
class Currency {
  /// Canonical symbol associated with a currency.
  String symbol;

  /// Number of decimal places in the standard unit representation of the amount. For example, BTC has 8 decimals. Note that it is not possible to represent the value of some currency in atomic units that is not base 10.
  int decimals;

  /// Any additional information related to the currency itself. For example, it would be useful to poputhis object with the contract address of an ERC-20 token.
  Map<String, dynamic>? metadata;
  Currency(this.symbol, this.decimals, this.metadata);
  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(map["symbol"], map["decimals"], map["metadata"]);
  }

  Map<String, dynamic> toJson() => {"symbol": symbol, "decimals": decimals, "metadata": metadata}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// SyncStatus is used to provide additional context about an implementation's sync status. It is often used to indicate that an implementation is healthy when it cannot be queried  until some sync phase occurs. If an implementation is immediately queryable, this model is often not populated.
class SyncStatus {
  /// CurrentIndex is the index of the last synced block in the current stage.
  // ignore: non_constant_identifier_names
  int current_index;

  /// TargetIndex is the index of the block that the implementation is attempting to sync to in the current stage.
  // ignore: non_constant_identifier_names
  int? target_index;

  /// Stage is the phase of the sync process.
  String? stage;
  SyncStatus(this.current_index, this.target_index, this.stage);
  factory SyncStatus.fromMap(Map<String, dynamic> map) =>
      SyncStatus(map["current_index"], map["target_index"], map["stage"]);
  Map<String, dynamic> toJson() => {
        "current_index": current_index,
        "target_index": target_index,
        "stage": stage
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A Peer is a representation of a node's peer.
class Peer {
  // ignore: non_constant_identifier_names
  String peer_id;
  Map<String, dynamic>? metadata;
  Peer(this.peer_id, this.metadata);
  factory Peer.fromMap(Map<String, dynamic> map) => Peer(map["peer_id"], map["metadata"]);
  Map<String, dynamic> toJson() => {"peer_id": peer_id, "metadata": metadata}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The Version object is utilized to inform the client of the versions of different components of the Rosetta implementation.
class Version {
  /// The rosetta_version is the version of the Rosetta interface the implementation adheres to. This can be useful for clients looking to reliably parse responses.
  // ignore: non_constant_identifier_names
  String rosetta_version;

  /// The node_version is the canonical version of the node runtime. This can help clients manage deployments.
  // ignore: non_constant_identifier_names
  String node_version;

  /// When a middleware server is used to adhere to the Rosetta interface, it should return its version here. This can help clients manage deployments.
  // ignore: non_constant_identifier_names
  String? middleware_version;

  /// Any other information that may be useful about versioning of dependent services should be returned here.
  Map<String, dynamic>? metadata;
  Version(this.rosetta_version, this.node_version, this.middleware_version, this.metadata);
  factory Version.fromMap(Map<String, dynamic> map) => Version(
      map["rosetta_version"], map["node_version"], map["middleware_version"], map["metadata"]);
  Map<String, dynamic> toJson() => {
        "rosetta_version": rosetta_version,
        "node_version": node_version,
        "middleware_version": middleware_version,
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Allow specifies supported Operation status, Operation types, and all possible error statuses. This Allow object is used by clients to validate the correctness of a Rosetta Server implementation. It is expected that these clients will error if they receive some response that contains any of the above information that is not specified here.
class Allow {
  /// All Operation.Status this implementation supports. Any status that is returned during parsing that is not listed here will cause client validation to error.
  // ignore: non_constant_identifier_names
  List<OperationStatus> operation_statuses;

  /// All Operation.Type this implementation supports. Any type that is returned during parsing that is not listed here will cause client validation to error.
  // ignore: non_constant_identifier_names
  List<String> operation_types;

  /// All Errors that this implementation could return. Any error that is returned during parsing that is not listed here will cause client validation to error.
  List<RosettaError> errors;

  /// Any Rosetta implementation that supports querying the balance of an account at any height in the past should set this to true.
  // ignore: non_constant_identifier_names
  bool historical_balance_lookup;

  /// If populated, `timestamp_start_index` indicates the first block index where block timestamps are considered valid (i.e. all blocks less than `timestamp_start_index` could have invalid timestamps). This is useful when the genesis block (or blocks) of a network have timestamp 0. If not populated, block timestamps are assumed to be valid for all available blocks.
  // ignore: non_constant_identifier_names
  int? timestamp_start_index;

  /// All methods that are supported by the /call endpoint. Communicating which parameters should be provided to /call is the responsibility of the implementer (this is en lieu of defining an entire type system and requiring the implementer to define that in Allow).
  // ignore: non_constant_identifier_names
  List<String> call_methods;

  /// BalanceExemptions is an array of BalanceExemption indicating which account balances could change without a corresponding Operation. BalanceExemptions should be used sparingly as they may introduce significant complexity for integrators that attempt to reconcile all account balance changes. If your implementation relies on any BalanceExemptions, you MUST implement historical balance lookup (the ability to query an account balance at any BlockIdentifier).
  // ignore: non_constant_identifier_names
  List<BalanceExemption> balance_exemptions;

  /// Any Rosetta implementation that can update an AccountIdentifier's unspent coins based on the contents of the mempool should poputhis field as true. If false, requests to `/account/coins` that set `include_mempool` as true will be automatically rejected.
  // ignore: non_constant_identifier_names
  bool mempool_coins;

  Allow(this.operation_statuses, this.operation_types, this.errors, this.historical_balance_lookup,
      this.call_methods, this.balance_exemptions, this.mempool_coins, this.timestamp_start_index);
  factory Allow.fromMap(Map<String, dynamic> map) {
    return Allow(
        (map["operation_statuses"] as List).map((e) => OperationStatus.fromMap(e)).toList(),
        (map["operation_types"] as List).map((e) => e.toString()).toList(),
        (map["errors"] as List).map((e) => RosettaError.fromMap(e)).toList(),
        map["historical_balance_lookup"],
        (map["call_methods"] as List).map((e) => e.toString()).toList(),
        (map["balance_exemptions"] as List).map((e) => BalanceExemption.fromMap(e)).toList(),
        map["mempool_coins"],
        map["timestamp_start_index"]);
  }

  Map<String, dynamic> toJson() => {
        "operation_statuses": operation_statuses.map((e) => e.toJson()).toList(),
        "operation_types": operation_types.map((e) => e.toString()).toList(),
        "errors": errors.map((e) => e.toJson()).toList(),
        "historical_balance_lookup": historical_balance_lookup,
        "call_methods": call_methods.map((e) => e.toString()).toList(),
        "balance_exemptions": balance_exemptions.map((e) => e.toString()).toList(),
        "mempool_coins": mempool_coins,
        "timestamp_start_index": timestamp_start_index
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// OperationStatus is utilized to indicate which Operation status are considered successful.
class OperationStatus {
  /// The status is the network-specific status of the operation.
  String status;

  /// An Operation is considered successful if the Operation.Amount should affect the Operation.Account. Some blockchains (like Bitcoin) only include successful operations in blocks but other blockchains (like Ethereum) include unsuccessful operations that incur a fee. To reconcile the computed balance from the stream of Operations, it is critical to understand which Operation.Status indicate an Operation is successful and should affect an Account.
  bool successful;

  OperationStatus(this.status, this.successful);
  factory OperationStatus.fromMap(Map<String, dynamic> map) =>
      OperationStatus(map["status"], map["successful"]);
  Map<String, dynamic> toJson() => {"status": status, "successful": successful}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The timestamp of the block in milliseconds since the Unix Epoch. The timestamp is stored in milliseconds because some blockchains produce blocks more often than once a second.
typedef Timestamp = int;

/// PublicKey contains a public key byte array for a particular CurveType encoded in hex. Note that there is no PrivateKey struct as this is NEVER the concern of an implementation.
class PublicKey {
  /// Hex-encoded public key bytes in the format specified by the CurveType.
  // ignore: non_constant_identifier_names
  String hex_bytes;
  // ignore: non_constant_identifier_names
  String curve_type; // "secp256k1" | "secp256r1" | "edwards25519" | "tweedle";

  PublicKey(this.hex_bytes, this.curve_type);

  factory PublicKey.fromMap(Map<String, dynamic> map) =>
      PublicKey(map["hex_bytes"], map["curve_type"]);
  Map<String, dynamic> toJson() => {"hex_bytes": hex_bytes, "curve_type": curve_type}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

///
///CurveType is the type of cryptographic curve associated with a PublicKey. * secp256k1: SEC compressed - `33 bytes` (https://secg.org/sec1-v2.pdf#subsubsection.2.3.3) * secp256r1: SEC compressed - `33 bytes` (https://secg.org/sec1-v2.pdf#subsubsection.2.3.3) * edwards25519: `y (255-bits) || x-sign-bit (1-bit)` - `32 bytes` (https://ed25519.cr.yp.to/ed25519-20110926.pdf) * tweedle: 1st pk : Fq.t (32 bytes) || 2nd pk : Fq.t (32 bytes) (https://github.com/CodaProtocol/coda/blob/develop/rfcs/0038-rosetta-construction-api.md#marshal-keys)
///
/// SigningPayload is signed by the client with the keypair associated with an AccountIdentifier using the specified SignatureType. SignatureType can be optionally populated if there is a restriction on the signature scheme that can be used to sign the payload.
class SigningPayload {
  /// [DEPRECATED by `account_identifier` in `v1.4.4`] The network-specific address of the account that should sign the payload.
  // ignore: non_constant_identifier_names
  String hex_bytes;
  String? address;
  // ignore: non_constant_identifier_names
  AccountIdentifier? account_identifier;
  // ignore: non_constant_identifier_names
  String? signature_type;

  SigningPayload(this.hex_bytes, this.address, this.account_identifier, this.signature_type);

  factory SigningPayload.fromMap(Map<String, dynamic> map) => SigningPayload(
      map["hex_bytes"],
      map["address"],
      map["account_identifier"] != null
          ? AccountIdentifier.fromMap(map["account_identifier"])
          : null,
      map["signature_type"]);

  Map<String, dynamic> toJson() => {
        "hex_bytes": hex_bytes,
        "address": address,
        "account_identifier": account_identifier?.toJson(),
        "signature_type": signature_type
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Signature contains the payload that was signed, the public keys of the keypairs used to produce the signature, the signature (encoded in hex), and the SignatureType. PublicKey is often times not known during construction of the signing payloads but may be needed to combine signatures properly.
class Signature {
  // ignore: non_constant_identifier_names
  SigningPayload signing_payload;
  // ignore: non_constant_identifier_names
  PublicKey public_key;

  /// export type SignatureType =
  ///   | "ecdsa"
  ///   | "ecdsa_recovery"
  ///   | "ed25519"
  ///   | "schnorr_1"
  ///   | "schnorr_poseidon";
  // ignore: non_constant_identifier_names
  String signature_type;
  // ignore: non_constant_identifier_names
  String hex_bytes;

  Signature(this.signing_payload, this.public_key, this.signature_type, this.hex_bytes);
  factory Signature.fromMap(Map<String, dynamic> map) {
    return Signature(SigningPayload.fromMap(map["signing_payload"]),
        PublicKey.fromMap(map["public_key"]), map["signature_type"], map["hex_bytes"]);
  }
  Map<String, dynamic> toJson() => {
        "signing_payload": signing_payload.toJson(),
        "public_key": public_key.toJson(),
        "signature_type": signature_type,
        "hex_bytes": hex_bytes
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

///
/// SignatureType is the type of a cryptographic signature. * ecdsa: `r (32-bytes) || s (32-bytes)` - `64 bytes` * ecdsa_recovery: `r (32-bytes) || s (32-bytes) || v (1-byte)` - `65 bytes` * ed25519: `R (32-byte) || s (32-bytes)` - `64 bytes` * schnorr_1: `r (32-bytes) || s (32-bytes)` - `64 bytes`  (schnorr signature implemented by Zilliqa where both `r` and `s` are scalars encoded as `32-bytes` values, most significant byte first.) * schnorr_poseidon: `r (32-bytes) || s (32-bytes)` where s = Hash(1st pk || 2nd pk || r) - `64 bytes`  (schnorr signature w/ Poseidon hash function implemented by O(1) Labs where both `r` and `s` are scalars encoded as `32-bytes` values, least significant byte first. https://github.com/CodaProtocol/signer-reference/blob/master/schnorr.ml )
/// CoinActions are different state changes that a Coin can undergo. When a Coin is created, it is coin_created. When a Coin is spent, it is coin_spent. It is assumed that a single Coin cannot be created or spent more than once.
///
/// CoinIdentifier uniquely identifies a Coin.
class CoinIdentifier {
  /// Identifier should be populated with a globally unique identifier of a Coin. In Bitcoin, this identifier would be transaction_hash:index.
  String identifier;
  CoinIdentifier(this.identifier);
  factory CoinIdentifier.fromMap(Map<String, dynamic> map) => CoinIdentifier(map["identifier"]);
  Map<String, dynamic> toJson() => {"identifier": identifier}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// CoinChange is used to represent a change in state of a some coin identified by a coin_identifier. This object is part of the Operation model and must be populated for UTXO-based blockchains. Coincidentally, this abstraction of UTXOs allows for supporting both account-based transfers and UTXO-based transfers on the same blockchain (when a transfer is account-based, don't poputhis model).
class CoinChange {
  // ignore: non_constant_identifier_names
  CoinIdentifier coin_identifier;
  // ignore: non_constant_identifier_names
  String coin_action; // "coin_created" | "coin_spent";
  CoinChange(this.coin_action, this.coin_identifier);
  factory CoinChange.fromMap(Map<String, dynamic> map) =>
      CoinChange(map["coin_action"], CoinIdentifier.fromMap(map["coin_identifier"]));
  Map<String, dynamic> toJson() => {
        "coin_identifier": coin_identifier.toJson(),
        "coin_action": coin_action
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Coin contains its unique identifier and the amount it represents.
class Coin {
  // ignore: non_constant_identifier_names
  CoinIdentifier coin_identifier;
  Amount amount;
  Coin(this.amount, this.coin_identifier);
  factory Coin.fromMap(Map<String, dynamic> map) =>
      Coin(Amount.fromMap(map["amount"]), CoinIdentifier.fromMap(map["coin_identifier"]));
  Map<String, dynamic> toJson() => {
        "coin_identifier": coin_identifier.toJson(),
        "amount": amount.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// BalanceExemption indicates that the balance for an exempt account could change without a corresponding Operation. This typically occurs with staking rewards, vesting balances, and Currencies with a dynamic supply. Currently, it is possible to exempt an account from strict reconciliation by SubAccountIdentifier.Address or by Currency. This means that any account with SubAccountIdentifier.Address would be exempt or any balance of a particular Currency would be exempt, respectively. BalanceExemptions should be used sparingly as they may introduce significant complexity for integrators that attempt to reconcile all account balance changes. If your implementation relies on any BalanceExemptions, you MUST implement historical balance lookup (the ability to query an account balance at any BlockIdentifier).
class BalanceExemption {
  /// SubAccountAddress is the SubAccountIdentifier.Address that the BalanceExemption applies to (regardless of the value of SubAccountIdentifier.Metadata).
  // ignore: non_constant_identifier_names
  String? sub_account_address;
  Currency? currency;
  // ignore: non_constant_identifier_names
  String? exemption_type; // "greater_or_equal" | "less_or_equal" | "dynamic";

  BalanceExemption(this.sub_account_address, this.currency, this.exemption_type);
  factory BalanceExemption.fromMap(Map<String, dynamic> map) {
    return BalanceExemption(map["sub_account_address"],
        map["currency"] != null ? Currency.fromMap(map["currency"]) : null, map["exemption_type"]);
  }
  Map<String, dynamic> toJson() => {
        "sub_account_address": sub_account_address,
        "currency": currency?.toJson(),
        "exemption_type": exemption_type
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ExemptionType is used to indicate if the live balance for an account subject to a BalanceExemption could increase above, decrease below, or equal the computed balance. * greater_or_equal: The live balance may increase above or equal the computed balance. This typically   occurs with staking rewards that accrue on each block. * less_or_equal: The live balance may decrease below or equal the computed balance. This typically   occurs as balance moves from locked to spendable on a vesting account. * dynamic: The live balance may increase above, decrease below, or equal the computed balance. This   typically occurs with tokens that have a dynamic supply.
/// export type ExemptionType = "greater_or_equal" | "less_or_equal" | "dynamic";
/// BlockEvent represents the addition or removal of a BlockIdentifier from storage. Streaming BlockEvents allows lightweight clients to update their own state without needing to implement their own syncing logic.
class BlockEvent {
  /// sequence is the unique identifier of a BlockEvent within the context of a NetworkIdentifier.
  int sequence;
  // ignore: non_constant_identifier_names
  BlockIdentifier block_identifier;
  String type; // "block_added" | "block_removed"

  BlockEvent(this.sequence, this.block_identifier, this.type);
  factory BlockEvent.fromMap(Map<String, dynamic> map) {
    return BlockEvent(
        map["sequence"], BlockIdentifier.fromMap(map["block_identifier"]), map["type"]);
  }

  Map<String, dynamic> toJson() => {
        "sequence": sequence,
        "block_identifier": block_identifier.toJson(),
        "type": type
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/**
 * BlockEventType determines if a BlockEvent represents the addition or removal of a block.
 */
// export type BlockEventType = "block_added" | "block_removed";

/**
 * Operator is used by query-related endpoints to determine how to apply conditions. If this field is not populated, the default `and` value will be used.
 */
// export type Operator = "or" | "and";

/// BlockTransaction contains a populated Transaction and the BlockIdentifier that contains it.
class BlockTransaction {
  // ignore: non_constant_identifier_names
  BlockIdentifier block_identifier;
  Transaction transaction;
  BlockTransaction(this.block_identifier, this.transaction);
  factory BlockTransaction.fromMap(Map<String, dynamic> map) {
    return BlockTransaction(
        BlockIdentifier.fromMap(map["block_identifier"]), Transaction.fromMap(map["transaction"]));
  }
  Map<String, dynamic> toJson() => {
        "block_identifier": block_identifier.toJson(),
        "transaction": transaction.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// An AccountBalanceRequest is utilized to make a balance request on the /account/balance endpoint. If the block_identifier is populated, a historical balance query should be performed.
class AccountBalanceRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  AccountIdentifier account_identifier;
  // ignore: non_constant_identifier_names
  PartialBlockIdentifier? block_identifier;

  /// In some cases, the caller may not want to retrieve all available balances for an AccountIdentifier. If the currencies field is populated, only balances for the specified currencies will be returned. If not populated, all available balances will be returned.
  List<Currency>? currencies;

  AccountBalanceRequest(
      this.network_identifier, this.account_identifier, this.block_identifier, this.currencies);

  factory AccountBalanceRequest.fromMap(Map<String, dynamic> map) {
    return AccountBalanceRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]),
        AccountIdentifier.fromMap(map["account_identifier"]),
        PartialBlockIdentifier.fromMap(map["block_identifier"]),
        map["currencies"] != null
            ? (map["currencies"] as List).map((e) => Currency.fromMap(e)).toList()
            : null);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "account_identifier": account_identifier.toJson(),
        "block_identifier": block_identifier?.toJson(),
        "currencies": currencies?.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// An AccountBalanceResponse is returned on the /account/balance endpoint. If an account has a balance for each AccountIdentifier describing it (ex: an ERC-20 token balance on a few smart contracts), an account balance request must be made with each AccountIdentifier. The `coins` field was removed and replaced by by `/account/coins` in `v1.4.7`.
class AccountBalanceResponse {
  // ignore: non_constant_identifier_names
  BlockIdentifier block_identifier;

  /// A single account may have a balance in multiple currencies.
  List<Amount> balances;

  /// Account-based blockchains that utilize a nonce or sequence number should include that number in the metadata. This number could be unique to the identifier or global across the account address.
  Map<String, dynamic>? metadata;

  AccountBalanceResponse(this.block_identifier, this.balances, this.metadata);
  factory AccountBalanceResponse.fromMap(Map<String, dynamic> map) {
    return AccountBalanceResponse(BlockIdentifier.fromMap(map["block_identifier"]),
        (map["balances"] as List).map((e) => Amount.fromMap(e)).toList(), map["metadata"]);
  }

  Map<String, dynamic> toJson() => {
        "block_identifier": block_identifier.toJson(),
        "balances": balances.map((e) => e.toJson()).toList(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// AccountCoinsRequest is utilized to make a request on the /account/coins endpoint.
class AccountCoinsRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  AccountIdentifier account_identifier;

  /// Include state from the mempool when looking up an account's unspent coins. Note, using this functionality breaks any guarantee of idempotency.
  // ignore: non_constant_identifier_names
  bool include_mempool;

  /// In some cases, the caller may not want to retrieve coins for all currencies for an AccountIdentifier. If the currencies field is populated, only coins for the specified currencies will be returned. If not populated, all unspent coins will be returned.
  List<Currency>? currencies;

  AccountCoinsRequest(
      this.network_identifier, this.account_identifier, this.include_mempool, this.currencies);

  factory AccountCoinsRequest.fromMap(Map<String, dynamic> map) {
    return AccountCoinsRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]),
        AccountIdentifier.fromMap(map["account_identifier"]),
        map["include_mempool"],
        map["currencies"] != null
            ? (map["currencies"] as List).map((e) => Currency.fromMap(e)).toList()
            : null);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "account_identifier": account_identifier.toJson(),
        "include_mempool": include_mempool,
        "currencies": currencies?.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// AccountCoinsResponse is returned on the /account/coins endpoint and includes all unspent Coins owned by an AccountIdentifier.
class AccountCoinsResponse {
  // ignore: non_constant_identifier_names
  BlockIdentifier block_identifier;

  /// If a blockchain is UTXO-based, all unspent Coins owned by an account_identifier should be returned alongside the balance. It is highly recommended to poputhis field so that users of the Rosetta API implementation don't need to maintain their own indexer to track their UTXOs.
  List<Coin> coins;

  /// Account-based blockchains that utilize a nonce or sequence number should include that number in the metadata. This number could be unique to the identifier or global across the account address.
  Map<String, dynamic>? metadata;

  AccountCoinsResponse(this.block_identifier, this.coins, this.metadata);
  factory AccountCoinsResponse.fromMap(Map<String, dynamic> map) {
    return AccountCoinsResponse(BlockIdentifier.fromMap(map["block_identifier"]),
        (map["coins"] as List).map((e) => Coin.fromMap(e)).toList(), map["metadata"]);
  }
  Map<String, dynamic> toJson() => {
        "block_identifier": block_identifier.toJson(),
        "coins": coins.map((e) => e.toJson()).toList(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A BlockRequest is utilized to make a block request on the /block endpoint.
class BlockRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  PartialBlockIdentifier block_identifier;

  BlockRequest(this.network_identifier, this.block_identifier);
  factory BlockRequest.fromMap(Map<String, dynamic> map) {
    return BlockRequest(NetworkIdentifier.fromMap(map["network_identifier"]),
        PartialBlockIdentifier.fromMap(map["block_identifier"]));
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "block_identifier": block_identifier.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A BlockResponse includes a fully-populated block or a partially-populated block with a list of other transactions to fetch (other_transactions). As a result of the consensus algorithm of some blockchains, blocks can be omitted (i.e. certain block indexes can be skipped). If a query for one of these omitted indexes is made, the response should not include a `Block` object. It is VERY important to note that blocks MUST still form a canonical, connected chain of blocks where each block has a unique index. In other words, the `PartialBlockIdentifier` of a block after an omitted block should reference the last non-omitted block.
class BlockResponse {
  Block? block;

  /// Some blockchains may require additional transactions to be fetched that weren't returned in the block response (ex: block only returns transaction hashes). For blockchains with a lot of transactions in each block, this can be very useful as consumers can concurrently fetch all transactions returned.
  // ignore: non_constant_identifier_names
  List<TransactionIdentifier>? other_transactions;

  BlockResponse(this.block, this.other_transactions);
  factory BlockResponse.fromMap(Map<String, dynamic> map) {
    return BlockResponse(
        map["block"] != null ? Block.fromMap(map["block"]) : null,
        map["other_transactions"] != null
            ? (map["other_transactions"] as List)
                .map((e) => TransactionIdentifier.fromMap(e))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() => {
        "block": block?.toJson(),
        "other_transactions": other_transactions?.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A BlockTransactionRequest is used to fetch a Transaction included in a block that is not returned in a BlockResponse.
class BlockTransactionRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  BlockIdentifier block_identifier;
  // ignore: non_constant_identifier_names
  TransactionIdentifier transaction_identifier;

  BlockTransactionRequest(
      this.network_identifier, this.block_identifier, this.transaction_identifier);
  factory BlockTransactionRequest.fromMap(Map<String, dynamic> map) {
    return BlockTransactionRequest(
        map["network_identifier"], map["block_identifier"], map["transaction_identifier"]);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "block_identifier": block_identifier.toJson(),
        "transaction_identifier": transaction_identifier.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A BlockTransactionResponse contains information about a block transaction.
class BlockTransactionResponse {
  Transaction transaction;
  BlockTransactionResponse(this.transaction);
  factory BlockTransactionResponse.fromMap(Map<String, dynamic> map) =>
      BlockTransactionResponse(Transaction.fromMap(map["transaction"]));
  Map<String, dynamic> toJson() => {"transaction": transaction.toJson()}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A MempoolResponse contains all transaction identifiers in the mempool for a particular network_identifier.
class MempoolResponse {
  // ignore: non_constant_identifier_names
  List<TransactionIdentifier> transaction_identifiers;
  MempoolResponse(this.transaction_identifiers);
  factory MempoolResponse.fromMap(Map<String, dynamic> map) =>
      MempoolResponse((map["transaction_identifiers"] as List)
          .map((e) => TransactionIdentifier.fromMap(e))
          .toList());
  Map<String, dynamic> toJson() => {
        "transaction_identifiers": transaction_identifiers.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A MempoolTransactionRequest is utilized to retrieve a transaction from the mempool.
class MempoolTransactionRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  TransactionIdentifier transaction_identifier;
  MempoolTransactionRequest(this.network_identifier, this.transaction_identifier);
  factory MempoolTransactionRequest.fromMap(Map<String, dynamic> map) => MempoolTransactionRequest(
      NetworkIdentifier.fromMap(map["network_identifier"]),
      TransactionIdentifier.fromMap(map["transaction_identifier"]));
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "transaction_identifier": transaction_identifier.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A MempoolTransactionResponse contains an estimate of a mempool transaction. It may not be possible to know the full impact of a transaction in the mempool (ex: fee paid).
class MempoolTransactionResponse {
  Transaction transaction;
  Map<String, dynamic>? metadata;
  MempoolTransactionResponse(this.transaction, this.metadata);
  factory MempoolTransactionResponse.fromMap(Map<String, dynamic> map) =>
      MempoolTransactionResponse(Transaction.fromMap(map["transaction"]), map["metadata"]);
  Map<String, dynamic> toJson() => {"transaction": transaction.toJson(), "metadata": metadata}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A MetadataRequest is utilized in any request where the only argument is optional metadata.
class MetadataRequest {
  Map<String, dynamic>? metadata;
  MetadataRequest(this.metadata);
  factory MetadataRequest.fromMap(Map<String, dynamic> map) => MetadataRequest(map["metadata"]);
  Map<String, dynamic> toJson() => {"metadata": metadata}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A NetworkListResponse contains all NetworkIdentifiers that the node can serve information for.
class NetworkListResponse {
  // ignore: non_constant_identifier_names
  List<NetworkIdentifier> network_identifiers;
  NetworkListResponse(this.network_identifiers);
  factory NetworkListResponse.fromMap(Map<String, dynamic> map) => NetworkListResponse(
      (map["network_identifiers"] as List).map((e) => NetworkIdentifier.fromMap(e)).toList());
  Map<String, dynamic> toJson() => {
        "network_identifiers": network_identifiers.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A NetworkRequest is utilized to retrieve some data specific exclusively to a NetworkIdentifier.
class NetworkRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  Map<String, dynamic>? metadata;
  NetworkRequest(this.network_identifier, this.metadata);
  factory NetworkRequest.fromMap(Map<String, dynamic> map) =>
      NetworkRequest(NetworkIdentifier.fromMap(map["network_identifier"]), map["metadata"]);
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// NetworkStatusResponse contains basic information about the node's view of a blockchain network. It is assumed that any BlockIdentifier.Index less than or equal to CurrentBlockIdentifier.Index can be queried. If a Rosetta implementation prunes historical state, it should poputhe optional `oldest_block_identifier` field with the oldest block available to query. If this is not populated, it is assumed that the `genesis_block_identifier` is the oldest queryable block. If a Rosetta implementation performs some pre-sync before it is possible to query blocks, sync_status should be populated so that clients can still monitor healthiness. Without this field, it may appear that the implementation is stuck syncing and needs to be terminated.
class NetworkStatusResponse {
  // ignore: non_constant_identifier_names
  BlockIdentifier current_block_identifier;
  // ignore: non_constant_identifier_names
  Timestamp current_block_timestamp;
  // ignore: non_constant_identifier_names
  BlockIdentifier genesis_block_identifier;
  // ignore: non_constant_identifier_names
  BlockIdentifier? oldest_block_identifier;
  // ignore: non_constant_identifier_names
  SyncStatus? sync_status;
  List<Peer> peers;

  NetworkStatusResponse(this.current_block_identifier, this.current_block_timestamp,
      this.genesis_block_identifier, this.peers, this.oldest_block_identifier, this.sync_status);

  factory NetworkStatusResponse.fromMap(Map<String, dynamic> map) {
    return NetworkStatusResponse(
        BlockIdentifier.fromMap(map["current_block_identifier"]),
        map["current_block_timestamp"],
        BlockIdentifier.fromMap(map["genesis_block_identifier"]),
        (map["peers"] as List).map((e) => Peer.fromMap(e)).toList(),
        map["oldest_block_identifier"],
        map["sync_status"]);
  }
  Map<String, dynamic> toJson() => {
        "current_block_identifier": current_block_identifier.toJson(),
        "current_block_timestamp": current_block_timestamp,
        "genesis_block_identifier": genesis_block_identifier.toJson(),
        "peers": peers.map((e) => e.toJson()).toList(),
        "oldest_block_identifier": oldest_block_identifier?.toJson(),
        "sync_status": sync_status?.toJson()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// NetworkOptionsResponse contains information about the versioning of the node and the allowed operation statuses, operation types, and errors.
class NetworkOptionsResponse {
  Version version;
  Allow allow;
  NetworkOptionsResponse(this.version, this.allow);
  factory NetworkOptionsResponse.fromMap(Map<String, dynamic> map) {
    return NetworkOptionsResponse(Version.fromMap(map["version"]), Allow.fromMap(map["allow"]));
  }

  Map<String, dynamic> toJson() => {"version": version.toJson(), "allow": allow.toJson()}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// A ConstructionMetadataRequest is utilized to get information required to construct a transaction. The Options object used to specify which metadata to return is left purposely unstructured to allow flexibility for implementers. Options is not required in the case that there is network-wide metadata of interest. Optionally, the request can also include an array of PublicKeys associated with the AccountIdentifiers returned in ConstructionPreprocessResponse.
class ConstructionMetadataRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;

  /// Some blockchains require different metadata for different types of transaction construction (ex: delegation versus a transfer). Instead of requiring a blockchain node to return all possible types of metadata for construction (which may require multiple node fetches), the client can popuan options object to limit the metadata returned to only the subset required.
  Map<String, dynamic>? options;
  // ignore: non_constant_identifier_names
  List<PublicKey>? public_keys;
  ConstructionMetadataRequest(this.network_identifier, this.options, this.public_keys);
  factory ConstructionMetadataRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionMetadataRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]),
        map["options"],
        map["public_keys"] != null
            ? (map["public_keys"] as List).map((e) => PublicKey.fromMap(e)).toList()
            : null);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "options": options,
        "public_keys": public_keys?.map((e) => e.toJson())
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The ConstructionMetadataResponse returns network-specific metadata used for transaction construction. Optionally, the implementer can return the suggested fee associated with the transaction being constructed. The caller may use this info to adjust the intent of the transaction or to create a transaction with a different account that can pay the suggested fee. Suggested fee is an array in case fee payment must occur in multiple currencies.
class ConstructionMetadataResponse {
  Map<String, dynamic> metadata;
  // ignore: non_constant_identifier_names
  List<Amount>? suggested_fee;
  ConstructionMetadataResponse(this.metadata, this.suggested_fee);
  factory ConstructionMetadataResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionMetadataResponse(
        map["metadata"],
        map["suggested_fee"] != null
            ? (map["suggested_fee"] as List).map((e) => Amount.fromMap(e)).toList()
            : null);
  }
  Map<String, dynamic> toJson() => {
        "metadata": metadata,
        "suggested_fee": suggested_fee?.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionDeriveRequest is passed to the `/construction/derive` endpoint. Network is provided in the request because some blockchains have different address formats for different networks. Metadata is provided in the request because some blockchains allow for multiple address types (i.e. different address for validators vs normal accounts).
class ConstructionDeriveRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  PublicKey public_key;
  Map<String, dynamic>? metadata;
  ConstructionDeriveRequest(this.network_identifier, this.public_key, this.metadata);
  factory ConstructionDeriveRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionDeriveRequest(NetworkIdentifier.fromMap(map["network_identifier"]),
        PublicKey.fromMap(map["public_key"]), map["metadata"]);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "public_key": public_key.toJson(),
        "meta_data": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionDeriveResponse is returned by the `/construction/derive` endpoint.
class ConstructionDeriveResponse {
  /// [DEPRECATED by `account_identifier` in `v1.4.4`] Address in network-specific format.
  String? address;
  // ignore: non_constant_identifier_names
  AccountIdentifier? account_identifier;
  Map<String, dynamic>? metadata;

  ConstructionDeriveResponse(this.address, this.account_identifier, this.metadata);
  factory ConstructionDeriveResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionDeriveResponse(
        map["address"], AccountIdentifier.fromMap(map["account_identifier"]), map["metadata"]);
  }
  Map<String, dynamic> toJson() => {
        "address": address,
        "account_identifier": account_identifier?.toJson(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionPreprocessRequest is passed to the `/construction/preprocess` endpoint so that a Rosetta implementation can determine which metadata it needs to request for construction. Metadata provided in this object should NEVER be a product of live data (i.e. the caller must follow some network-specific data fetching strategy outside of the Construction API to popurequired Metadata). If live data is required for construction, it MUST be fetched in the call to `/construction/metadata`. The caller can provide a max fee they are willing to pay for a transaction. This is an array in the case fees must be paid in multiple currencies. The caller can also provide a suggested fee multiplier to indicate that the suggested fee should be scaled. This may be used to set higher fees for urgent transactions or to pay lower fees when there is less urgency. It is assumed that providing a very low multiplier (like 0.0001) will never lead to a transaction being created with a fee less than the minimum network fee (if applicable). In the case that the caller provides both a max fee and a suggested fee multiplier, the max fee will set an upper bound on the suggested fee (regardless of the multiplier provided).
class ConstructionPreprocessRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  List<Operation> operations;
  Map<String, dynamic>? metadata;
  // ignore: non_constant_identifier_names
  List<Amount>? max_fee;
  // ignore: non_constant_identifier_names
  int? suggested_fee_multiplier;

  ConstructionPreprocessRequest(this.network_identifier, this.operations, this.metadata,
      this.max_fee, this.suggested_fee_multiplier);
  factory ConstructionPreprocessRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionPreprocessRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]),
        (map["operations"] as List).map((e) => Operation.fromMap(e)).toList(),
        map["metadata"],
        map["max_fee"] != null
            ? (map["max_fee"] as List).map((e) => Amount.fromMap(e)).toList()
            : null,
        map["suggested_fee_multiplier"]);
  }

  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "operations": operations.map((e) => e.toJson()),
        "metadata": metadata,
        "max_fee": max_fee?.map((e) => e.toJson()),
        "suggested_fee_multiplier": suggested_fee_multiplier
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionPreprocessResponse contains `options` that will be sent unmodified to `/construction/metadata`. If it is not necessary to make a request to `/construction/metadata`, `options` should be omitted.  Some blockchains require the PublicKey of particular AccountIdentifiers to construct a valid transaction. To fetch these PublicKeys, popu`required_public_keys` with the AccountIdentifiers associated with the desired PublicKeys. If it is not necessary to retrieve any PublicKeys for construction, `required_public_keys` should be omitted.
class ConstructionPreprocessResponse {
  /// The options that will be sent directly to `/construction/metadata` by the caller.
  Map<String, dynamic>? options;
  // ignore: non_constant_identifier_names
  List<AccountIdentifier>? required_public_keys;

  ConstructionPreprocessResponse(this.options, this.required_public_keys);
  factory ConstructionPreprocessResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionPreprocessResponse(
        map["options"],
        map['required_public_keys'] != null
            ? (map["required_public_keys"] as List)
                .map((e) => AccountIdentifier.fromMap(e))
                .toList()
            : null);
  }
}

/// ConstructionPayloadsRequest is the request to `/construction/payloads`. It contains the network, a slice of operations, and arbitrary metadata that was returned by the call to `/construction/metadata`. Optionally, the request can also include an array of PublicKeys associated with the AccountIdentifiers returned in ConstructionPreprocessResponse.
class ConstructionPayloadsRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  List<Operation> operations;
  Map<String, dynamic>? metadata;
  // ignore: non_constant_identifier_names
  List<PublicKey>? public_keys;
  ConstructionPayloadsRequest(
      this.network_identifier, this.operations, this.metadata, this.public_keys);
  factory ConstructionPayloadsRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionPayloadsRequest(
      NetworkIdentifier.fromMap(map["network_identifier"]),
      (map["operations"] as List).map((e) => Operation.fromMap(e)).toList(),
      map["metadata"],
      map["public_keys"] != null
          ? (map["public_keys"] as List).map((e) => PublicKey.fromMap(e)).toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "operations": operations.map((e) => e.toJson()).toList(),
        "public_keys": public_keys?.map((e) => e.toJson()).toList(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

abstract class SignablePayload {
  // ignore: non_constant_identifier_names
  final String unsigned_transaction;
  final List<SigningPayload> payloads;
  SignablePayload(this.unsigned_transaction, this.payloads);
  Map<String, dynamic> toJson();
}

/// ConstructionTransactionResponse is returned by `/construction/payloads`. It contains an unsigned transaction blob (that is usually needed to construct the a network transaction from a collection of signatures) and an array of payloads that must be signed by the caller.
class ConstructionPayloadsResponse extends SignablePayload {
  // ignore: non_constant_identifier_names
  ConstructionPayloadsResponse(String unsigned_transaction, List<SigningPayload> payloads)
      : super(unsigned_transaction, payloads);
  factory ConstructionPayloadsResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionPayloadsResponse(map["unsigned_transaction"],
        (map["payloads"] as List).map((e) => SigningPayload.fromMap(e)).toList());
  }
  @override
  Map<String, dynamic> toJson() => {
        "unsigned_transaction": unsigned_transaction,
        "payloads": payloads.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionCombineRequest is the input to the `/construction/combine` endpoint. It contains the unsigned transaction blob returned by `/construction/payloads` and all required signatures to create a network transaction.
class ConstructionCombineRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  String unsigned_transaction;
  List<Signature> signatures;

  ConstructionCombineRequest(this.network_identifier, this.unsigned_transaction, this.signatures);
  factory ConstructionCombineRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionCombineRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]),
        map["unsigned_transaction"],
        (map["signatures"] as List).map((e) => Signature.fromMap(e)).toList());
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "unsigned_transaction": unsigned_transaction,
        "signatures": signatures.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

class ConstructionCombineRequestPart {
  // ignore: non_constant_identifier_names
  NetworkIdentifier? network_identifier;
  // ignore: non_constant_identifier_names
  String unsigned_transaction;
  List<Signature> signatures;

  ConstructionCombineRequestPart(
      this.network_identifier, this.unsigned_transaction, this.signatures);
  factory ConstructionCombineRequestPart.fromMap(Map<String, dynamic> map) {
    return ConstructionCombineRequestPart(
        map["network_identifier"] != null
            ? NetworkIdentifier.fromMap(map["network_identifier"])
            : null,
        map["unsigned_transaction"],
        (map["signatures"] as List).map((e) => Signature.fromMap(e)).toList());
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier?.toJson(),
        "unsigned_transaction": unsigned_transaction,
        "signatures": signatures.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionCombineResponse is returned by `/construction/combine`. The network payload will be sent directly to the `construction/submit` endpoint.
class ConstructionCombineResponse {
  // ignore: non_constant_identifier_names
  String signed_transaction;
  ConstructionCombineResponse(this.signed_transaction);
  factory ConstructionCombineResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionCombineResponse(map["signed_transaction"]);
  }

  Map<String, dynamic> toJson() => {"signed_transaction": signed_transaction}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionParseRequest is the input to the `/construction/parse` endpoint. It allows the caller to parse either an unsigned or signed transaction.
class ConstructionParseRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;

  /// Signed is a boolean indicating whether the transaction is signed.
  bool signed;

  /// This must be either the unsigned transaction blob returned by `/construction/payloads` or the signed transaction blob returned by `/construction/combine`.
  String transaction;

  ConstructionParseRequest(this.network_identifier, this.signed, this.transaction);
  factory ConstructionParseRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionParseRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]), map["signed"], map["transaction"]);
  }

  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "signed": signed,
        "transaction": transaction
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionParseResponse contains an array of operations that occur in a transaction blob. This should match the array of operations provided to `/construction/preprocess` and `/construction/payloads`.
class ConstructionParseResponse {
  List<Operation> operations;

  /// [DEPRECATED by `account_identifier_signers` in `v1.4.4`] All signers (addresses) of a particular transaction. If the transaction is unsigned, it should be empty.
  List<String>? signers;
  // ignore: non_constant_identifier_names
  List<AccountIdentifier>? account_identifier_signers;
  Map<String, dynamic>? metadata;

  ConstructionParseResponse(
      this.operations, this.signers, this.account_identifier_signers, this.metadata);
  factory ConstructionParseResponse.fromMap(Map<String, dynamic> map) {
    return ConstructionParseResponse(
        (map["operations"] as List).map((e) => Operation.fromMap(e)).toList(),
        map["signers"] != null ? (map["signers"] as List).map((e) => e.toString()).toList() : null,
        map["account_identifier_signers"] != null
            ? (map["account_identifier_signers"] as List)
                .map((e) => AccountIdentifier.fromMap(e))
                .toList()
            : null,
        map["metadata"]);
  }
  Map<String, dynamic> toJson() => {
        "operations": operations.map((e) => e.toJson()).toList(),
        "signers": signers?.map((e) => e.toString()).toList(),
        "account_identifier_signers": account_identifier_signers?.map((e) => e.toJson()).toList(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// ConstructionHashRequest is the input to the `/construction/hash` endpoint.
class ConstructionHashRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  String signed_transaction;
  ConstructionHashRequest(this.network_identifier, this.signed_transaction);
  factory ConstructionHashRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionHashRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]), map["signed_transaction"]);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "signed_transaction": signed_transaction
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// The transaction submission request includes a signed transaction.
class ConstructionSubmitRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  // ignore: non_constant_identifier_names
  String signed_transaction;
  ConstructionSubmitRequest(this.network_identifier, this.signed_transaction);
  factory ConstructionSubmitRequest.fromMap(Map<String, dynamic> map) {
    return ConstructionSubmitRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]), map["signed_transaction"]);
  }

  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "signed_transaction": signed_transaction
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// TransactionIdentifierResponse contains the transaction_identifier of a transaction that was submitted to either `/construction/hash` or `/construction/submit`.
class TransactionIdentifierResponse {
  // ignore: non_constant_identifier_names
  TransactionIdentifier transaction_identifier;
  Map<String, dynamic>? metadata;

  TransactionIdentifierResponse(this.transaction_identifier, this.metadata);
  factory TransactionIdentifierResponse.fromMap(Map<String, dynamic> map) {
    return TransactionIdentifierResponse(
        TransactionIdentifier.fromMap(map["transaction_identifier"]), map["metadata"]);
  }

  Map<String, dynamic> toJson() => {
        "transaction_identifier": transaction_identifier.toJson(),
        "metadata": metadata
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// CallRequest is the input to the `/call` endpoint.
class CallRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;

  /// Method is some network-specific procedure call. This method could map to a network-specific RPC endpoint, a method in an SDK generated from a smart contract, or some hybrid of the two. The implementation must define all available methods in the Allow object. However, it is up to the caller to determine which parameters to provide when invoking `/call`.
  String method;

  /// Parameters is some network-specific argument for a method. It is up to the caller to determine which parameters to provide when invoking `/call`.
  Map<String, dynamic> parameters;

  CallRequest(this.network_identifier, this.method, this.parameters);
  factory CallRequest.fromMap(Map<String, dynamic> map) {
    return CallRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]), map["method"], map["parameters"]);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "method": method,
        "parameters": parameters
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// CallResponse contains the result of a `/call` invocation.
class CallResponse {
  /// Result contains the result of the `/call` invocation. This result will not be inspected or interpreted by Rosetta tooling and is left to the caller to decode.
  Map<String, dynamic> result;

  /// Idempotent indicates that if `/call` is invoked with the same CallRequest again, at any point in time, it will return the same CallResponse. Integrators may cache the CallResponse if this is set to true to avoid making unnecessary calls to the Rosetta implementation. For this reason, implementers should be very conservative about returning true here or they could cause issues for the caller.
  bool idempotent;

  CallResponse(this.result, this.idempotent);
  factory CallResponse.fromMap(Map<String, dynamic> map) {
    return CallResponse(map["result"], map["idempotent"]);
  }
  Map<String, dynamic> toJson() => {"result": result, "idempotent": idempotent}
    ..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// EventsBlocksRequest is utilized to fetch a sequence of BlockEvents indicating which blocks were added and removed from storage to reach the current state.
class EventsBlocksRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;

  /// offset is the offset into the event stream to sync events from. If this field is not populated, we return the limit events backwards from tip. If this is set to 0, we start from the beginning.
  int? offset;

  /// limit is the maximum number of events to fetch in one call. The implementation may return <= limit events.
  int? limit;
  EventsBlocksRequest(this.network_identifier, this.offset, this.limit);
  factory EventsBlocksRequest.fromMap(Map<String, dynamic> map) {
    return EventsBlocksRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]), map["offset"], map["limit"]);
  }
  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "offset": offset,
        "limit": limit
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// EventsBlocksResponse contains an ordered collection of BlockEvents and the max retrievable sequence.
class EventsBlocksResponse {
  /// max_sequence is the maximum available sequence number to fetch.
  // ignore: non_constant_identifier_names
  int max_sequence;

  /// events is an array of BlockEvents indicating the order to add and remove blocks to maintain a canonical view of blockchain state. Lightweight clients can use this event stream to update state without implementing their own block syncing logic.
  List<BlockEvent> events;

  EventsBlocksResponse(this.max_sequence, this.events);
  factory EventsBlocksResponse.fromMap(Map<String, dynamic> map) {
    return EventsBlocksResponse(
        map["max_sequence"], (map["events"] as List).map((e) => BlockEvent.fromMap(e)).toList());
  }

  Map<String, dynamic> toJson() => {
        "max_sequence": max_sequence,
        "events": events.map((e) => e.toJson()).toList()
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// SearchTransactionsRequest is used to search for transactions matching a set of provided conditions in canonical blocks.
class SearchTransactionsRequest {
  // ignore: non_constant_identifier_names
  NetworkIdentifier network_identifier;
  String? operator; // "or" | "and";
  /// max_block is the largest block index to consider when searching for transactions. If this field is not populated, the current block is considered the max_block. If you do not specify a max_block, it is possible a newly synced block will interfere with paginated transaction queries (as the offset could become invalid with newly added rows).
  // ignore: non_constant_identifier_names
  int? max_block;

  /// offset is the offset into the query result to start returning transactions. If any search conditions are changed, the query offset will change and you must restart your search iteration.
  int? offset;

  /// limit is the maximum number of transactions to return in one call. The implementation may return <= limit transactions.
  int? limit;
  // ignore: non_constant_identifier_names
  TransactionIdentifier? transaction_identifier;
  // ignore: non_constant_identifier_names
  AccountIdentifier? account_identifier;
  // ignore: non_constant_identifier_names
  CoinIdentifier? coin_identifier;
  Currency? currency;

  /// status is the network-specific operation type.
  String? status;

  /// type is the network-specific operation type.
  String? type;

  /// address is AccountIdentifier.Address. This is used to get all transactions related to an AccountIdentifier.Address, regardless of SubAccountIdentifier.
  String? address;

  /// success is a synthetic condition populated by parsing network-specific operation statuses (using the mapping provided in `/network/options`).
  bool? success;

  SearchTransactionsRequest(
      this.network_identifier,
      this.operator,
      this.max_block,
      this.offset,
      this.limit,
      this.transaction_identifier,
      this.account_identifier,
      this.coin_identifier,
      this.currency,
      this.status,
      this.type,
      this.address,
      this.success);

  factory SearchTransactionsRequest.fromMap(Map<String, dynamic> map) {
    return SearchTransactionsRequest(
        NetworkIdentifier.fromMap(map["network_identifier"]),
        map["operator"],
        map["max_block"],
        map["offset"],
        map["limit"],
        map["transaction_identifier"] != null
            ? TransactionIdentifier.fromMap(map["transaction_identifier"])
            : null,
        map["account_identifier"] != null
            ? AccountIdentifier.fromMap(map["account_identifier"])
            : null,
        map["coin_identifier"] != null ? CoinIdentifier.fromMap(map["coin_identifier"]) : null,
        map["currency"] != null ? Currency.fromMap(map["currency"]) : null,
        map["status"],
        map["type"],
        map["address"],
        map["success"]);
  }

  Map<String, dynamic> toJson() => {
        "network_identifier": network_identifier.toJson(),
        "operator": operator,
        "max_block": max_block,
        "offset": offset,
        "limit": limit,
        "transaction_identifier": transaction_identifier?.toJson(),
        "account_identifier": account_identifier?.toJson(),
        "coin_identifier": coin_identifier?.toJson(),
        "currency": currency?.toJson(),
        "status": status,
        "type": type,
        "address": address,
        "success": success
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// SearchTransactionsResponse contains an ordered collection of BlockTransactions that match the query in SearchTransactionsRequest. These BlockTransactions are sorted from most recent block to oldest block.
class SearchTransactionsResponse {
  /// next_offset is the next offset to use when paginating through transaction results. If this field is not populated, there are no more transactions to query.
  // ignore: non_constant_identifier_names
  int? next_offset;

  /// transactions is an array of BlockTransactions sorted by most recent BlockIdentifier (meaning that transactions in recent blocks appear first). If there are many transactions for a particular search, transactions may not contain all matching transactions. It is up to the caller to paginate these transactions using the max_block field.
  List<BlockTransaction> transactions;

  SearchTransactionsResponse(this.transactions, this.next_offset);
  factory SearchTransactionsResponse.fromMap(Map<String, dynamic> map) {
    return SearchTransactionsResponse(
        (map["transactions"] as List).map((e) => BlockTransaction.fromMap(e)).toList(),
        map["next_offset"]);
  }

  Map<String, dynamic> toJson() => {
        "transactions": transactions.map((e) => e.toJson()),
        "next_offset": next_offset
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

/// Instead of utilizing HTTP status codes to describe node errors (which often do not have a good analog), rich errors are returned using this object. Both the code and message fields can be individually used to correctly identify an error. Implementations MUST use unique values for both fields.
class RosettaError {
  /// Code is a network-specific error code. If desired, this code can be equivalent to an HTTP status code.
  int code;

  /// Message is a network-specific error message. The message MUST NOT change for a given code. In particular, this means that any contextual information should be included in the details field.
  String message;

  /// Description allows the implementer to optionally provide additional information about an error. In many cases, the content of this field will be a copy-and-paste from existing developer documentation. Description can ONLY be populated with generic information about a particular type of error. It MUST NOT be populated with information about a particular instantiation of an error (use `details` for this). Whereas the content of Error.Message should stay stable across releases, the content of Error.Description will likely change across releases (as implementers improve error documentation). For this reason, the content in this field is not part of any type assertion (unlike Error.Message).
  String? description;

  /// An error is retriable if the same request may succeed if submitted again.
  bool retriable;

  /// Often times it is useful to return context specific to the request that caused the error (i.e. a sample of the stack trace or impacted account) in addition to the standard error message.
  Map<String, dynamic>? details;

  RosettaError(this.code, this.message, this.retriable, this.description, this.details);
  factory RosettaError.fromMap(Map<String, dynamic> map) {
    return RosettaError(
        map["code"], map["message"], map["retriable"], map["description"], map["details"]);
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "retriable": retriable,
        "description": description,
        "details": details
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}
