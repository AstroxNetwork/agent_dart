import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:agent_dart/agent/agent/http/fetch.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:agent_dart/protobuf/ic_ledger/pb/v1/types.pb.dart';

import 'types.dart' as rosetta;

// Set useNativeBigInt to true and use BigInt once BigInt is widely supported.
// final JSONbig = jsonBigint({ strict: true });

/// Types of Rosetta API errors.

enum TransactionErrorType {
  // ignore: constant_identifier_names
  NotFound,
  // ignore: constant_identifier_names
  Timeout,
  // ignore: constant_identifier_names
  NetworkError
}

/// Describes the cause of a Rosetta API error.
class TransactionError extends TypeError {
  /// Create a TransactionError.
  /// @param {String} message An error message describing the error.
  /// @param {Number} status number The HTTP response status.
  late TransactionErrorType errorType;

  TransactionError(dynamic message, int status, {Map? detail}) : super() {
    switch (status) {
      case 408:
        errorType = TransactionErrorType.Timeout;
        break;
      case 500:
        errorType = TransactionErrorType.NotFound;
        break;
      default:
        errorType = TransactionErrorType.NetworkError;
        break;
    }
    throw {
      "message": Error.safeToString(message),
      "status": errorType,
      "detail": detail
    };
  }
}

/// Contains information about a transaction.
class RosettaTransaction extends rosetta.Transaction {
  /// Create a Transaction.
  /// @param {Any} rosettaTransaction The Rosetta Transaction object of the transaction.
  /// @param {Number} blockIndex The index of the block containing the transaction.
  /// milliseconds since the Unix Epoch.
  int blockIndex;
  late String hash;
  late String type;
  late String? status;
  late String? account1Address;
  late String? account2Address;
  late BigInt? amount;
  late BigInt? fee;
  late BigInt? memo;
  late DateTime? timestamp;

  RosettaTransaction(rosetta.Transaction rosettaTransaction, this.blockIndex)
      : super(rosettaTransaction.transaction_identifier,
            rosettaTransaction.operations, rosettaTransaction.metadata) {
    hash = rosettaTransaction.transaction_identifier.hash;
    var timestampMs =
        BigInt.from(rosettaTransaction.metadata?["timestamp"] as int) ~/
            BigInt.from(1000000);
    timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs.toInt());
    var operations = rosettaTransaction.operations;
    if (operations.isNotEmpty) {
      type = operations[0].type;
      status = operations[0].status;
      account1Address = operations[0].account?.address;

      amount = operations[0].amount != null
          ? BigInt.parse(operations[0].amount!.value)
          : null;
      // Negate amount for TRANSACTION and BURN, so that they appear in the UI as positive values.
      if ((operations[0].type == 'TRANSACTION' ||
              operations[0].type == 'BURN') &&
          amount! != BigInt.zero) {
        amount = -amount!;
      }
    } else {
      type = '';
      status = '';
      account1Address = '';
      amount = BigInt.zero;
    }
    if (operations.length >= 2 && operations[1].type == 'TRANSACTION') {
      account2Address = operations[1].account?.address;
    } else {
      account2Address = '';
    }

    if (operations.length >= 3 && operations[2].type == 'FEE') {
      fee = operations[2].amount?.value != null
          ? -BigInt.parse(operations[2].amount!.value)
          : null;
    } else {
      fee = BigInt.zero;
      memo = rosettaTransaction.metadata?["memo"] != null
          ? BigInt.parse(rosettaTransaction.metadata?["memo"] as String)
          : null;
    }
  }
}

/// Manages Rosetta API calls.
class RosettaApi {
  /// Create a RosettaApi.
  rosetta.NetworkIdentifier? networkIdentifier;
  BigInt? suggestedFee;
  rosetta.Currency? currency;
  String host;

  RosettaApi({this.host = "https://rosetta-api.internetcomputer.org"});

  Future<void> init() async {
    await getNetworkIdentifier();
    await getSuggestedFee();
  }

  Future<void> getNetworkIdentifier() async {
    var networkList = await networksList();
    networkIdentifier = (networkList.network_identifiers).singleWhere(
        (rosetta.NetworkIdentifier id) => id.blockchain == 'Internet Computer',
        orElse: () => throw 'No Identifier found');
  }

