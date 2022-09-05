// ignore_for_file: non_constant_identifier_names
import 'package:agent_dart/agent_dart.dart';
import 'package:pinenacl/ed25519.dart';

final AccountIdentifier = IDL.Text;

class Duration {
  const Duration({required this.secs, required this.nanos});

  factory Duration.fromMap(Map map) {
    return Duration(secs: map['secs'], nanos: map['nanos']);
  }

  final BigInt secs;
  final int nanos;

  static Record idl = IDL.Record({'secs': IDL.Nat64, 'nanos': IDL.Nat32});

  Map<String, dynamic> toJson() {
    return {'secs': secs, 'nanos': nanos}
      ..removeWhere((key, dynamic value) => value == null);
  }
}

class ArchiveOptions {
  const ArchiveOptions({
    required this.controllerId,
    this.maxMessageSizeBytes,
    this.nodeMaxMemorySizeBytes,
  });

  factory ArchiveOptions.fromMap(Map map) {
    return ArchiveOptions(
      controllerId: map['controller_id'],
      maxMessageSizeBytes: map['max_message_size_bytes'],
      nodeMaxMemorySizeBytes: map['node_max_memory_size_bytes'],
    );
  }

  final int? maxMessageSizeBytes;
  final int? nodeMaxMemorySizeBytes;
  final Principal controllerId;

  static Record idl = IDL.Record({
    'max_message_size_bytes': IDL.Opt(IDL.Nat32),
    'node_max_memory_size_bytes': IDL.Opt(IDL.Nat32),
    'controller_id': IDL.Principal,
  });

  Map<String, dynamic> toJson() => {
        'max_message_size_bytes': maxMessageSizeBytes,
        'node_max_memory_size_bytes': nodeMaxMemorySizeBytes,
        'controller_id': controllerId,
      }..removeWhere((key, dynamic value) => value == null);
}

class ICPTs {
  const ICPTs({required this.e8s});

  factory ICPTs.fromMap(Map map) {
    return ICPTs(e8s: map['e8s']);
  }

  final BigInt e8s;

  static Record idl = IDL.Record({'e8s': IDL.Nat64});

  Map<String, dynamic> toJson() => {
        'e8s': e8s,
      }..removeWhere((key, dynamic value) => value == null);
}

class LedgerCanisterInitPayload {
  const LedgerCanisterInitPayload({
    required this.sendWhitelist,
    required this.mintingAccount,
    required this.initialValues,
    this.transactionWindow,
    this.maxMessageSizeBytes,
    this.archiveOptions,
  });

  factory LedgerCanisterInitPayload.fromMap(Map map) {
    final initValues = map['initial_values'] as List<List>;
    final initialValues = [
      [initValues[0], ICPTs.fromMap(initValues[1] as Map)]
    ];
    return LedgerCanisterInitPayload(
      sendWhitelist: map['send_whitelist'],
      mintingAccount: map['minting_account'],
      initialValues: initialValues,
      transactionWindow: map['transaction_window'] != null
          ? Duration.fromMap(map['transaction_window'])
          : null,
      maxMessageSizeBytes: map['max_message_size_bytes'],
      archiveOptions: map['archive_options'] != null
          ? ArchiveOptions.fromMap(map['archive_options'])
          : null,
    );
  }

  final List<List<Principal>> sendWhitelist;
  final String mintingAccount;
  final List<List> initialValues;
  final Duration? transactionWindow;
  final int? maxMessageSizeBytes;
  final ArchiveOptions? archiveOptions;

  static Record idl = IDL.Record({
    'send_whitelist': IDL.Vec(IDL.Tuple([IDL.Principal])),
    'minting_account': AccountIdentifier,
    'transaction_window': IDL.Opt(Duration.idl),
    'max_message_size_bytes': IDL.Opt(IDL.Nat32),
    'archive_options': IDL.Opt(ArchiveOptions.idl),
    'initial_values': IDL.Vec(IDL.Tuple([AccountIdentifier, ICPTs.idl])),
  });

  Map<String, dynamic> toJson() => {
        'send_whitelist':
            sendWhitelist.map((e) => e.map((f) => f).toList()).toList(),
        'minting_account': mintingAccount,
        'transaction_window':
            transactionWindow != null ? [transactionWindow?.toJson()] : [],
        'max_message_size_bytes':
            maxMessageSizeBytes != null ? [maxMessageSizeBytes] : [],
        'archive_options':
            archiveOptions != null ? [archiveOptions?.toJson()] : [],
        'initial_values': initialValues
            .map(
              (e) => e
                  .map((f) => f is String ? f : (f as ICPTs).toJson())
                  .toList(),
            )
            .toList()
      }..removeWhere((key, dynamic value) => value == null);
}

