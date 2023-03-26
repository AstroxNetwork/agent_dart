// ignore_for_file: non_constant_identifier_names
import 'package:agent_dart/agent_dart.dart';
import 'package:pinenacl/ed25519.dart';

const _accountIdentifier = IDL.Text;

class PayloadDuration {
  const PayloadDuration({required this.secs, required this.nanos});

  factory PayloadDuration.fromJson(Map map) {
    return PayloadDuration(secs: map['secs'], nanos: map['nanos']);
  }

  final BigInt secs;
  final int nanos;

  static Record idl = IDL.Record({'secs': IDL.Nat64, 'nanos': IDL.Nat32});

  Map<String, dynamic> toJson() {
    return {'secs': secs, 'nanos': nanos}
      ..removeWhere((key, value) => value == null);
  }
}

class ArchiveOptions {
  const ArchiveOptions({
    required this.controllerId,
    this.maxMessageSizeBytes,
    this.nodeMaxMemorySizeBytes,
  });

  factory ArchiveOptions.fromJson(Map map) {
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

  Map<String, dynamic> toJson() {
    return {
      'max_message_size_bytes': maxMessageSizeBytes,
      'node_max_memory_size_bytes': nodeMaxMemorySizeBytes,
      'controller_id': controllerId,
    }..removeWhere((key, value) => value == null);
  }
}

class ICPTs {
  const ICPTs({required this.e8s});

  factory ICPTs.fromJson(Map map) {
    return ICPTs(e8s: map['e8s']);
  }

  final BigInt e8s;

  static Record idl = IDL.Record({'e8s': IDL.Nat64});

  Map<String, dynamic> toJson() {
    return {'e8s': e8s}..removeWhere((key, value) => value == null);
  }
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

  factory LedgerCanisterInitPayload.fromJson(Map map) {
    final initValues = map['initial_values'] as List<List>;
    final initialValues = [
      [initValues[0], ICPTs.fromJson(initValues[1] as Map)],
    ];
    return LedgerCanisterInitPayload(
      sendWhitelist: map['send_whitelist'],
      mintingAccount: map['minting_account'],
      initialValues: initialValues,
      transactionWindow: map['transaction_window'] != null
          ? PayloadDuration.fromJson(map['transaction_window'])
          : null,
      maxMessageSizeBytes: map['max_message_size_bytes'],
      archiveOptions: map['archive_options'] != null
          ? ArchiveOptions.fromJson(map['archive_options'])
          : null,
    );
  }

  final List<List<Principal>> sendWhitelist;
  final String mintingAccount;
  final List<List> initialValues;
  final PayloadDuration? transactionWindow;
  final int? maxMessageSizeBytes;
  final ArchiveOptions? archiveOptions;

  static Record idl = IDL.Record({
    'send_whitelist': IDL.Vec(IDL.Tuple([IDL.Principal])),
    'minting_account': _accountIdentifier,
    'transaction_window': IDL.Opt(PayloadDuration.idl),
    'max_message_size_bytes': IDL.Opt(IDL.Nat32),
    'archive_options': IDL.Opt(ArchiveOptions.idl),
    'initial_values': IDL.Vec(IDL.Tuple([_accountIdentifier, ICPTs.idl])),
  });

  Map<String, dynamic> toJson() {
    return {
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
            (e) =>
                e.map((f) => f is String ? f : (f as ICPTs).toJson()).toList(),
          )
          .toList(),
    }..removeWhere((key, value) => value == null);
  }
}

class AccountBalanceArgs {
  const AccountBalanceArgs({required this.account});

  factory AccountBalanceArgs.fromJson(Map map) {
    return AccountBalanceArgs(account: map['account']);
  }

  final String account;

  static Record idl = IDL.Record({'account': _accountIdentifier});

  Map<String, dynamic> toJson() {
    return {'account': account}..removeWhere((key, value) => value == null);
  }
}

final SubAccount = IDL.Vec(IDL.Nat8);

const _blockHeight = IDL.Nat64;

