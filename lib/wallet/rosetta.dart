import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:agent_dart/agent/agent/http/fetch.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/protobuf/ic_ledger/pb/v1/types.pb.dart';

import 'types.dart' as rosetta;

// Set useNativeBigInt to true and use BigInt once BigInt is widely supported.
// final JSONbig = jsonBigint({ strict: true });

/// Types of Rosetta API errors.

enum TransactionErrorType { notFound, timeout, networkError }

/// Describes the cause of a Rosetta API error.
class TransactionError extends TypeError {
  /// Create a [TransactionError].
  TransactionError(this.message, int status, {this.detail}) {
    switch (status) {
      case 408:
        errorType = TransactionErrorType.timeout;
        break;
      case 500:
        errorType = TransactionErrorType.notFound;
        break;
      default:
        errorType = TransactionErrorType.networkError;
        break;
    }
  }

  final Object message;
  final Object? detail;
  late final TransactionErrorType errorType;

  @override
  String toString() {
    return 'TransactionError('
        'message: ${Error.safeToString(message)}, '
        'status: ${errorType.name}, '
        'detail: $detail'
        ')';
  }
}

/// Contains information about a transaction.
class RosettaTransaction extends rosetta.Transaction {
  /// Create a Transaction.
  /// @param {Any} rosettaTransaction The Rosetta Transaction object of the transaction.
  /// @param {Number} blockIndex The index of the block containing the transaction.
  /// milliseconds since the Unix Epoch.
  RosettaTransaction(
    rosetta.Transaction rosettaTransaction,
    this.blockIndex,
  ) : super(
          rosettaTransaction.transactionIdentifier,
          rosettaTransaction.operations,
          rosettaTransaction.metadata,
        ) {
    hash = rosettaTransaction.transactionIdentifier.hash;
    final timestampMs =
        BigInt.from(rosettaTransaction.metadata?['timestamp'] as int) ~/
            BigInt.from(1000000);
    timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs.toInt());
    final operations = rosettaTransaction.operations;
    if (operations.isNotEmpty) {
      final firstOperation = operations[0];
      type = firstOperation.type;
      status = firstOperation.status;
      account1Address = firstOperation.account?.address;
      BigInt amountValue = firstOperation.amount?.valueInBigInt ?? BigInt.zero;
      // Negate amount for TRANSACTION and BURN,
      // so that they appear in the UI as positive values.
      if ((type == 'TRANSACTION' || type == 'BURN') &&
          amountValue != BigInt.zero) {
        amountValue = -amountValue;
      }
      amount = amountValue;
    } else {
      type = null;
      status = null;
      account1Address = null;
      amount = BigInt.zero;
    }
    if (operations.length >= 2 && operations[1].type == 'TRANSACTION') {
      account2Address = operations[1].account?.address;
    } else {
      account2Address = null;
    }
    if (operations.length >= 3 && operations[2].type == 'FEE') {
      fee = (operations[2].amount?.valueInBigInt ?? BigInt.zero) * -BigInt.one;
      memo = null;
    } else {
      fee = BigInt.zero;
      memo = rosettaTransaction.metadata?['memo'] != null
          ? BigInt.parse(rosettaTransaction.metadata?['memo'] as String)
          : null;
    }
  }

  final int blockIndex;
  late final String hash;
  late final DateTime? timestamp;
  late final String? type;
  late final String? status;
  late final String? account1Address;
  late final String? account2Address;
  late final BigInt amount;
  late final BigInt fee;
  late final BigInt? memo;
}

/// Manages Rosetta API calls.
class RosettaApi {
  /// Create a RosettaApi.
  RosettaApi({this.host = 'https://rosetta-api.internetcomputer.org'});

  final String host;

  rosetta.NetworkIdentifier? networkIdentifier;
  BigInt? suggestedFee;
  rosetta.Currency? currency;

  Future<void> init() async {
    await getNetworkIdentifier();
    await getSuggestedFee();
  }

  Future<void> getNetworkIdentifier() async {
    final networkList = await networksList();
    networkIdentifier = networkList.networkIdentifiers.singleWhere(
      (rosetta.NetworkIdentifier id) => id.blockchain == 'Internet Computer',
      orElse: () => throw StateError('No identifier found.'),
    );
  }