  /// Return the ICP account balance of the specified account.
  /// @param {string} accountAddress The account address to get the ICP balance of.
  /// @returns {Promise<BigNumber|TransactionError>} The ICP account balance of the specified account, or
  /// a TransactionError for error.
  Future<BigInt> getAccountBalance(accountAddress) async {
    try {
      final response = await accountBalanceByAddress(accountAddress);
      return BigInt.parse(response.balances[0].value);
    } catch (error) {
      rethrow;
    }
  }

  /// Return the latest block index.
  /// @returns {Promise<number>} The latest block index, or a TransactionError for error.
  Future<int> getLastBlockIndex() async {
    try {
      final response = await networkStatus();
      return response.current_block_identifier.index;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getSuggestedFee() async {
    if (networkIdentifier != null) {
      var req = rosetta.ConstructionMetadataRequest.fromMap(
          {"network_identifier": networkIdentifier!.toJson()});
      var meta = await metadata(req);
      final fee = meta.suggested_fee?.singleWhere(
          (element) => element.currency.symbol == "ICP",
          orElse: () => throw "Cannot find ICP fee");

      if (fee != null) {
        suggestedFee = BigInt.parse(fee.value);
        currency = fee.currency;
      }
    }
  }

  /// Return the Transaction object with the specified hash.
  /// @param {string} transactionHash The hash of the transaction to return.
  /// @returns {Transaction|null} The Transaction object with the specified hash, or a TransactionError
  /// for error.
  Future<RosettaTransaction> getTransaction(String transactionHash) async {
    try {
      final responseTransactions = await transactionsByHash(transactionHash);
      if (responseTransactions.transactions.isEmpty) {
        throw TransactionError('Transaction not found.', 500);
      }

      return RosettaTransaction(
          responseTransactions.transactions[0].transaction,
          responseTransactions.transactions[0].block_identifier.index);
    } catch (error) {
      //console.log(error);
      rethrow;
    }
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
      int limit, int maxBlockIndex, int offset) async {
    try {
      // This function can be simplified once /search/transactions supports using the properties
      // max_block, offset, and limit.
      int blockIndex;
      if (maxBlockIndex > 0) {
        blockIndex = maxBlockIndex;
      } else {
        // Get the latest block index.
        final response = await networkStatus();
        blockIndex = response.current_block_identifier.index;
      }
      if (offset > 0) {
        blockIndex = max(blockIndex - offset, -1);
      }

      final transactionCount = min(limit, blockIndex + 1);
      final transactions = <RosettaTransaction>[];
      for (var i = 0; i < transactionCount; i++) {
        transactions.add(await getTransactionByBlock(blockIndex - i));
      }
      return transactions;
    } catch (error) {
      //console.log(error);
      rethrow;
    }
  }

  /// Return an array of Transaction objects based on the specified parameters, or an empty array if
  /// none found.
  /// @param {string} accountAddress The account address to get the transactions of.
  /// @returns {Promise<Array<Transaction>|null>} An array of Transaction objects, or a TransactionError
  /// for error.
  Future<List<RosettaTransaction>> getTransactionsByAccount(
      accountAddress) async {
    try {
      final response = await transactionsByAccount(accountAddress);
      final transactions = response.transactions
          .map((rosetta.BlockTransaction blockTransaction) {
        return RosettaTransaction(blockTransaction.transaction,
            blockTransaction.block_identifier.index);
      }).toList();

      return transactions.reversed.toList();
    } catch (error) {
      //console.log(error);
      rethrow;
      // return TransactionError(
      //     error.message, axios.isAxiosError(error) ? error?.response?.status : undefined);
    }
  }

  // /// Return the Transaction corresponding to the specified block index (i.e., block height).
  // /// @param {number} blockIndex The index of the block to return the Transaction for.
  // /// @returns {Promise<Transaction>} The Transaction corresponding to the specified block index.
  // /// @private
  Future<RosettaTransaction> getTransactionByBlock(int blockIndex) async {
    var response = await blockByIndex(blockIndex);
    var block = response.block;
    if (block != null) {
      return RosettaTransaction(block.transactions[0], blockIndex);
    } else {
      throw TransactionError("Block is not found $blockIndex", 500);
    }
  }

  /// Perform the specified http request and return the response data.
  /// @param {string} url The server URL that will be used for the request.
  /// @param {object} data The data to be sent as the request body.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<Map<String, dynamic>> request(String url, dynamic data) async {
    var res = await defaultFetch(
      endpoint: url,
      method: FetchMethod.post,
      defaultHost: host,
      baseHeaders: {'Content-Type': 'application/json;charset=utf-8'},
      cbor: false,
      body: jsonEncode(data),
    );
    var response = FetchResponse.fromMap(res);
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
    var result = await request('/network/list', {"metadata": {}});
    print(result);
    return rosetta.NetworkListResponse.fromMap(result);
  }

  Future<rosetta.ConstructionMetadataResponse> metadata(
      rosetta.ConstructionMetadataRequest req) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request("/construction/metadata", req.toJson());
    return rosetta.ConstructionMetadataResponse.fromMap(result);
  }