class AccountBalanceArgs {
  const AccountBalanceArgs({required this.account});

  factory AccountBalanceArgs.fromMap(Map map) {
    return AccountBalanceArgs(account: map['account']);
  }

  final String account;

  static Record idl = IDL.Record({'account': AccountIdentifier});

  Map<String, dynamic> toJson() => {
        'account': account,
      }..removeWhere((key, dynamic value) => value == null);
}

final SubAccount = IDL.Vec(IDL.Nat8);

final BlockHeight = IDL.Nat64;

class NotifyCanisterArgs {
  const NotifyCanisterArgs({
    this.toSubAccount,
    this.fromSubAccount,
    required this.toCanister,
    required this.maxFee,
    required this.blockHeight,
  });

  factory NotifyCanisterArgs.fromMap(Map map) {
    return NotifyCanisterArgs(
      toSubAccount: map['to_subaccount'],
      fromSubAccount: map['from_subaccount'],
      toCanister: map['to_canister'],
      maxFee: ICPTs.fromMap(map['max_fee']),
      blockHeight: map['block_height'],
    );
  }

  final List<int>? toSubAccount;
  final List<int>? fromSubAccount;
  final Principal toCanister;
  final ICPTs maxFee;
  final BigInt blockHeight;

  static final idl = IDL.Record({
    'to_subaccount': IDL.Opt(SubAccount),
    'from_subaccount': IDL.Opt(SubAccount),
    'to_canister': IDL.Principal,
    'max_fee': ICPTs.idl,
    'block_height': BlockHeight,
  });

  Map<String, dynamic> toJson() => {
        'to_subaccount': toSubAccount != null ? [toSubAccount] : [],
        'from_subaccount': fromSubAccount != null ? [fromSubAccount] : [],
        'to_canister': toCanister,
        'max_fee': maxFee.toJson(),
        'block_height': blockHeight,
      }..removeWhere((key, dynamic value) => value == null);
}

final Memo = IDL.Nat64;

class TimeStamp {
  const TimeStamp({required this.timestampNanos});

  factory TimeStamp.fromMap(Map map) {
    return TimeStamp(
      timestampNanos: map['timestamp_nanos'] ??
          DateTime.now().millisecondsSinceEpoch.toBn(),
    );
  }

  final BigInt timestampNanos;

  static Record idl = IDL.Record({'timestamp_nanos': IDL.Nat64});

  Map<String, dynamic> toJson() => {
        'timestamp_nanos': timestampNanos,
      }..removeWhere((key, dynamic value) => value == null);
}

class SendArgs {
  const SendArgs({
    required this.to,
    required this.fee,
    required this.memo,
    required this.amount,
    this.fromSubAccount,
    this.createdAtTime,
  });

  factory SendArgs.fromMap(Map map) {
    return SendArgs(
      to: map['to'],
      fee: ICPTs.fromMap(map['fee']),
      memo: map['memo'],
      amount: ICPTs.fromMap(map['amount']),
      fromSubAccount: map['from_subaccount'] != null
          ? List<int>.from(map['from_subaccount'])
          : null,
      createdAtTime: map['created_at_time'] != null
          ? TimeStamp.fromMap(map['created_at_time'])
          : null,
    );
  }

  final String to;
  final ICPTs fee;
  final BigInt memo;
  final List<int>? fromSubAccount;
  final TimeStamp? createdAtTime;
  final ICPTs amount;

  static Record idl = IDL.Record({
    'to': AccountIdentifier,
    'fee': ICPTs.idl,
    'memo': Memo,
    'from_subaccount': IDL.Opt(SubAccount),
    'created_at_time': IDL.Opt(TimeStamp.idl),
    'amount': ICPTs.idl,
  });