  /// Return the ICP account balance of the specified account.
  /// @param {string} accountAddress The account address to get the ICP balance of.
  /// @returns {Promise<BigNumber|TransactionError>} The ICP account balance of the specified account, or
  /// a TransactionError for error.
  Future<BigInt> getAccountBalance(accountAddress) async {
    final response = await accountBalanceByAddress(accountAddress);
    return response.balances[0].valueInBigInt;
  }

  /// Return the latest block index.
  /// @returns {Promise<number>} The latest block index, or a TransactionError for error.
  Future<int> getLastBlockIndex() async {
    final response = await networkStatus();
    return response.currentBlockIdentifier.index;
  }

  Future<void> getSuggestedFee() async {
    if (networkIdentifier != null) {
      final req = rosetta.ConstructionMetadataRequest.fromJson(
        {'network_identifier': networkIdentifier!.toJson()},
      );
      final meta = await metadata(req);
      final fee = meta.suggestedFee?.singleWhere(
        (e) => e.currency.symbol == 'ICP',
        orElse: () => throw StateError('No fee found.'),
      );
      if (fee != null) {
        suggestedFee = fee.valueInBigInt;
        currency = fee.currency;
      }
    }
  }

  /// Return the Transaction object with the specified hash.
  /// @param {string} transactionHash The hash of the transaction to return.
  /// @returns {Transaction|null} The Transaction object with the specified hash, or a TransactionError
  /// for error.
  Future<RosettaTransaction> getTransaction(String transactionHash) async {
    final responseTransactions = await transactionsByHash(transactionHash);
    if (responseTransactions.transactions.isEmpty) {
      throw TransactionError('Transaction not found.', 500);
    }
    return RosettaTransaction(
      responseTransactions.transactions[0].transaction,
      responseTransactions.transactions[0].blockIdentifier.index,
    );
  }

  /// Return an array of Transaction objects based on the specified parameters, or an empty array if
  /// none found.
  /// @param limit {number} The maximum number of transactions to return in one call.
  /// @param maxBlockIndex {number} The block index to start at. If not specified, start at current
  /// block.
  /// @param offset {number} The offset from maxBlockIndex to start returning transactions.
  /// @returns {Promise<Array<Transaction>|null>} An array of Transaction objects, or a TransactionError
  /// for error.
  Future<List<RosettaTransaction>> getTransactions(
    int limit,
    int maxBlockIndex,
    int offset,
  ) async {
    // This function can be simplified once search/transactions supports using
    // the properties [maxBlockIndex], [offset], and [limit].
    int blockIndex;
    if (maxBlockIndex > 0) {
      blockIndex = maxBlockIndex;
    } else {
      // Get the latest block index.
      final response = await networkStatus();
      blockIndex = response.currentBlockIdentifier.index;
    }
    if (offset > 0) {
      blockIndex = max(blockIndex - offset, -1);
    }

    final transactionCount = min(limit, blockIndex + 1);
    final transactions = <RosettaTransaction>[];
    for (int i = 0; i < transactionCount; i++) {
      transactions.add(await getTransactionByBlock(blockIndex - i));
    }
    return transactions;
  }

  /// Return an array of Transaction objects based on the specified parameters, or an empty array if
  /// none found.
  /// @param {string} accountAddress The account address to get the transactions of.
  /// @returns {Promise<Array<Transaction>|null>} An array of Transaction objects, or a TransactionError
  /// for error.
  Future<List<RosettaTransaction>> getTransactionsByAccount(
    String accountAddress,
  ) async {
    final response = await transactionsByAccount(accountAddress);
    final transactions = response.transactions
        .map(
          (blockTransaction) => RosettaTransaction(
            blockTransaction.transaction,
            blockTransaction.blockIdentifier.index,
          ),
        )
        .toList();
    return transactions.reversed.toList();
  }

  // /// Return the Transaction corresponding to the specified block index (i.e., block height).
  // /// @param {number} blockIndex The index of the block to return the Transaction for.
  // /// @returns {Promise<Transaction>} The Transaction corresponding to the specified block index.
  // /// @private
  Future<RosettaTransaction> getTransactionByBlock(int blockIndex) async {
    final response = await blockByIndex(blockIndex);
    final block = response.block;
    if (block != null) {
      return RosettaTransaction(block.transactions[0], blockIndex);
    }
    throw TransactionError('Block is not found $blockIndex', 500);
  }

