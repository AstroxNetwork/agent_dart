import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/protobuf/ic_ledger/pb/v1/types.pb.dart';
import 'package:pinenacl/ed25519.dart';

// ignore: non_constant_identifier_names
final AccountIdentifier = IDL.Text;

class Duration {
  // ignore: non_constant_identifier_names
  BigInt secs;
  // ignore: non_constant_identifier_names
  int nanos;

  // ignore: non_constant_identifier_names
  Duration(
      // ignore: non_constant_identifier_names
      {
    required this.secs,
    // ignore: non_constant_identifier_names
    required this.nanos,
  });

  factory Duration.fromMap(Map map) {
    return Duration(
      secs: map["secs"],
      nanos: map["nanos"],
    );
  }

  static Record idl = IDL.Record({"secs": IDL.Nat64, "nanos": IDL.Nat32});

  Map<String, dynamic> toJson() => {
        "secs": secs,
        "nanos": nanos,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class ArchiveOptions {
  // ignore: non_constant_identifier_names
  int? max_message_size_bytes;
  // ignore: non_constant_identifier_names
  int? node_max_memory_size_bytes;
  // ignore: non_constant_identifier_names
  Principal controller_id;

  ArchiveOptions({
    // ignore: non_constant_identifier_names
    required this.controller_id,
    // ignore: non_constant_identifier_names
    this.max_message_size_bytes,
    // ignore: non_constant_identifier_names
    this.node_max_memory_size_bytes,
  });

  factory ArchiveOptions.fromMap(Map map) {
    return ArchiveOptions(
      controller_id: map["controller_id"],
      max_message_size_bytes: map["max_message_size_bytes"],
      node_max_memory_size_bytes: map["node_max_memory_size_bytes"],
    );
  }

  static Record idl = IDL.Record({
    "max_message_size_bytes": IDL.Opt(IDL.Nat32),
    "node_max_memory_size_bytes": IDL.Opt(IDL.Nat32),
    "controller_id": IDL.Principal,
  });
  Map<String, dynamic> toJson() => {
        "max_message_size_bytes": max_message_size_bytes,
        "node_max_memory_size_bytes": node_max_memory_size_bytes,
        "controller_id": controller_id,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class ICPTs {
  BigInt e8s;

  ICPTs({
    // ignore: non_constant_identifier_names
    required this.e8s,
  });

  factory ICPTs.fromMap(Map map) {
    return ICPTs(e8s: map["e8s"]);
  }

  static Record idl = IDL.Record({"e8s": IDL.Nat64});
  Map<String, dynamic> toJson() => {
        "e8s": e8s,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class LedgerCanisterInitPayload {
  // ignore: non_constant_identifier_names
  List<List<Principal>> send_whitelist;
  // ignore: non_constant_identifier_names
  String minting_account;
  // ignore: non_constant_identifier_names
  List<List> initial_values;
  // ignore: non_constant_identifier_names
  Duration? transaction_window;
  // ignore: non_constant_identifier_names
  int? max_message_size_bytes;
  // ignore: non_constant_identifier_names
  ArchiveOptions? archive_options;

  LedgerCanisterInitPayload(
      {
      // ignore: non_constant_identifier_names
      required this.send_whitelist,
      // ignore: non_constant_identifier_names
      required this.minting_account,
      // ignore: non_constant_identifier_names
      required this.initial_values,
      // ignore: non_constant_identifier_names
      this.transaction_window,
      // ignore: non_constant_identifier_names
      this.max_message_size_bytes,
      // ignore: non_constant_identifier_names
      this.archive_options});

  factory LedgerCanisterInitPayload.fromMap(Map map) {
    var initValues = map["initial_values"] as List<List>;
    // ignore: non_constant_identifier_names
    var initial_values = [
      [initValues[0], ICPTs.fromMap(initValues[1] as Map)]
    ];
    return LedgerCanisterInitPayload(
      send_whitelist: map["send_whitelist"],
      minting_account: map["minting_account"],
      initial_values: initial_values,
      transaction_window: map["transaction_window"] != null
          ? Duration.fromMap(map["transaction_window"])
          : null,
      max_message_size_bytes: map["max_message_size_bytes"],
      archive_options: map["archive_options"] != null
          ? ArchiveOptions.fromMap(map["archive_options"])
          : null,
    );
  }

  static Record idl = IDL.Record({
    "send_whitelist": IDL.Vec(IDL.Tuple([IDL.Principal])),
    "minting_account": AccountIdentifier,
    "transaction_window": IDL.Opt(Duration.idl),
    "max_message_size_bytes": IDL.Opt(IDL.Nat32),
    "archive_options": IDL.Opt(ArchiveOptions.idl),
    "initial_values": IDL.Vec(IDL.Tuple([AccountIdentifier, ICPTs.idl])),
  });
  Map<String, dynamic> toJson() => {
        "send_whitelist":
            send_whitelist.map((e) => e.map((f) => f).toList()).toList(),
        "minting_account": minting_account,
        "transaction_window":
            transaction_window != null ? [transaction_window?.toJson()] : [],
        "max_message_size_bytes":
            max_message_size_bytes != null ? [max_message_size_bytes] : [],
        "archive_options":
            archive_options != null ? [archive_options?.toJson()] : [],
        "initial_values": initial_values
            .map((e) =>
                e.map((f) => f is String ? f : (f as ICPTs).toJson()).toList())
            .toList()
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class AccountBalanceArgs {
  String account;

  AccountBalanceArgs({
    // ignore: non_constant_identifier_names
    required this.account,
  });

  factory AccountBalanceArgs.fromMap(Map map) {
    return AccountBalanceArgs(account: map["account"]);
  }

  static Record idl = IDL.Record({"account": AccountIdentifier});
  Map<String, dynamic> toJson() => {
        "account": account,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

// ignore: non_constant_identifier_names
final SubAccount = IDL.Vec(IDL.Nat8);
// ignore: non_constant_identifier_names
final BlockHeight = IDL.Nat64;

class NotifyCanisterArgs {
  // ignore: non_constant_identifier_names
  List<int>? to_subaccount;
  // ignore: non_constant_identifier_names
  List<int>? from_subaccount;
  // ignore: non_constant_identifier_names
  Principal to_canister;
  // ignore: non_constant_identifier_names
  ICPTs max_fee;
  // ignore: non_constant_identifier_names
  BigInt block_height;

  NotifyCanisterArgs(
      {
      // ignore: non_constant_identifier_names
      this.to_subaccount,
      // ignore: non_constant_identifier_names
      this.from_subaccount,
      // ignore: non_constant_identifier_names
      required this.to_canister,
      // ignore: non_constant_identifier_names
      required this.max_fee,
      // ignore: non_constant_identifier_names
      required this.block_height});

  factory NotifyCanisterArgs.fromMap(Map map) {
    return NotifyCanisterArgs(
        to_subaccount: map["to_subaccount"],
        from_subaccount: map["from_subaccount"],
        to_canister: map["to_canister"],
        max_fee: ICPTs.fromMap(map["max_fee"]),
        block_height: map["block_height"]);
  }

  static final idl = IDL.Record({
    "to_subaccount": IDL.Opt(SubAccount),
    "from_subaccount": IDL.Opt(SubAccount),
    "to_canister": IDL.Principal,
    "max_fee": ICPTs.idl,
    "block_height": BlockHeight,
  });

  Map<String, dynamic> toJson() => {
        "to_subaccount": to_subaccount != null ? [to_subaccount] : [],
        "from_subaccount": from_subaccount != null ? [from_subaccount] : [],
        "to_canister": to_canister,
        "max_fee": max_fee.toJson(),
        "block_height": block_height,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

// ignore: non_constant_identifier_names
final Memo = IDL.Nat64;

class TimeStamp {
  // ignore: non_constant_identifier_names
  BigInt timestamp_nanos;

  TimeStamp({
    // ignore: non_constant_identifier_names
    required this.timestamp_nanos,
  });

  factory TimeStamp.fromMap(Map map) {
    return TimeStamp(
        timestamp_nanos: map["timestamp_nanos"] ??
            DateTime.now().millisecondsSinceEpoch.toBn());
  }

  static Record idl = IDL.Record({"timestamp_nanos": IDL.Nat64});
  Map<String, dynamic> toJson() => {
        "timestamp_nanos": timestamp_nanos,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class SendArgs {
  // ignore: non_constant_identifier_names
  String to;
  ICPTs fee;
  BigInt memo;
  // ignore: non_constant_identifier_names
  List<int>? from_subaccount;
  // ignore: non_constant_identifier_names
  TimeStamp? created_at_time;
  ICPTs amount;

  SendArgs({
    // ignore: non_constant_identifier_names
    required this.to,
    required this.fee,
    required this.memo,
    required this.amount,
    // ignore: non_constant_identifier_names
    this.from_subaccount,
    // ignore: non_constant_identifier_names
    this.created_at_time,
  });

  factory SendArgs.fromMap(Map map) {
    return SendArgs(
      to: map["to"],
      fee: ICPTs.fromMap(map["fee"]),
      memo: map["memo"],
      amount: ICPTs.fromMap(map["amount"]),
      from_subaccount: map["from_subaccount"] != null
          ? List<int>.from(map["from_subaccount"])
          : null,
      created_at_time: map["created_at_time"] != null
          ? TimeStamp.fromMap(map["created_at_time"])
          : null,
    );
  }

  static Record idl = IDL.Record({
    "to": AccountIdentifier,
    "fee": ICPTs.idl,
    "memo": Memo,
    "from_subaccount": IDL.Opt(SubAccount),
    "created_at_time": IDL.Opt(TimeStamp.idl),
    "amount": ICPTs.idl,
  });
  Map<String, dynamic> toJson() => {
        "to": to,
        "fee": fee.toJson(),
        "memo": memo,
        "from_subaccount": from_subaccount != null ? [from_subaccount] : [],
        "created_at_time":
            created_at_time != null ? [created_at_time!.toJson()] : [],
        "amount": amount.toJson()
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

final AccountIdentifierNew = IDL.Vec(IDL.Nat8);

class AccountBalanceArgsNew {
  List<int> account;

  AccountBalanceArgsNew({
    // ignore: non_constant_identifier_names
    required this.account,
  });

  factory AccountBalanceArgsNew.fromMap(Map map) {
    return AccountBalanceArgsNew(account: List<int>.from(map["account"]));
  }

  static Record idl = IDL.Record({
    'account': AccountIdentifierNew,
  });
  Map<String, dynamic> toJson() => {
        "account": account,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class Tokens {
  BigInt e8s;

  Tokens({
    // ignore: non_constant_identifier_names
    required this.e8s,
  });

  factory Tokens.fromMap(Map map) {
    return Tokens(e8s: map["e8s"]);
  }

  static Record idl = IDL.Record({"e8s": IDL.Nat64});
  Map<String, dynamic> toJson() => {
        "e8s": e8s,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class TransferArgs {
  // ignore: non_constant_identifier_names
  List<int> to;
  Tokens fee;
  BigInt memo;
  // ignore: non_constant_identifier_names
  List<int>? from_subaccount;
  // ignore: non_constant_identifier_names
  TimeStamp? created_at_time;
  Tokens amount;

  TransferArgs({
    // ignore: non_constant_identifier_names
    required this.to,
    required this.fee,
    required this.memo,
    required this.amount,
    // ignore: non_constant_identifier_names
    this.from_subaccount,
    // ignore: non_constant_identifier_names
    this.created_at_time,
  });

  factory TransferArgs.fromMap(Map map) {
    return TransferArgs(
      to: (map["to"] is String
          ? isHexString(map["to"])
              ? (map["to"] as String).toU8a().toList()
              : Principal.fromText((map["to"] as String)).toAccountID().toList()
          : (u8aToU8a(map["to"]).toList())),
      fee: Tokens.fromMap(map["fee"]),
      memo: map["memo"],
      amount: Tokens.fromMap(map["amount"]),
      from_subaccount: map["from_subaccount"] != null
          ? List<int>.from(map["from_subaccount"])
          : null,
      created_at_time: map["created_at_time"] != null
          ? TimeStamp.fromMap(map["created_at_time"])
          : null,
    );
  }

  static Record idl = IDL.Record({
    'to': AccountIdentifierNew,
    'fee': Tokens.idl,
    'memo': Memo,
    'from_subaccount': IDL.Opt(SubAccount),
    'created_at_time': IDL.Opt(TimeStamp.idl),
    'amount': Tokens.idl,
  });
  Map<String, dynamic> toJson() => {
        "to": to,
        "fee": fee.toJson(),
        "memo": memo,
        "from_subaccount": from_subaccount != null ? [from_subaccount] : [],
        "created_at_time":
            created_at_time != null ? [created_at_time!.toJson()] : [],
        "amount": amount.toJson()
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

final BlockIndex = IDL.Nat64;

class TransferError {
  Map? TxTooOld;
  Map? BadFee;
  Map? TxDuplicate;
  bool? TxCreatedInFuture;
  Map? InsufficientFunds;

  TransferError(
      {this.TxTooOld,
      this.BadFee,
      this.TxDuplicate,
      this.TxCreatedInFuture,
      this.InsufficientFunds});

  factory TransferError.fromMap(Map map) {
    return TransferError(
        TxTooOld: map["TxTooOld"] != null ? Map.from(map["TxTooOld"]) : null,
        BadFee: map["BadFee"] != null ? Map.from(map["BadFee"]) : null,
        TxDuplicate:
            map["TxDuplicate"] != null ? Map.from(map["TxDuplicate"]) : null,
        InsufficientFunds: map["InsufficientFunds"] != null
            ? Map.from(map["InsufficientFunds"])
            : null,
        TxCreatedInFuture: map.containsKey("TxCreatedInFuture"));
  }
  static Variant idl = IDL.Variant({
    'TxTooOld': IDL.Record({'allowed_window_nanos': IDL.Nat64}),
    'BadFee': IDL.Record({'expected_fee': Tokens.idl}),
    'TxDuplicate': IDL.Record({'duplicate_of': BlockIndex}),
    'TxCreatedInFuture': IDL.Null,
    'InsufficientFunds': IDL.Record({'balance': Tokens.idl}),
  });
  Map<String, dynamic> toJson() {
    var res = {
      "TxTooOld": TxTooOld,
      "BadFee": BadFee,
      "TxDuplicate": TxDuplicate,
      "InsufficientFunds": InsufficientFunds,
      "TxCreatedInFuture": TxCreatedInFuture
    }..removeWhere((dynamic key, dynamic value) =>
        key == null || value == null || value == false);
    if (res["TxCreatedInFuture"] != null && res["TxCreatedInFuture"] == true) {
      res.update("TxCreatedInFuture", (value) => null);
    }
    return res;
  }
}

class TransferResult {
  BigInt? Ok;
  TransferError? Err;
  TransferResult({this.Ok, this.Err});
  factory TransferResult.fromMap(Map map) {
    return TransferResult(
      Ok: map["Ok"] != null ? (map["Ok"]) : null,
      Err: map["Err"] != null ? TransferError.fromMap(map["Err"]) : null,
    );
  }

  static Variant idl = IDL.Variant({
    'Ok': BlockIndex,
    'Err': TransferError.idl,
  });

  Map<String, dynamic> toJson() {
    return {
      "Ok": Ok,
      "Err": Err?.toJson(),
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}

Service ledgerIdl = IDL.Service({
  'account_balance':
      IDL.Func([AccountBalanceArgsNew.idl], [Tokens.idl], ['query']),
  "account_balance_dfx":
      IDL.Func([AccountBalanceArgs.idl], [ICPTs.idl], ['query']),
  "notify_dfx": IDL.Func([NotifyCanisterArgs.idl], [], []),
  "send_dfx": IDL.Func([SendArgs.idl], [BlockHeight], []),
  'transfer': IDL.Func([TransferArgs.idl], [TransferResult.idl], []),
});

class LedgerMethods {
  static const getBalance = 'account_balance_dfx';
  static const notify = 'notify_dfx';
  static const send = 'send_dfx';
  static const accountBalance = 'account_balance';
  static const transfer = 'transfer';
}

// ledgerInit() {
//   final AccountIdentifier = IDL.Text;
//   final Duration = IDL.Record({"secs": IDL.Nat64, "nanos": IDL.Nat32});
//   final ArchiveOptions = IDL.Record({
//     "max_message_size_bytes": IDL.Opt(IDL.Nat32),
//     "node_max_memory_size_bytes": IDL.Opt(IDL.Nat32),
//     "controller_id": IDL.Principal,
//   });
//   final ICPTs = IDL.Record({"e8s": IDL.Nat64});
//   final LedgerCanisterInitPayload = IDL.Record({
//     "send_whitelist": IDL.Vec(IDL.Tuple([IDL.Principal])),
//     "minting_account": AccountIdentifier,
//     "transaction_window": IDL.Opt(Duration),
//     "max_message_size_bytes": IDL.Opt(IDL.Nat32),
//     "archive_options": IDL.Opt(ArchiveOptions),
//     "initial_values": IDL.Vec(IDL.Tuple([AccountIdentifier, ICPTs])),
//   });
//   return [LedgerCanisterInitPayload];
// }

class SendOpts {
  BigInt? fee;
  BigInt? memo;
  // ignore: non_constant_identifier_names
  int? from_subaccount;
  // ignore: non_constant_identifier_names
  DateTime? created_at_time; // TODO: create js Date to TimeStamp function
}

class Ledger {
  late AgentFactory agent;
  // CanisterActor? _baseActor;
  Ledger();
  factory Ledger.hook(AgentFactory agent) {
    return Ledger()..setAgent(agent);
  }
  void setAgent(AgentFactory _agent) {
    agent = _agent;
  }

  void setIdentity(SignIdentity? id) {
    if (id != null) {
      agent.getAgent().setIdentity(Future.value(id));
    }
  }

  static Future<ICPTs> getBalance({
    required AgentFactory agent,
    required String accountId,
    SignIdentity? identity,
  }) async {
    try {
      var ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
      var res =
          await ledgerInstance.agent.actor!.getFunc(LedgerMethods.getBalance)!(
              [AccountBalanceArgs(account: accountId).toJson()]);

      if (res != null) {
        return ICPTs.fromMap(res);
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }

  static Future<Tokens> accountBalance({
    required AgentFactory agent,
    required String accountIdOrPrincipal,
    SignIdentity? identity,
  }) async {
    try {
      var ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
      var accountId = isHexString(accountIdOrPrincipal)
          ? (accountIdOrPrincipal).toU8a().toList()
          : Principal.fromText(accountIdOrPrincipal).toAccountID().toList();

      var res = await ledgerInstance.agent.actor!
              .getFunc(LedgerMethods.accountBalance)!(
          [AccountBalanceArgsNew(account: accountId).toJson()]);

      if (res != null) {
        return Tokens.fromMap(res);
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }

  static Future<BigInt> send({
    required AgentFactory agent,
    required String to,
    required BigInt amount,
    SendOpts? sendOpts,
    SignIdentity? identity,
  }) async {
    try {
      var ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
      var defaultFee = BigInt.from(10000);
      var defaultMemo = getRandomValues(4).toBn(endian: Endian.big);

      var sendArgs = {
        "to": to,
        "fee": {
          "e8s": sendOpts?.fee ?? defaultFee,
        },
        "amount": {"e8s": amount},
        "memo": sendOpts?.memo ?? defaultMemo,
        "from_subaccount": null,
        "created_at_time": sendOpts?.created_at_time == null
            ? null
            : {
                "timestamp_nanos":
                    sendOpts?.created_at_time?.millisecondsSinceEpoch.toBn()
              },
      };

      var res = await ledgerInstance.agent.actor!
          .getFunc(LedgerMethods.send)!([SendArgs.fromMap(sendArgs).toJson()]);

      if (res != null) {
        return res as BigInt;
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }

  static Future<TransferResult> transfer({
    required AgentFactory agent,
    required String to,
    required BigInt amount,
    SendOpts? sendOpts,
    SignIdentity? identity,
  }) async {
    try {
      var ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
      var defaultFee = BigInt.from(10000);
      var defaultMemo = getRandomValues(4).toBn(endian: Endian.big);

      var sendArgs = {
        "to": to,
        "fee": {
          "e8s": sendOpts?.fee ?? defaultFee,
        },
        "amount": {"e8s": amount},
        "memo": sendOpts?.memo ?? defaultMemo,
        "from_subaccount": null,
        "created_at_time": sendOpts?.created_at_time == null
            ? null
            : {
                "timestamp_nanos":
                    sendOpts?.created_at_time?.millisecondsSinceEpoch.toBn()
              },
      };

      var res = await ledgerInstance.agent.actor!.getFunc(
          LedgerMethods.transfer)!([TransferArgs.fromMap(sendArgs).toJson()]);

      if (res != null) {
        return TransferResult.fromMap(res as Map);
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }
}