  Future<rosetta.ConstructionPayloadsResponse> payloads(
      rosetta.ConstructionPayloadsRequest req) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request("/construction/payloads", req.toJson());
    return rosetta.ConstructionPayloadsResponse.fromMap(result);
  }

  /// Return /network/status response, describing the current status of the network.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.NetworkStatusResponse> networkStatus() async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request(
        '/network/status',
        rosetta.NetworkRequest.fromMap(
            {"network_identifier": networkIdentifier}).toJson());
    return rosetta.NetworkStatusResponse.fromMap(result);
  }

  /// Return the /account/balance response for the specified account.
  /// @param {string} accountAddress The account address to get the balance of.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.AccountBalanceResponse> accountBalanceByAddress(
      String accountAddress) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request('/account/balance', {
      "network_identifier": networkIdentifier,
      "account_identifier": {"address": accountAddress}
    });
    return rosetta.AccountBalanceResponse.fromMap(result);
  }

  /// Return the /block response for the block corresponding to the specified block index (i.e.,
  /// block height).
  /// @param {number} blockIndex The index of the block to return.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.BlockResponse> blockByIndex(int blockIndex) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request('/block', {
      "network_identifier": networkIdentifier,
      "block_identifier": {"index": blockIndex}
    });
    return rosetta.BlockResponse.fromMap(result);
  }

  /// Return the /search/transactions response for transactions containing an operation that affects
  /// the specified account.
  /// @param {string} accountAddress The account address to get the transactions of.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.SearchTransactionsResponse> transactionsByAccount(
      String accountAddress) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request('/search/transactions', {
      "network_identifier": networkIdentifier,
      "account_identifier": {"address": accountAddress}
    });
    return rosetta.SearchTransactionsResponse.fromMap(result);
  }

  /// Return the /search/transactions response for transactions (only one) with the specified hash.
  /// @param {string} transactionHash The hash of the transaction to return.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.SearchTransactionsResponse> transactionsByHash(
      String transactionHash) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request('/search/transactions', {
      "network_identifier": networkIdentifier,
      "transaction_identifier": {"hash": transactionHash}
    });
    return rosetta.SearchTransactionsResponse.fromMap(result);
  }

  /// Return the /search/transactions response for transactions (only one) with the specified hash.
  /// @param {string} transactionHash The hash of the transaction to return.
  /// @returns {Promise<any>} The response body that was provided by the server.
  /// @private
  Future<rosetta.SearchTransactionsResponse> transactions(
      rosetta.SearchTransactionsRequest req) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");
    var result = await request('/search/transactions', req.toJson());
    return rosetta.SearchTransactionsResponse.fromMap(result);
  }

  Future<rosetta.TransactionIdentifierResponse> submit(
      rosetta.ConstructionSubmitRequest req) async {
    var result = await request("/construction/submit", req.toJson());
    return rosetta.TransactionIdentifierResponse.fromMap(result);
  }

  Future<rosetta.ConstructionPayloadsResponse> transferPreCombine(
      Uint8List srcPub,
      Uint8List destAddr,
      BigInt count,
      BigInt? maxFee,
      Map<String, dynamic>? opt) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");

    var netId = networkIdentifier;

    var oper1 = rosetta.Operation.fromMap(
      {
        "operation_identifier": {"index": 0},
        "type": "TRANSACTION",
        "account": {
          "address": getAccountIdFromEd25519PublicKey(srcPub).toHex()
        },
        "amount": {
          "value": "-${count.toRadixString(10)}",
          "currency": currency?.toJson(),
        },
      },
    ).toJson();
    var oper2 = rosetta.Operation.fromMap(
      {
        "operation_identifier": {"index": 1},
        "type": "TRANSACTION",
        "account": {
          "address": crc32Add(destAddr).toHex(),
        },
        "amount": {
          "value": count.toRadixString(10),
          "currency": currency?.toJson(),
        },
      },
    ).toJson();
    var oper3 = rosetta.Operation.fromMap(
      {
        "operation_identifier": {"index": 2},
        "type": "FEE",
        "account": {
          "address": getAccountIdFromEd25519PublicKey(srcPub).toHex()
        },
        "amount": {
          "value":
              "-${maxFee?.toRadixString(10) ?? suggestedFee?.toRadixString(10)}",
          "currency": currency?.toJson(),
        },
      },
    ).toJson();
    var metaResult = await metadata(rosetta.ConstructionMetadataRequest.fromMap(
        {"network_identifier": netId?.toJson()}));
    var meta = {...metaResult.metadata, ...?opt};

    var _payloads = rosetta.ConstructionPayloadsRequest.fromMap({
      "network_identifier": netId?.toJson(),
      "operations": [oper1, oper2, oper3],
      "metadata": meta,
      "public_keys": [
        {
          "hex_bytes": srcPub.toHex(),
          "curve_type": "edwards25519",
        },
      ],
    });

    // print(jsonEncode(_payloads.toJson()));

    return await payloads(_payloads);
  }

  // ignore: non_constant_identifier_names
  Future<rosetta.TransactionIdentifierResponse> transfer_post_combine(
      CombineSignedTransactionResult combineRes) async {
    assert(networkIdentifier != null, "Cannot get networkIdentifier");

    return submit(rosetta.ConstructionSubmitRequest.fromMap({
      "network_identifier": networkIdentifier?.toJson(),
      "signed_transaction": combineRes.signedTransaction,
    }));
  }
}