class NotifyCanisterArgs {
  const NotifyCanisterArgs({
    this.toSubAccount,
    this.fromSubAccount,
    required this.toCanister,
    required this.maxFee,
    required this.blockHeight,
  });

  factory NotifyCanisterArgs.fromJson(Map map) {
    return NotifyCanisterArgs(
      toSubAccount: map['to_subaccount'],
      fromSubAccount: map['from_subaccount'],
      toCanister: map['to_canister'],
      maxFee: ICPTs.fromJson(map['max_fee']),
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
    'block_height': _blockHeight,
  });

  Map<String, dynamic> toJson() {
    return {
      'to_subaccount': toSubAccount != null ? [toSubAccount] : [],
      'from_subaccount': fromSubAccount != null ? [fromSubAccount] : [],
      'to_canister': toCanister,
      'max_fee': maxFee.toJson(),
      'block_height': blockHeight,
    }..removeWhere((key, value) => value == null);
  }
}

const _memo = IDL.Nat64;

class TimeStamp {
  const TimeStamp({required this.timestampNanos});

  factory TimeStamp.fromJson(Map map) {
    return TimeStamp(
      timestampNanos: map['timestamp_nanos'] ??
          DateTime.now().millisecondsSinceEpoch.toBn(),
    );
  }

  final BigInt timestampNanos;

  static Record idl = IDL.Record({'timestamp_nanos': IDL.Nat64});

  Map<String, dynamic> toJson() {
    return {'timestamp_nanos': timestampNanos}
      ..removeWhere((key, value) => value == null);
  }
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

  factory SendArgs.fromJson(Map map) {
    return SendArgs(
      to: map['to'],
      fee: ICPTs.fromJson(map['fee']),
      memo: map['memo'],
      amount: ICPTs.fromJson(map['amount']),
      fromSubAccount: map['from_subaccount'] != null
          ? List<int>.from(map['from_subaccount'])
          : null,
      createdAtTime: map['created_at_time'] != null
          ? TimeStamp.fromJson(map['created_at_time'])
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
    'to': _accountIdentifier,
    'fee': ICPTs.idl,
    'memo': _memo,
    'from_subaccount': IDL.Opt(SubAccount),
    'created_at_time': IDL.Opt(TimeStamp.idl),
    'amount': ICPTs.idl,
  });

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'fee': fee.toJson(),
      'memo': memo,
      'from_subaccount': fromSubAccount != null ? [fromSubAccount] : [],
      'created_at_time': createdAtTime != null ? [createdAtTime!.toJson()] : [],
      'amount': amount.toJson()
    }..removeWhere((key, value) => value == null);
  }
}

final AccountIdentifierNew = IDL.Vec(IDL.Nat8);

class AccountBalanceArgsNew {
  const AccountBalanceArgsNew({required this.account});

  factory AccountBalanceArgsNew.fromJson(Map map) {
    return AccountBalanceArgsNew(account: List<int>.from(map['account']));
  }

  final List<int> account;

  static Record idl = IDL.Record({'account': AccountIdentifierNew});

  Map<String, dynamic> toJson() {
    return {'account': account}..removeWhere((key, value) => value == null);
  }
}

class Tokens {
  const Tokens({required this.e8s});

  factory Tokens.fromJson(Map map) {
    return Tokens(e8s: map['e8s']);
  }

  final BigInt e8s;

  static Record idl = IDL.Record({'e8s': IDL.Nat64});

  Map<String, dynamic> toJson() {
    return {'e8s': e8s}..removeWhere((key, value) => value == null);
  }
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