  Map<String, dynamic> toJson() => {
        'to': to,
        'fee': fee.toJson(),
        'memo': memo,
        'from_subaccount': fromSubAccount != null ? [fromSubAccount] : [],
        'created_at_time':
            createdAtTime != null ? [createdAtTime!.toJson()] : [],
        'amount': amount.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

final AccountIdentifierNew = IDL.Vec(IDL.Nat8);

class AccountBalanceArgsNew {
  const AccountBalanceArgsNew({required this.account});

  factory AccountBalanceArgsNew.fromMap(Map map) {
    return AccountBalanceArgsNew(account: List<int>.from(map['account']));
  }

  final List<int> account;

  static Record idl = IDL.Record({
    'account': AccountIdentifierNew,
  });

  Map<String, dynamic> toJson() =>
      {'account': account}..removeWhere((key, dynamic value) => value == null);
}

class Tokens {
  const Tokens({required this.e8s});

  factory Tokens.fromMap(Map map) {
    return Tokens(e8s: map['e8s']);
  }

  final BigInt e8s;

  static Record idl = IDL.Record({'e8s': IDL.Nat64});

  Map<String, dynamic> toJson() =>
      {'e8s': e8s}..removeWhere((key, dynamic value) => value == null);
}

class TransferArgs {
  const TransferArgs({
    required this.to,
    required this.fee,
    required this.memo,
    required this.amount,
    this.fromSubAccount,
    this.createdAtTime,
  });

  factory TransferArgs.fromMap(Map map) {
    return TransferArgs(
      to: (map['to'] is String
          ? isHexString(map['to'])
              ? (map['to'] as String).toU8a().toList()
              : Principal.fromText((map['to'] as String)).toAccountId().toList()
          : (u8aToU8a(map['to']).toList())),
      fee: Tokens.fromMap(map['fee']),
      memo: map['memo'],
      amount: Tokens.fromMap(map['amount']),
      fromSubAccount: map['from_subaccount'] != null
          ? List<int>.from(map['from_subaccount'])
          : null,
      createdAtTime: map['created_at_time'] != null
          ? TimeStamp.fromMap(map['created_at_time'])
          : null,
    );
  }

  final List<int> to;
  final Tokens fee;
  final BigInt memo;
  final List<int>? fromSubAccount;
  final TimeStamp? createdAtTime;
  final Tokens amount;

  static Record idl = IDL.Record({
    'to': AccountIdentifierNew,
    'fee': Tokens.idl,
    'memo': Memo,
    'from_subaccount': IDL.Opt(SubAccount),
    'created_at_time': IDL.Opt(TimeStamp.idl),
    'amount': Tokens.idl,
  });

  Map<String, dynamic> toJson() => {
        'to': to,
        'fee': fee.toJson(),
        'memo': memo,
        'from_subaccount': fromSubAccount != null ? [fromSubAccount] : [],
        'created_at_time':
            createdAtTime != null ? [createdAtTime!.toJson()] : [],
        'amount': amount.toJson()
      }..removeWhere((key, dynamic value) => value == null);
}

final BlockIndex = IDL.Nat64;

class TransferError {
  const TransferError({
    this.txTooOld,
    this.badFee,
    this.txDuplicate,
    this.txCreatedInFuture,
    this.insufficientFunds,
  });

  factory TransferError.fromMap(Map map) {
    return TransferError(
      txTooOld: map['TxTooOld'] != null ? Map.from(map['TxTooOld']) : null,
      badFee: map['BadFee'] != null ? Map.from(map['BadFee']) : null,
      txDuplicate:
          map['TxDuplicate'] != null ? Map.from(map['TxDuplicate']) : null,
      insufficientFunds: map['InsufficientFunds'] != null
          ? Map.from(map['InsufficientFunds'])
          : null,
      txCreatedInFuture: map.containsKey('TxCreatedInFuture'),
    );
  }

  final Map? txTooOld;
  final Map? badFee;
  final Map? txDuplicate;
  final bool? txCreatedInFuture;
  final Map? insufficientFunds;

  static Variant idl = IDL.Variant({
    'TxTooOld': IDL.Record({'allowed_window_nanos': IDL.Nat64}),
    'BadFee': IDL.Record({'expected_fee': Tokens.idl}),
    'TxDuplicate': IDL.Record({'duplicate_of': BlockIndex}),
    'TxCreatedInFuture': IDL.Null,
    'InsufficientFunds': IDL.Record({'balance': Tokens.idl}),
  });

  Map<String, dynamic> toJson() {
    final res = {
      'TxTooOld': txTooOld,
      'BadFee': badFee,
      'TxDuplicate': txDuplicate,
      'InsufficientFunds': insufficientFunds,
      'TxCreatedInFuture': txCreatedInFuture
    }..removeWhere((key, dynamic value) => value == null || value == false);
    if (res['TxCreatedInFuture'] != null && res['TxCreatedInFuture'] == true) {
      res.update('TxCreatedInFuture', (value) => null);
    }
    return res;
  }
}

class TransferResult {
  const TransferResult({this.ok, this.err});

  factory TransferResult.fromMap(Map map) {
    return TransferResult(
      ok: map['Ok'] != null ? (map['Ok']) : null,
      err: map['Err'] != null ? TransferError.fromMap(map['Err']) : null,
    );
  }

  final BigInt? ok;
  final TransferError? err;

  static Variant idl = IDL.Variant({
    'Ok': BlockIndex,
    'Err': TransferError.idl,
  });

  Map<String, dynamic> toJson() {
    return {'Ok': ok, 'Err': err?.toJson()}
      ..removeWhere((key, dynamic value) => value == null);
  }
}

Service ledgerIdl = IDL.Service({
  'account_balance': IDL.Func(
    [AccountBalanceArgsNew.idl],
    [Tokens.idl],
    ['query'],
  ),
  'account_balance_dfx': IDL.Func(
    [AccountBalanceArgs.idl],
    [ICPTs.idl],
    ['query'],
  ),
  'notify_dfx': IDL.Func([NotifyCanisterArgs.idl], [], []),
  'send_dfx': IDL.Func([SendArgs.idl], [BlockHeight], []),
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
  const SendOpts({
    this.fee,
    this.memo,
    this.fromSubAccount,
    this.createAtTime,
  });

  final BigInt? fee;
  final BigInt? memo;
  final int? fromSubAccount;
  final DateTime? createAtTime; // TODO: create js Date to TimeStamp function
}

class Ledger {
  Ledger();

  factory Ledger.hook(AgentFactory agent) {
    return Ledger()..setAgent(agent);
  }

  late AgentFactory agent;

  void setAgent(AgentFactory agent) {
    this.agent = agent;
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
    final ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
    final res = await ledgerInstance.agent.actor!.getFunc(
      LedgerMethods.getBalance,
    )!(
      [AccountBalanceArgs(account: accountId).toJson()],
    );
    if (res != null) {
      return ICPTs.fromMap(res);
    }
    throw 'Cannot get count but $res';
  }

  static Future<Tokens> accountBalance({
    required AgentFactory agent,
    required String accountIdOrPrincipal,
    SignIdentity? identity,
  }) async {
    final ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
    final accountId = isHexString(accountIdOrPrincipal)
        ? (accountIdOrPrincipal).toU8a().toList()
        : Principal.fromText(accountIdOrPrincipal).toAccountId().toList();
    final res = await ledgerInstance.agent.actor!
        .getFunc(LedgerMethods.accountBalance)!(
      [AccountBalanceArgsNew(account: accountId).toJson()],
    );
    if (res != null) {
      return Tokens.fromMap(res);
    }
    throw 'Cannot get count but $res';
  }

  static Future<BigInt> send({
    required AgentFactory agent,
    required String to,
    required BigInt amount,
    SendOpts? sendOpts,
    SignIdentity? identity,
  }) async {
    final ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
    final defaultFee = BigInt.from(10000);
    final defaultMemo = getRandomValues(4).toBn(endian: Endian.big);
    final sendArgs = {
      'to': to,
      'fee': {
        'e8s': sendOpts?.fee ?? defaultFee,
      },
      'amount': {'e8s': amount},
      'memo': sendOpts?.memo ?? defaultMemo,
      'from_subaccount': null,
      'created_at_time': sendOpts?.createAtTime != null
          ? {
              'timestamp_nanos':
                  sendOpts?.createAtTime?.millisecondsSinceEpoch.toBn(),
            }
          : null,
    };

    final res = await ledgerInstance.agent.actor!.getFunc(
      LedgerMethods.send,
    )!([SendArgs.fromMap(sendArgs).toJson()]);
    if (res != null) {
      return res as BigInt;
    }
    throw 'Cannot get count but $res';
  }

  static Future<TransferResult> transfer({
    required AgentFactory agent,
    required String to,
    required BigInt amount,
    SendOpts? sendOpts,
    SignIdentity? identity,
  }) async {
    final ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
    final defaultFee = BigInt.from(10000);
    final defaultMemo = getRandomValues(4).toBn(endian: Endian.big);
    final sendArgs = {
      'to': to,
      'fee': {
        'e8s': sendOpts?.fee ?? defaultFee,
      },
      'amount': {'e8s': amount},
      'memo': sendOpts?.memo ?? defaultMemo,
      'from_subaccount': null,
      'created_at_time': sendOpts?.createAtTime == null
          ? null
          : {
              'timestamp_nanos':
                  sendOpts?.createAtTime?.millisecondsSinceEpoch.toBn()
            },
    };
    final res = await ledgerInstance.agent.actor!.getFunc(
      LedgerMethods.transfer,
    )!([TransferArgs.fromMap(sendArgs).toJson()]);
    if (res != null) {
      return TransferResult.fromMap(res as Map);
    }
    throw 'Cannot get count but $res';
  }
}