  /// Perform the specified http request and return the response data.
  /// @param {string} url The server URL that will be used for the request.
  /// @param {object} data The data to be sent as the request body.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<Map<String, dynamic>> request(String url, dynamic data) async {
    final res = await defaultFetch(
      endpoint: url,
      defaultHost: host,
      baseHeaders: {'Content-Type': 'application/json;charset=utf-8'},
      cbor: false,
      body: jsonEncode(data),
    );
    final response = FetchResponse.fromJson(res);
    if (response.ok) {
      return jsonDecode(response.body);
    } else {
      throw TransactionError(
        response.statusText,
        response.statusCode,
        detail: response.body.isNotEmpty
            ? jsonDecode(response.body)
            : response.body,
      );
    }
  }

  /// Return the /network/list response, containing a list of NetworkIdentifiers that the Rosetta
  /// server supports.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.NetworkListResponse> networksList() async {
    final result = await request('/network/list', {'metadata': {}});
    return rosetta.NetworkListResponse.fromJson(result);
  }

  Future<rosetta.ConstructionMetadataResponse> metadata(
    rosetta.ConstructionMetadataRequest req,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/construction/metadata', req.toJson());
    return rosetta.ConstructionMetadataResponse.fromJson(result);
  }

  Future<rosetta.ConstructionPayloadsResponse> payloads(
    rosetta.ConstructionPayloadsRequest req,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/construction/payloads', req.toJson());
    return rosetta.ConstructionPayloadsResponse.fromJson(result);
  }

  /// Return /network/status response, describing the current status of the network.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.NetworkStatusResponse> networkStatus() async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request(
      '/network/status',
      rosetta.NetworkRequest.fromJson(
        {'network_identifier': networkIdentifier},
      ).toJson(),
    );
    return rosetta.NetworkStatusResponse.fromJson(result);
  }

  /// Return the /account/balance response for the specified account.
  /// @param {string} accountAddress The account address to get the balance of.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.AccountBalanceResponse> accountBalanceByAddress(
    String accountAddress,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/account/balance', {
      'network_identifier': networkIdentifier,
      'account_identifier': {'address': accountAddress},
    });
    return rosetta.AccountBalanceResponse.fromJson(result);
  }

  /// Return the /block response for the block corresponding to the specified block index (i.e.,
  /// block height).
  /// @param {number} blockIndex The index of the block to return.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.BlockResponse> blockByIndex(int blockIndex) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/block', {
      'network_identifier': networkIdentifier,
      'block_identifier': {'index': blockIndex},
    });
    return rosetta.BlockResponse.fromJson(result);
  }

  /// Return the /search/transactions response for transactions containing an operation that affects
  /// the specified account.
  /// @param {string} accountAddress The account address to get the transactions of.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.SearchTransactionsResponse> transactionsByAccount(
    String accountAddress,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/search/transactions', {
      'network_identifier': networkIdentifier,
      'account_identifier': {'address': accountAddress},
    });
    return rosetta.SearchTransactionsResponse.fromJson(result);
  }

  /// Return the /search/transactions response for transactions (only one) with the specified hash.
  /// @param {string} transactionHash The hash of the transaction to return.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.SearchTransactionsResponse> transactionsByHash(
    String transactionHash,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/search/transactions', {
      'network_identifier': networkIdentifier,
      'transaction_identifier': {'hash': transactionHash},
    });
    return rosetta.SearchTransactionsResponse.fromJson(result);
  }

  /// Return the /search/transactions response for transactions (only one) with the specified hash.
  /// @param {string} transactionHash The hash of the transaction to return.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.SearchTransactionsResponse> transactions(
    rosetta.SearchTransactionsRequest req,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    final result = await request('/search/transactions', req.toJson());
    return rosetta.SearchTransactionsResponse.fromJson(result);
  }

  Future<rosetta.TransactionIdentifierResponse> submit(
    rosetta.ConstructionSubmitRequest req,
  ) async {
    final result = await request('/construction/submit', req.toJson());
    return rosetta.TransactionIdentifierResponse.fromJson(result);
  }

  Future<rosetta.ConstructionPayloadsResponse> transferPreCombine(
    Uint8List srcPub,
    Uint8List destAddr,
    BigInt count,
    BigInt? maxFee,
    Map<String, dynamic>? opt,
  ) async {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');

    final netId = networkIdentifier;
    final oper1 = rosetta.Operation.fromJson(
      {
        'operation_identifier': const {'index': 0},
        'type': 'TRANSACTION',
        'account': {
          'address': getAccountIdFromEd25519PublicKey(srcPub).toHex(),
        },
        'amount': {
          'value': '-${count.toRadixString(10)}',
          'currency': currency?.toJson(),
        },
      },
    ).toJson();
    final oper2 = rosetta.Operation.fromJson(
      {
        'operation_identifier': const {'index': 1},
        'type': 'TRANSACTION',
        'account': {'address': crc32Add(destAddr).toHex()},
        'amount': {
          'value': count.toRadixString(10),
          'currency': currency?.toJson(),
        },
      },
    ).toJson();
    final oper3 = rosetta.Operation.fromJson(
      {
        'operation_identifier': const {'index': 2},
        'type': 'FEE',
        'account': {
          'address': getAccountIdFromEd25519PublicKey(srcPub).toHex(),
        },
        'amount': {
          'value':
              '-${maxFee?.toRadixString(10) ?? suggestedFee?.toRadixString(10)}',
          'currency': currency?.toJson(),
        },
      },
    ).toJson();
    final metaResult = await metadata(
      rosetta.ConstructionMetadataRequest.fromJson(
        {'network_identifier': netId?.toJson()},
      ),
    );
    final meta = {...metaResult.metadata, ...?opt};

    final request = rosetta.ConstructionPayloadsRequest.fromJson({
      'network_identifier': netId?.toJson(),
      'operations': [oper1, oper2, oper3],
      'metadata': meta,
      'public_keys': [
        {'hex_bytes': srcPub.toHex(), 'curve_type': 'edwards25519'},
      ],
    });
    return payloads(request);
  }

  Future<rosetta.TransactionIdentifierResponse> transferPostCombine(
    CombineSignedTransactionResult combineRes,
  ) {
    assert(networkIdentifier != null, 'Cannot get networkIdentifier.');
    return submit(
      rosetta.ConstructionSubmitRequest.fromJson({
        'network_identifier': networkIdentifier?.toJson(),
        'signed_transaction': combineRes.signedTransaction,
      }),
    );
  }
}