  factory TransferArgs.fromJson(Map map) {
    return TransferArgs(
      to: map['to'] is String
          ? isHex(map['to'])
              ? (map['to'] as String).toU8a().toList()
              : Principal.fromText(map['to'] as String).toAccountId().toList()
          : (u8aToU8a(map['to']).toList()),
      fee: Tokens.fromJson(map['fee']),
      memo: map['memo'],
      amount: Tokens.fromJson(map['amount']),
      fromSubAccount: map['from_subaccount'] != null
          ? List<int>.from(map['from_subaccount'])
          : null,
      createdAtTime: map['created_at_time'] != null
          ? TimeStamp.fromJson(map['created_at_time'])
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
    'memo': _memo,
    'from_subaccount': IDL.Opt(SubAccount),
    'created_at_time': IDL.Opt(TimeStamp.idl),
    'amount': Tokens.idl,
  });

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'fee': fee.toJson(),
      'memo': memo,
      'from_subaccount': fromSubAccount != null ? [fromSubAccount] : [],
      'created_at_time': createdAtTime != null ? [createdAtTime!.toJson()] : [],
      'amount': amount.toJson()
    }..removeWhere((key, value) => value == null);
  }
}

const _blockIndex = IDL.Nat64;

class TransferError {
  const TransferError({
    this.txTooOld,
    this.badFee,
    this.txDuplicate,
    this.txCreatedInFuture,
    this.insufficientFunds,
  });

  factory TransferError.fromJson(Map map) {
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
    'TxDuplicate': IDL.Record({'duplicate_of': _blockIndex}),
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
    }..removeWhere((key, value) => value == null || value == false);
    if (res['TxCreatedInFuture'] != null && res['TxCreatedInFuture'] == true) {
      res.update('TxCreatedInFuture', (value) => null);
    }
    return res;
  }
}

class TransferResult {
  const TransferResult({this.ok, this.err});

  factory TransferResult.fromJson(Map map) {
    return TransferResult(
      ok: map['Ok'] != null ? (map['Ok']) : null,
      err: map['Err'] != null ? TransferError.fromJson(map['Err']) : null,
    );
  }

  final BigInt? ok;
  final TransferError? err;

  static Variant idl = IDL.Variant({
    'Ok': _blockIndex,
    'Err': TransferError.idl,
  });

  Map<String, dynamic> toJson() {
    return {'Ok': ok, 'Err': err?.toJson()}
      ..removeWhere((key, value) => value == null);
  }
}

final Service ledgerIdl = IDL.Service({
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
  'send_dfx': IDL.Func([SendArgs.idl], [_blockHeight], []),
  'transfer': IDL.Func([TransferArgs.idl], [TransferResult.idl], []),
});

class LedgerMethods {
  const LedgerMethods._();

  static const getBalance = 'account_balance_dfx';
  static const notify = 'notify_dfx';
  static const send = 'send_dfx';
  static const accountBalance = 'account_balance';
  static const transfer = 'transfer';
}

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
  final DateTime? createAtTime;

  int? get createAt => createAtTime?.millisecondsSinceEpoch;
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
      agent.getAgent().setIdentity(id);
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
    )!([AccountBalanceArgs(account: accountId).toJson()]);
    if (res != null) {
      return ICPTs.fromJson(res);
    }
    throw StateError('Request failed with the result: $res.');
  }

  static Future<Tokens> accountBalance({
    required AgentFactory agent,
    required String accountIdOrPrincipal,
    SignIdentity? identity,
  }) async {
    final ledgerInstance = Ledger.hook(agent)..setIdentity(identity);
    final accountId = isHex(accountIdOrPrincipal)
        ? accountIdOrPrincipal.toU8a().toList()
        : Principal.fromText(accountIdOrPrincipal).toAccountId().toList();
    final res = await ledgerInstance.agent.actor!
        .getFunc(LedgerMethods.accountBalance)!(
      [AccountBalanceArgsNew(account: accountId).toJson()],
    );
    if (res != null) {
      return Tokens.fromJson(res);
    }
    throw StateError('Request failed with the result: $res.');
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
    )!([SendArgs.fromJson(sendArgs).toJson()]);
    if (res != null) {
      return res as BigInt;
    }
    throw StateError('Request failed with the result: $res.');
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
    )!([TransferArgs.fromJson(sendArgs).toJson()]);
    if (res != null) {
      return TransferResult.fromJson(res as Map);
    }
    throw StateError('Request failed with the result: $res.');
  }
}