Future<CombineSignedTransactionResult> transferCombine(
    Ed25519KeyIdentity identity, rosetta.SignablePayload payloadsRes) async {
  var signatures = [];
  for (var p in payloadsRes.payloads) {
    var hexBytes = blobToHex(await identity.sign(blobFromHex(p.hex_bytes)));

    var signedPayload = {
      "signing_payload": p.toJson(),
      "public_key": {
        "hex_bytes": identity.getPublicKey().rawKey.toHex(),
        "curve_type": "edwards25519",
      },
      "signature_type": "ed25519",
      "hex_bytes": hexBytes,
    };
    signatures.add(signedPayload);
  }
  return combine(rosetta.ConstructionCombineRequestPart.fromMap({
    "signatures": signatures,
    "unsigned_transaction": payloadsRes.unsigned_transaction,
  }));
}

Future<CombineSignedTransactionResult> ecTransferCombine(
    Secp256k1KeyIdentity identity, rosetta.SignablePayload payloadsRes) async {
  var signatures = [];
  for (var p in payloadsRes.payloads) {
    var hexBytes = blobToHex(await identity.sign(blobFromHex(p.hex_bytes)));

    var signedPayload = {
      "signing_payload": p.toJson(),
      "public_key": {
        "hex_bytes": identity.getPublicKey().rawKey.toHex(),
        "curve_type": "secp256k1",
      },
      "signature_type": "ecdsa",
      "hex_bytes": hexBytes,
    };
    signatures.add(signedPayload);
  }
  return combine(rosetta.ConstructionCombineRequestPart.fromMap({
    "signatures": signatures,
    "unsigned_transaction": payloadsRes.unsigned_transaction,
  }));
}