Future<CombineSignedTransactionResult> transferCombine(
  Ed25519KeyIdentity identity,
  rosetta.SignablePayload payloadsRes,
) async {
  final signatures = [];
  for (final p in payloadsRes.payloads) {
    final hexBytes = blobToHex(await identity.sign(blobFromHex(p.hexBytes)));
    final signedPayload = {
      'signing_payload': p.toJson(),
      'public_key': {
        'hex_bytes': identity.getPublicKey().rawKey.toHex(),
        'curve_type': 'edwards25519',
      },
      'signature_type': 'ed25519',
      'hex_bytes': hexBytes,
    };
    signatures.add(signedPayload);
  }
  return combine(
    rosetta.ConstructionCombineRequestPart.fromJson({
      'signatures': signatures,
      'unsigned_transaction': payloadsRes.unsignedTransaction,
    }),
  );
}

Future<CombineSignedTransactionResult> ecTransferCombine(
  Secp256k1KeyIdentity identity,
  rosetta.SignablePayload payloadsRes,
) async {
  final signatures = [];
  for (final p in payloadsRes.payloads) {
    final hexBytes = blobToHex(await identity.sign(blobFromHex(p.hexBytes)));
    final signedPayload = {
      'signing_payload': p.toJson(),
      'public_key': {
        'hex_bytes': identity.getPublicKey().rawKey.toHex(),
        'curve_type': 'secp256k1',
      },
      'signature_type': 'ecdsa',
      'hex_bytes': hexBytes,
    };
    signatures.add(signedPayload);
  }
  return combine(
    rosetta.ConstructionCombineRequestPart.fromJson({
      'signatures': signatures,
      'unsigned_transaction': payloadsRes.unsignedTransaction,
    }),
  );
}