// to be change after latest docker release:
// see:
// https://github.com/dfinity/rosetta-client/commit/bebac5737f3c1ad7ed607c5db08ded4cc4ad7f97#diff-8fd36260d6da44e31d76877ca9f8622cff1258c70efa8c7b81c18daa419763a0
CombineSignedTransactionResult combine(
    rosetta.ConstructionCombineRequestPart req) {
  Map<String, rosetta.Signature> signaturesBySigData =
      <String, rosetta.Signature>{};
  for (var sig in req.signatures) {
    signaturesBySigData.putIfAbsent(sig.signing_payload.hex_bytes, () => sig);
  }

  var unsignedTransaction = cborDecode<Map>(req.unsigned_transaction.toU8a());

  assert(req.signatures.length ==
      unsignedTransaction["ingress_expiries"]?.length * 2);
  assert((unsignedTransaction["updates"] as List).length == 1);

  var envelopes = [];
  for (var updateItem in unsignedTransaction["updates"]) {
    var reqType = updateItem[0];

    var update = updateItem[1];
    var requestEnvelopes = [];

    for (var ingressExpiry in unsignedTransaction["ingress_expiries"]) {
      update["ingress_expiry"] = BigInt.from(ingressExpiry).toInt();

      var readState = make_read_state_from_update(update);

      var transactionSignature = signaturesBySigData[
          blobToHex(make_sig_data(HttpCanisterUpdate_id(update)))];

      var readStateSignature = signaturesBySigData[blobToHex(make_sig_data(
          HttpReadState_representation_independent_hash(readState)))];

      var envelope = {
        "content": {
          "request_type": "call",
          ...update,
        },
        "sender_pubkey": Ed25519PublicKey.fromRaw(
                blobFromHex(transactionSignature!.public_key.hex_bytes))
            .toDer(),
        "sender_sig": blobFromHex(transactionSignature.hex_bytes),
        "sender_delegation": null,
      };

      // envelope.content.encodeCBOR = cbor.Encoder.encodeIndefinite;

      var readStateEnvelope = {
        "content": {
          "request_type": "read_state",
          ...readState,
        },
        "sender_pubkey": Ed25519PublicKey.fromRaw(
                blobFromHex(readStateSignature!.public_key.hex_bytes))
            .toDer(),
        "sender_sig": blobFromHex(readStateSignature.hex_bytes),
        "sender_delegation": null,
      };
      requestEnvelopes
          .add({"update": envelope, "read_state": readStateEnvelope});
    }
    envelopes.add([reqType, requestEnvelopes]);
  }

  var signedTransaction = blobToHex(
      cborEncode(envelopes, withSerializer: initCborSerializerNoHead()));

  return CombineSignedTransactionResult(signedTransaction);
}

class CombineSignedTransactionResult {
  String signedTransaction;

  CombineSignedTransactionResult(this.signedTransaction);
}

const tweetNaclSignedPubLength = 32;

Map<String, dynamic> transactionDecoder(String txnHash) {
  final envelopes = cborDecode(blobFromHex(txnHash));
  assert(envelopes.length == 1);

  var envelope = envelopes[0][0];
  assert(envelope["content"]["request_type"] == "call");
  assert(envelope["content"]["method_name"] == "send_pb");
  var content = envelope["content"] as Map;
  var senderPubkey = envelope["sender_pubkey"];
  var sendArgs = SendRequest.fromBuffer(content["arg"]);
  var senderAddress = Principal.fromBlob(Uint8List.fromList(content["sender"]));
  final hash = SHA224()
    ..update(('\x0Aaccount-id').plainToU8a())
    ..update(senderAddress.toBlob())
    ..update(Uint8List(32));
  return {
    "from": hash.digest(),
    "to": Uint8List.fromList(sendArgs.to.hash.sublist(4)),
    "amount": BigInt.parse(sendArgs.payment.receiverGets.e8s.toRadixString(10)),
    "fee": BigInt.parse(sendArgs.maxFee.e8s.toRadixString(10)),
    "sender_pubkey": Uint8List.fromList(senderPubkey).sublist(
        (Uint8List.fromList(senderPubkey)).byteLength -
            tweetNaclSignedPubLength),
  };
}