// https://github.com/dfinity/rosetta-client/commit/bebac5737f3c1ad7ed607c5db08ded4cc4ad7f97#diff-8fd36260d6da44e31d76877ca9f8622cff1258c70efa8c7b81c18daa419763a0
CombineSignedTransactionResult combine(
  rosetta.ConstructionCombineRequestPart req,
) {
  final signaturesBySigData = <String, rosetta.Signature>{};
  for (final sig in req.signatures) {
    signaturesBySigData.putIfAbsent(sig.signingPayload.hexBytes, () => sig);
  }
  final unsignedTransaction = cborDecode<Map>(req.unsignedTransaction.toU8a());

  assert(
    req.signatures.length ==
        unsignedTransaction['ingress_expiries']?.length * 2,
  );
  assert((unsignedTransaction['updates'] as List).length == 1);

  final envelopes = [];
  for (final updateItem in unsignedTransaction['updates']) {
    final reqType = updateItem[0];
    final update = updateItem[1];
    final requestEnvelopes = [];
    for (final ingressExpiry in unsignedTransaction['ingress_expiries']) {
      update['ingress_expiry'] = BigInt.from(ingressExpiry).toInt();

      final readState = makeReadStateFromUpdate(update);
      final transactionSignature = signaturesBySigData[
          blobToHex(makeSignatureData(httpCanisterUpdateId(update)))];
      final readStateSignature = signaturesBySigData[blobToHex(
        makeSignatureData(
          httpReadStateRepresentationIndependentHash(readState),
        ),
      )];

      final envelope = {
        'content': {'request_type': 'call', ...update},
        'sender_pubkey': Ed25519PublicKey.fromRaw(
          blobFromHex(transactionSignature!.publicKey.hexBytes),
        ).toDer(),
        'sender_sig': blobFromHex(transactionSignature.hexBytes),
        'sender_delegation': null,
      };
      final readStateEnvelope = {
        'content': {'request_type': 'read_state', ...readState},
        'sender_pubkey': Ed25519PublicKey.fromRaw(
          blobFromHex(readStateSignature!.publicKey.hexBytes),
        ).toDer(),
        'sender_sig': blobFromHex(readStateSignature.hexBytes),
        'sender_delegation': null,
      };
      requestEnvelopes.add(
        {'update': envelope, 'read_state': readStateEnvelope},
      );
    }
    envelopes.add([reqType, requestEnvelopes]);
  }

  final signedTransaction = blobToHex(
    cborEncode(envelopes, withSerializer: initCborSerializerNoHead()),
  );
  return CombineSignedTransactionResult(signedTransaction);
}

class CombineSignedTransactionResult {
  const CombineSignedTransactionResult(this.signedTransaction);

  final String signedTransaction;
}

const _tweetNaclSignedPubLength = 32;

Map<String, dynamic> transactionDecoder(String txnHash) {
  final envelopes = cborDecode(blobFromHex(txnHash));
  assert(envelopes.length == 1);

  final envelope = envelopes[0][0];
  assert(envelope['content']['request_type'] == 'call');
  assert(envelope['content']['method_name'] == 'send_pb');
  final content = envelope['content'] as Map;
  final senderPubkey = envelope['sender_pubkey'];
  final sendArgs = SendRequest.fromBuffer(content['arg']);
  final senderAddress = Principal(Uint8List.fromList(content['sender']));
  final hash = SHA224()
    ..update(('\x0Aaccount-id').plainToU8a())
    ..update(senderAddress.toUint8List())
    ..update(Uint8List(32));
  return {
    'from': hash.digest(),
    'to': Uint8List.fromList(sendArgs.to.hash.sublist(4)),
    'amount': BigInt.parse(sendArgs.payment.receiverGets.e8s.toRadixString(10)),
    'fee': BigInt.parse(sendArgs.maxFee.e8s.toRadixString(10)),
    'sender_pubkey': Uint8List.fromList(senderPubkey).sublist(
      Uint8List.fromList(senderPubkey).byteLength - _tweetNaclSignedPubLength,
    ),
  };
}
