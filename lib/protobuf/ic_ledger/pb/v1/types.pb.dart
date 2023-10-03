//
//  Generated code. Do not modify.
//  source: ic_ledger/pb/v1/types.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../ic_base_types/pb/v1/types.pb.dart' as $0;

/// Initialise the ledger canister
class LedgerInit extends $pb.GeneratedMessage {
  factory LedgerInit({
    AccountIdentifier? mintingAccount,
    $core.Iterable<Account>? initialValues,
    $0.PrincipalId? archiveCanister,
    $core.int? maxMessageSizeBytes,
  }) {
    final $result = create();
    if (mintingAccount != null) {
      $result.mintingAccount = mintingAccount;
    }
    if (initialValues != null) {
      $result.initialValues.addAll(initialValues);
    }
    if (archiveCanister != null) {
      $result.archiveCanister = archiveCanister;
    }
    if (maxMessageSizeBytes != null) {
      $result.maxMessageSizeBytes = maxMessageSizeBytes;
    }
    return $result;
  }
  LedgerInit._() : super();
  factory LedgerInit.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LedgerInit.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LedgerInit',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<AccountIdentifier>(1, _omitFieldNames ? '' : 'mintingAccount',
        subBuilder: AccountIdentifier.create)
    ..pc<Account>(2, _omitFieldNames ? '' : 'initialValues', $pb.PbFieldType.PM,
        subBuilder: Account.create)
    ..aOM<$0.PrincipalId>(3, _omitFieldNames ? '' : 'archiveCanister',
        subBuilder: $0.PrincipalId.create)
    ..a<$core.int>(
        4, _omitFieldNames ? '' : 'maxMessageSizeBytes', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LedgerInit clone() => LedgerInit()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LedgerInit copyWith(void Function(LedgerInit) updates) =>
      super.copyWith((message) => updates(message as LedgerInit)) as LedgerInit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LedgerInit create() => LedgerInit._();
  LedgerInit createEmptyInstance() => create();
  static $pb.PbList<LedgerInit> createRepeated() => $pb.PbList<LedgerInit>();
  @$core.pragma('dart2js:noInline')
  static LedgerInit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LedgerInit>(create);
  static LedgerInit? _defaultInstance;

  @$pb.TagNumber(1)
  AccountIdentifier get mintingAccount => $_getN(0);
  @$pb.TagNumber(1)
  set mintingAccount(AccountIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMintingAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearMintingAccount() => clearField(1);
  @$pb.TagNumber(1)
  AccountIdentifier ensureMintingAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Account> get initialValues => $_getList(1);

  @$pb.TagNumber(3)
  $0.PrincipalId get archiveCanister => $_getN(2);
  @$pb.TagNumber(3)
  set archiveCanister($0.PrincipalId v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasArchiveCanister() => $_has(2);
  @$pb.TagNumber(3)
  void clearArchiveCanister() => clearField(3);
  @$pb.TagNumber(3)
  $0.PrincipalId ensureArchiveCanister() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get maxMessageSizeBytes => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxMessageSizeBytes($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMaxMessageSizeBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxMessageSizeBytes() => clearField(4);
}

/// The format of values serialized to/from the stable memory during and upgrade
class LedgerUpgrade extends $pb.GeneratedMessage {
  factory LedgerUpgrade() => create();
  LedgerUpgrade._() : super();
  factory LedgerUpgrade.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LedgerUpgrade.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LedgerUpgrade',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LedgerUpgrade clone() => LedgerUpgrade()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LedgerUpgrade copyWith(void Function(LedgerUpgrade) updates) =>
      super.copyWith((message) => updates(message as LedgerUpgrade))
          as LedgerUpgrade;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LedgerUpgrade create() => LedgerUpgrade._();
  LedgerUpgrade createEmptyInstance() => create();
  static $pb.PbList<LedgerUpgrade> createRepeated() =>
      $pb.PbList<LedgerUpgrade>();
  @$core.pragma('dart2js:noInline')
  static LedgerUpgrade getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LedgerUpgrade>(create);
  static LedgerUpgrade? _defaultInstance;
}

/// Make a payment
class SendRequest extends $pb.GeneratedMessage {
  factory SendRequest({
    Memo? memo,
    Payment? payment,
    ICPTs? maxFee,
    Subaccount? fromSubaccount,
    AccountIdentifier? to,
    BlockHeight? createdAt,
    TimeStamp? createdAtTime,
  }) {
    final $result = create();
    if (memo != null) {
      $result.memo = memo;
    }
    if (payment != null) {
      $result.payment = payment;
    }
    if (maxFee != null) {
      $result.maxFee = maxFee;
    }
    if (fromSubaccount != null) {
      $result.fromSubaccount = fromSubaccount;
    }
    if (to != null) {
      $result.to = to;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (createdAtTime != null) {
      $result.createdAtTime = createdAtTime;
    }
    return $result;
  }
  SendRequest._() : super();
  factory SendRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SendRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<Memo>(1, _omitFieldNames ? '' : 'memo', subBuilder: Memo.create)
    ..aOM<Payment>(2, _omitFieldNames ? '' : 'payment',
        subBuilder: Payment.create)
    ..aOM<ICPTs>(3, _omitFieldNames ? '' : 'maxFee', subBuilder: ICPTs.create)
    ..aOM<Subaccount>(4, _omitFieldNames ? '' : 'fromSubaccount',
        subBuilder: Subaccount.create)
    ..aOM<AccountIdentifier>(5, _omitFieldNames ? '' : 'to',
        subBuilder: AccountIdentifier.create)
    ..aOM<BlockHeight>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: BlockHeight.create)
    ..aOM<TimeStamp>(7, _omitFieldNames ? '' : 'createdAtTime',
        subBuilder: TimeStamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SendRequest clone() => SendRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SendRequest copyWith(void Function(SendRequest) updates) =>
      super.copyWith((message) => updates(message as SendRequest))
          as SendRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendRequest create() => SendRequest._();
  SendRequest createEmptyInstance() => create();
  static $pb.PbList<SendRequest> createRepeated() => $pb.PbList<SendRequest>();
  @$core.pragma('dart2js:noInline')
  static SendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendRequest>(create);
  static SendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Memo get memo => $_getN(0);
  @$pb.TagNumber(1)
  set memo(Memo v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMemo() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemo() => clearField(1);
  @$pb.TagNumber(1)
  Memo ensureMemo() => $_ensure(0);

  @$pb.TagNumber(2)
  Payment get payment => $_getN(1);
  @$pb.TagNumber(2)
  set payment(Payment v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPayment() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayment() => clearField(2);
  @$pb.TagNumber(2)
  Payment ensurePayment() => $_ensure(1);

  @$pb.TagNumber(3)
  ICPTs get maxFee => $_getN(2);
  @$pb.TagNumber(3)
  set maxFee(ICPTs v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMaxFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxFee() => clearField(3);
  @$pb.TagNumber(3)
  ICPTs ensureMaxFee() => $_ensure(2);

  @$pb.TagNumber(4)
  Subaccount get fromSubaccount => $_getN(3);
  @$pb.TagNumber(4)
  set fromSubaccount(Subaccount v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFromSubaccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromSubaccount() => clearField(4);
  @$pb.TagNumber(4)
  Subaccount ensureFromSubaccount() => $_ensure(3);

  @$pb.TagNumber(5)
  AccountIdentifier get to => $_getN(4);
  @$pb.TagNumber(5)
  set to(AccountIdentifier v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => clearField(5);
  @$pb.TagNumber(5)
  AccountIdentifier ensureTo() => $_ensure(4);

  @$pb.TagNumber(6)
  BlockHeight get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt(BlockHeight v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);
  @$pb.TagNumber(6)
  BlockHeight ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  TimeStamp get createdAtTime => $_getN(6);
  @$pb.TagNumber(7)
  set createdAtTime(TimeStamp v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCreatedAtTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAtTime() => clearField(7);
  @$pb.TagNumber(7)
  TimeStamp ensureCreatedAtTime() => $_ensure(6);
}

class SendResponse extends $pb.GeneratedMessage {
  factory SendResponse({
    BlockHeight? resultingHeight,
  }) {
    final $result = create();
    if (resultingHeight != null) {
      $result.resultingHeight = resultingHeight;
    }
    return $result;
  }
  SendResponse._() : super();
  factory SendResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SendResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<BlockHeight>(1, _omitFieldNames ? '' : 'resultingHeight',
        subBuilder: BlockHeight.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SendResponse clone() => SendResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SendResponse copyWith(void Function(SendResponse) updates) =>
      super.copyWith((message) => updates(message as SendResponse))
          as SendResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendResponse create() => SendResponse._();
  SendResponse createEmptyInstance() => create();
  static $pb.PbList<SendResponse> createRepeated() =>
      $pb.PbList<SendResponse>();
  @$core.pragma('dart2js:noInline')
  static SendResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendResponse>(create);
  static SendResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BlockHeight get resultingHeight => $_getN(0);
  @$pb.TagNumber(1)
  set resultingHeight(BlockHeight v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasResultingHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearResultingHeight() => clearField(1);
  @$pb.TagNumber(1)
  BlockHeight ensureResultingHeight() => $_ensure(0);
}

/// Notify a canister that it has recieved a payment
class NotifyRequest extends $pb.GeneratedMessage {
  factory NotifyRequest({
    BlockHeight? blockHeight,
    ICPTs? maxFee,
    Subaccount? fromSubaccount,
    $0.PrincipalId? toCanister,
    Subaccount? toSubaccount,
  }) {
    final $result = create();
    if (blockHeight != null) {
      $result.blockHeight = blockHeight;
    }
    if (maxFee != null) {
      $result.maxFee = maxFee;
    }
    if (fromSubaccount != null) {
      $result.fromSubaccount = fromSubaccount;
    }
    if (toCanister != null) {
      $result.toCanister = toCanister;
    }
    if (toSubaccount != null) {
      $result.toSubaccount = toSubaccount;
    }
    return $result;
  }
  NotifyRequest._() : super();
  factory NotifyRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NotifyRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotifyRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<BlockHeight>(1, _omitFieldNames ? '' : 'blockHeight',
        subBuilder: BlockHeight.create)
    ..aOM<ICPTs>(2, _omitFieldNames ? '' : 'maxFee', subBuilder: ICPTs.create)
    ..aOM<Subaccount>(3, _omitFieldNames ? '' : 'fromSubaccount',
        subBuilder: Subaccount.create)
    ..aOM<$0.PrincipalId>(4, _omitFieldNames ? '' : 'toCanister',
        subBuilder: $0.PrincipalId.create)
    ..aOM<Subaccount>(5, _omitFieldNames ? '' : 'toSubaccount',
        subBuilder: Subaccount.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NotifyRequest clone() => NotifyRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NotifyRequest copyWith(void Function(NotifyRequest) updates) =>
      super.copyWith((message) => updates(message as NotifyRequest))
          as NotifyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifyRequest create() => NotifyRequest._();
  NotifyRequest createEmptyInstance() => create();
  static $pb.PbList<NotifyRequest> createRepeated() =>
      $pb.PbList<NotifyRequest>();
  @$core.pragma('dart2js:noInline')
  static NotifyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotifyRequest>(create);
  static NotifyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BlockHeight get blockHeight => $_getN(0);
  @$pb.TagNumber(1)
  set blockHeight(BlockHeight v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlockHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockHeight() => clearField(1);
  @$pb.TagNumber(1)
  BlockHeight ensureBlockHeight() => $_ensure(0);

  @$pb.TagNumber(2)
  ICPTs get maxFee => $_getN(1);
  @$pb.TagNumber(2)
  set maxFee(ICPTs v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMaxFee() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxFee() => clearField(2);
  @$pb.TagNumber(2)
  ICPTs ensureMaxFee() => $_ensure(1);

  @$pb.TagNumber(3)
  Subaccount get fromSubaccount => $_getN(2);
  @$pb.TagNumber(3)
  set fromSubaccount(Subaccount v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFromSubaccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromSubaccount() => clearField(3);
  @$pb.TagNumber(3)
  Subaccount ensureFromSubaccount() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.PrincipalId get toCanister => $_getN(3);
  @$pb.TagNumber(4)
  set toCanister($0.PrincipalId v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasToCanister() => $_has(3);
  @$pb.TagNumber(4)
  void clearToCanister() => clearField(4);
  @$pb.TagNumber(4)
  $0.PrincipalId ensureToCanister() => $_ensure(3);

  @$pb.TagNumber(5)
  Subaccount get toSubaccount => $_getN(4);
  @$pb.TagNumber(5)
  set toSubaccount(Subaccount v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasToSubaccount() => $_has(4);
  @$pb.TagNumber(5)
  void clearToSubaccount() => clearField(5);
  @$pb.TagNumber(5)
  Subaccount ensureToSubaccount() => $_ensure(4);
}

class NotifyResponse extends $pb.GeneratedMessage {
  factory NotifyResponse() => create();
  NotifyResponse._() : super();
  factory NotifyResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NotifyResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotifyResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NotifyResponse clone() => NotifyResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NotifyResponse copyWith(void Function(NotifyResponse) updates) =>
      super.copyWith((message) => updates(message as NotifyResponse))
          as NotifyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifyResponse create() => NotifyResponse._();
  NotifyResponse createEmptyInstance() => create();
  static $pb.PbList<NotifyResponse> createRepeated() =>
      $pb.PbList<NotifyResponse>();
  @$core.pragma('dart2js:noInline')
  static NotifyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotifyResponse>(create);
  static NotifyResponse? _defaultInstance;
}

class TransactionNotificationRequest extends $pb.GeneratedMessage {
  factory TransactionNotificationRequest({
    $0.PrincipalId? from,
    Subaccount? fromSubaccount,
    $0.PrincipalId? to,
    Subaccount? toSubaccount,
    BlockHeight? blockHeight,
    ICPTs? amount,
    Memo? memo,
  }) {
    final $result = create();
    if (from != null) {
      $result.from = from;
    }
    if (fromSubaccount != null) {
      $result.fromSubaccount = fromSubaccount;
    }
    if (to != null) {
      $result.to = to;
    }
    if (toSubaccount != null) {
      $result.toSubaccount = toSubaccount;
    }
    if (blockHeight != null) {
      $result.blockHeight = blockHeight;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (memo != null) {
      $result.memo = memo;
    }
    return $result;
  }
  TransactionNotificationRequest._() : super();
  factory TransactionNotificationRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TransactionNotificationRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransactionNotificationRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<$0.PrincipalId>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.PrincipalId.create)
    ..aOM<Subaccount>(2, _omitFieldNames ? '' : 'fromSubaccount',
        subBuilder: Subaccount.create)
    ..aOM<$0.PrincipalId>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.PrincipalId.create)
    ..aOM<Subaccount>(4, _omitFieldNames ? '' : 'toSubaccount',
        subBuilder: Subaccount.create)
    ..aOM<BlockHeight>(5, _omitFieldNames ? '' : 'blockHeight',
        subBuilder: BlockHeight.create)
    ..aOM<ICPTs>(6, _omitFieldNames ? '' : 'amount', subBuilder: ICPTs.create)
    ..aOM<Memo>(7, _omitFieldNames ? '' : 'memo', subBuilder: Memo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TransactionNotificationRequest clone() =>
      TransactionNotificationRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TransactionNotificationRequest copyWith(
          void Function(TransactionNotificationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TransactionNotificationRequest))
          as TransactionNotificationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransactionNotificationRequest create() =>
      TransactionNotificationRequest._();
  TransactionNotificationRequest createEmptyInstance() => create();
  static $pb.PbList<TransactionNotificationRequest> createRepeated() =>
      $pb.PbList<TransactionNotificationRequest>();
  @$core.pragma('dart2js:noInline')
  static TransactionNotificationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransactionNotificationRequest>(create);
  static TransactionNotificationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.PrincipalId get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($0.PrincipalId v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => clearField(1);
  @$pb.TagNumber(1)
  $0.PrincipalId ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  Subaccount get fromSubaccount => $_getN(1);
  @$pb.TagNumber(2)
  set fromSubaccount(Subaccount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFromSubaccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromSubaccount() => clearField(2);
  @$pb.TagNumber(2)
  Subaccount ensureFromSubaccount() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.PrincipalId get to => $_getN(2);
  @$pb.TagNumber(3)
  set to($0.PrincipalId v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => clearField(3);
  @$pb.TagNumber(3)
  $0.PrincipalId ensureTo() => $_ensure(2);

  @$pb.TagNumber(4)
  Subaccount get toSubaccount => $_getN(3);
  @$pb.TagNumber(4)
  set toSubaccount(Subaccount v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasToSubaccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearToSubaccount() => clearField(4);
  @$pb.TagNumber(4)
  Subaccount ensureToSubaccount() => $_ensure(3);

  @$pb.TagNumber(5)
  BlockHeight get blockHeight => $_getN(4);
  @$pb.TagNumber(5)
  set blockHeight(BlockHeight v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBlockHeight() => $_has(4);
  @$pb.TagNumber(5)
  void clearBlockHeight() => clearField(5);
  @$pb.TagNumber(5)
  BlockHeight ensureBlockHeight() => $_ensure(4);

  @$pb.TagNumber(6)
  ICPTs get amount => $_getN(5);
  @$pb.TagNumber(6)
  set amount(ICPTs v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmount() => clearField(6);
  @$pb.TagNumber(6)
  ICPTs ensureAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  Memo get memo => $_getN(6);
  @$pb.TagNumber(7)
  set memo(Memo v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasMemo() => $_has(6);
  @$pb.TagNumber(7)
  void clearMemo() => clearField(7);
  @$pb.TagNumber(7)
  Memo ensureMemo() => $_ensure(6);
}

class TransactionNotificationResponse extends $pb.GeneratedMessage {
  factory TransactionNotificationResponse({
    $core.List<$core.int>? response,
  }) {
    final $result = create();
    if (response != null) {
      $result.response = response;
    }
    return $result;
  }
  TransactionNotificationResponse._() : super();
  factory TransactionNotificationResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TransactionNotificationResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransactionNotificationResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'response', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TransactionNotificationResponse clone() =>
      TransactionNotificationResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TransactionNotificationResponse copyWith(
          void Function(TransactionNotificationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TransactionNotificationResponse))
          as TransactionNotificationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransactionNotificationResponse create() =>
      TransactionNotificationResponse._();
  TransactionNotificationResponse createEmptyInstance() => create();
  static $pb.PbList<TransactionNotificationResponse> createRepeated() =>
      $pb.PbList<TransactionNotificationResponse>();
  @$core.pragma('dart2js:noInline')
  static TransactionNotificationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransactionNotificationResponse>(
          create);
  static TransactionNotificationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get response => $_getN(0);
  @$pb.TagNumber(1)
  set response($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearResponse() => clearField(1);
}

enum CyclesNotificationResponse_Response {
  createdCanisterId,
  refund,
  toppedUp,
  notSet
}

class CyclesNotificationResponse extends $pb.GeneratedMessage {
  factory CyclesNotificationResponse({
    $0.PrincipalId? createdCanisterId,
    Refund? refund,
    ToppedUp? toppedUp,
  }) {
    final $result = create();
    if (createdCanisterId != null) {
      $result.createdCanisterId = createdCanisterId;
    }
    if (refund != null) {
      $result.refund = refund;
    }
    if (toppedUp != null) {
      $result.toppedUp = toppedUp;
    }
    return $result;
  }
  CyclesNotificationResponse._() : super();
  factory CyclesNotificationResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CyclesNotificationResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CyclesNotificationResponse_Response>
      _CyclesNotificationResponse_ResponseByTag = {
    1: CyclesNotificationResponse_Response.createdCanisterId,
    2: CyclesNotificationResponse_Response.refund,
    3: CyclesNotificationResponse_Response.toppedUp,
    0: CyclesNotificationResponse_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CyclesNotificationResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<$0.PrincipalId>(1, _omitFieldNames ? '' : 'createdCanisterId',
        subBuilder: $0.PrincipalId.create)
    ..aOM<Refund>(2, _omitFieldNames ? '' : 'refund', subBuilder: Refund.create)
    ..aOM<ToppedUp>(3, _omitFieldNames ? '' : 'toppedUp',
        subBuilder: ToppedUp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CyclesNotificationResponse clone() =>
      CyclesNotificationResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CyclesNotificationResponse copyWith(
          void Function(CyclesNotificationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CyclesNotificationResponse))
          as CyclesNotificationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CyclesNotificationResponse create() => CyclesNotificationResponse._();
  CyclesNotificationResponse createEmptyInstance() => create();
  static $pb.PbList<CyclesNotificationResponse> createRepeated() =>
      $pb.PbList<CyclesNotificationResponse>();
  @$core.pragma('dart2js:noInline')
  static CyclesNotificationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CyclesNotificationResponse>(create);
  static CyclesNotificationResponse? _defaultInstance;

  CyclesNotificationResponse_Response whichResponse() =>
      _CyclesNotificationResponse_ResponseByTag[$_whichOneof(0)]!;
  void clearResponse() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.PrincipalId get createdCanisterId => $_getN(0);
  @$pb.TagNumber(1)
  set createdCanisterId($0.PrincipalId v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCreatedCanisterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreatedCanisterId() => clearField(1);
  @$pb.TagNumber(1)
  $0.PrincipalId ensureCreatedCanisterId() => $_ensure(0);

  @$pb.TagNumber(2)
  Refund get refund => $_getN(1);
  @$pb.TagNumber(2)
  set refund(Refund v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRefund() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefund() => clearField(2);
  @$pb.TagNumber(2)
  Refund ensureRefund() => $_ensure(1);

  @$pb.TagNumber(3)
  ToppedUp get toppedUp => $_getN(2);
  @$pb.TagNumber(3)
  set toppedUp(ToppedUp v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasToppedUp() => $_has(2);
  @$pb.TagNumber(3)
  void clearToppedUp() => clearField(3);
  @$pb.TagNumber(3)
  ToppedUp ensureToppedUp() => $_ensure(2);
}

/// Get the balance of an account
class AccountBalanceRequest extends $pb.GeneratedMessage {
  factory AccountBalanceRequest({
    AccountIdentifier? account,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  AccountBalanceRequest._() : super();
  factory AccountBalanceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AccountBalanceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountBalanceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<AccountIdentifier>(1, _omitFieldNames ? '' : 'account',
        subBuilder: AccountIdentifier.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AccountBalanceRequest clone() =>
      AccountBalanceRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AccountBalanceRequest copyWith(
          void Function(AccountBalanceRequest) updates) =>
      super.copyWith((message) => updates(message as AccountBalanceRequest))
          as AccountBalanceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountBalanceRequest create() => AccountBalanceRequest._();
  AccountBalanceRequest createEmptyInstance() => create();
  static $pb.PbList<AccountBalanceRequest> createRepeated() =>
      $pb.PbList<AccountBalanceRequest>();
  @$core.pragma('dart2js:noInline')
  static AccountBalanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountBalanceRequest>(create);
  static AccountBalanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AccountIdentifier get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(AccountIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  AccountIdentifier ensureAccount() => $_ensure(0);
}

class AccountBalanceResponse extends $pb.GeneratedMessage {
  factory AccountBalanceResponse({
    ICPTs? balance,
  }) {
    final $result = create();
    if (balance != null) {
      $result.balance = balance;
    }
    return $result;
  }
  AccountBalanceResponse._() : super();
  factory AccountBalanceResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AccountBalanceResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountBalanceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<ICPTs>(1, _omitFieldNames ? '' : 'balance', subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AccountBalanceResponse clone() =>
      AccountBalanceResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AccountBalanceResponse copyWith(
          void Function(AccountBalanceResponse) updates) =>
      super.copyWith((message) => updates(message as AccountBalanceResponse))
          as AccountBalanceResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountBalanceResponse create() => AccountBalanceResponse._();
  AccountBalanceResponse createEmptyInstance() => create();
  static $pb.PbList<AccountBalanceResponse> createRepeated() =>
      $pb.PbList<AccountBalanceResponse>();
  @$core.pragma('dart2js:noInline')
  static AccountBalanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountBalanceResponse>(create);
  static AccountBalanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ICPTs get balance => $_getN(0);
  @$pb.TagNumber(1)
  set balance(ICPTs v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => clearField(1);
  @$pb.TagNumber(1)
  ICPTs ensureBalance() => $_ensure(0);
}

/// Get the length of the chain with a certification
class TipOfChainRequest extends $pb.GeneratedMessage {
  factory TipOfChainRequest() => create();
  TipOfChainRequest._() : super();
  factory TipOfChainRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TipOfChainRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TipOfChainRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TipOfChainRequest clone() => TipOfChainRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TipOfChainRequest copyWith(void Function(TipOfChainRequest) updates) =>
      super.copyWith((message) => updates(message as TipOfChainRequest))
          as TipOfChainRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TipOfChainRequest create() => TipOfChainRequest._();
  TipOfChainRequest createEmptyInstance() => create();
  static $pb.PbList<TipOfChainRequest> createRepeated() =>
      $pb.PbList<TipOfChainRequest>();
  @$core.pragma('dart2js:noInline')
  static TipOfChainRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TipOfChainRequest>(create);
  static TipOfChainRequest? _defaultInstance;
}

class TipOfChainResponse extends $pb.GeneratedMessage {
  factory TipOfChainResponse({
    Certification? certification,
    BlockHeight? chainLength,
  }) {
    final $result = create();
    if (certification != null) {
      $result.certification = certification;
    }
    if (chainLength != null) {
      $result.chainLength = chainLength;
    }
    return $result;
  }
  TipOfChainResponse._() : super();
  factory TipOfChainResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TipOfChainResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TipOfChainResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<Certification>(1, _omitFieldNames ? '' : 'certification',
        subBuilder: Certification.create)
    ..aOM<BlockHeight>(2, _omitFieldNames ? '' : 'chainLength',
        subBuilder: BlockHeight.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TipOfChainResponse clone() => TipOfChainResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TipOfChainResponse copyWith(void Function(TipOfChainResponse) updates) =>
      super.copyWith((message) => updates(message as TipOfChainResponse))
          as TipOfChainResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TipOfChainResponse create() => TipOfChainResponse._();
  TipOfChainResponse createEmptyInstance() => create();
  static $pb.PbList<TipOfChainResponse> createRepeated() =>
      $pb.PbList<TipOfChainResponse>();
  @$core.pragma('dart2js:noInline')
  static TipOfChainResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TipOfChainResponse>(create);
  static TipOfChainResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Certification get certification => $_getN(0);
  @$pb.TagNumber(1)
  set certification(Certification v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCertification() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertification() => clearField(1);
  @$pb.TagNumber(1)
  Certification ensureCertification() => $_ensure(0);

  @$pb.TagNumber(2)
  BlockHeight get chainLength => $_getN(1);
  @$pb.TagNumber(2)
  set chainLength(BlockHeight v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasChainLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearChainLength() => clearField(2);
  @$pb.TagNumber(2)
  BlockHeight ensureChainLength() => $_ensure(1);
}

/// How many ICPTs are there not in the minting account
class TotalSupplyRequest extends $pb.GeneratedMessage {
  factory TotalSupplyRequest() => create();
  TotalSupplyRequest._() : super();
  factory TotalSupplyRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TotalSupplyRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TotalSupplyRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TotalSupplyRequest clone() => TotalSupplyRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TotalSupplyRequest copyWith(void Function(TotalSupplyRequest) updates) =>
      super.copyWith((message) => updates(message as TotalSupplyRequest))
          as TotalSupplyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TotalSupplyRequest create() => TotalSupplyRequest._();
  TotalSupplyRequest createEmptyInstance() => create();
  static $pb.PbList<TotalSupplyRequest> createRepeated() =>
      $pb.PbList<TotalSupplyRequest>();
  @$core.pragma('dart2js:noInline')
  static TotalSupplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TotalSupplyRequest>(create);
  static TotalSupplyRequest? _defaultInstance;
}

class TotalSupplyResponse extends $pb.GeneratedMessage {
  factory TotalSupplyResponse({
    ICPTs? totalSupply,
  }) {
    final $result = create();
    if (totalSupply != null) {
      $result.totalSupply = totalSupply;
    }
    return $result;
  }
  TotalSupplyResponse._() : super();
  factory TotalSupplyResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TotalSupplyResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TotalSupplyResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<ICPTs>(1, _omitFieldNames ? '' : 'totalSupply',
        subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TotalSupplyResponse clone() => TotalSupplyResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TotalSupplyResponse copyWith(void Function(TotalSupplyResponse) updates) =>
      super.copyWith((message) => updates(message as TotalSupplyResponse))
          as TotalSupplyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TotalSupplyResponse create() => TotalSupplyResponse._();
  TotalSupplyResponse createEmptyInstance() => create();
  static $pb.PbList<TotalSupplyResponse> createRepeated() =>
      $pb.PbList<TotalSupplyResponse>();
  @$core.pragma('dart2js:noInline')
  static TotalSupplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TotalSupplyResponse>(create);
  static TotalSupplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ICPTs get totalSupply => $_getN(0);
  @$pb.TagNumber(1)
  set totalSupply(ICPTs v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTotalSupply() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalSupply() => clearField(1);
  @$pb.TagNumber(1)
  ICPTs ensureTotalSupply() => $_ensure(0);
}

/// Archive any blocks older than this
class LedgerArchiveRequest extends $pb.GeneratedMessage {
  factory LedgerArchiveRequest({
    TimeStamp? timestamp,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  LedgerArchiveRequest._() : super();
  factory LedgerArchiveRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LedgerArchiveRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LedgerArchiveRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<TimeStamp>(1, _omitFieldNames ? '' : 'timestamp',
        subBuilder: TimeStamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LedgerArchiveRequest clone() =>
      LedgerArchiveRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LedgerArchiveRequest copyWith(void Function(LedgerArchiveRequest) updates) =>
      super.copyWith((message) => updates(message as LedgerArchiveRequest))
          as LedgerArchiveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LedgerArchiveRequest create() => LedgerArchiveRequest._();
  LedgerArchiveRequest createEmptyInstance() => create();
  static $pb.PbList<LedgerArchiveRequest> createRepeated() =>
      $pb.PbList<LedgerArchiveRequest>();
  @$core.pragma('dart2js:noInline')
  static LedgerArchiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LedgerArchiveRequest>(create);
  static LedgerArchiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  TimeStamp get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp(TimeStamp v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);
  @$pb.TagNumber(1)
  TimeStamp ensureTimestamp() => $_ensure(0);
}

/// Get a single block
class BlockRequest extends $pb.GeneratedMessage {
  factory BlockRequest({
    $fixnum.Int64? blockHeight,
  }) {
    final $result = create();
    if (blockHeight != null) {
      $result.blockHeight = blockHeight;
    }
    return $result;
  }
  BlockRequest._() : super();
  factory BlockRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BlockRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'blockHeight', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BlockRequest clone() => BlockRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BlockRequest copyWith(void Function(BlockRequest) updates) =>
      super.copyWith((message) => updates(message as BlockRequest))
          as BlockRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockRequest create() => BlockRequest._();
  BlockRequest createEmptyInstance() => create();
  static $pb.PbList<BlockRequest> createRepeated() =>
      $pb.PbList<BlockRequest>();
  @$core.pragma('dart2js:noInline')
  static BlockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockRequest>(create);
  static BlockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get blockHeight => $_getI64(0);
  @$pb.TagNumber(1)
  set blockHeight($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlockHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockHeight() => clearField(1);
}

class EncodedBlock extends $pb.GeneratedMessage {
  factory EncodedBlock({
    $core.List<$core.int>? block,
  }) {
    final $result = create();
    if (block != null) {
      $result.block = block;
    }
    return $result;
  }
  EncodedBlock._() : super();
  factory EncodedBlock.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EncodedBlock.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EncodedBlock',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'block', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  EncodedBlock clone() => EncodedBlock()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  EncodedBlock copyWith(void Function(EncodedBlock) updates) =>
      super.copyWith((message) => updates(message as EncodedBlock))
          as EncodedBlock;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EncodedBlock create() => EncodedBlock._();
  EncodedBlock createEmptyInstance() => create();
  static $pb.PbList<EncodedBlock> createRepeated() =>
      $pb.PbList<EncodedBlock>();
  @$core.pragma('dart2js:noInline')
  static EncodedBlock getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncodedBlock>(create);
  static EncodedBlock? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get block => $_getN(0);
  @$pb.TagNumber(1)
  set block($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlock() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlock() => clearField(1);
}

enum BlockResponse_BlockContent { block, canisterId, notSet }

class BlockResponse extends $pb.GeneratedMessage {
  factory BlockResponse({
    EncodedBlock? block,
    $0.PrincipalId? canisterId,
  }) {
    final $result = create();
    if (block != null) {
      $result.block = block;
    }
    if (canisterId != null) {
      $result.canisterId = canisterId;
    }
    return $result;
  }
  BlockResponse._() : super();
  factory BlockResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BlockResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, BlockResponse_BlockContent>
      _BlockResponse_BlockContentByTag = {
    1: BlockResponse_BlockContent.block,
    2: BlockResponse_BlockContent.canisterId,
    0: BlockResponse_BlockContent.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<EncodedBlock>(1, _omitFieldNames ? '' : 'block',
        subBuilder: EncodedBlock.create)
    ..aOM<$0.PrincipalId>(2, _omitFieldNames ? '' : 'canisterId',
        subBuilder: $0.PrincipalId.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BlockResponse clone() => BlockResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BlockResponse copyWith(void Function(BlockResponse) updates) =>
      super.copyWith((message) => updates(message as BlockResponse))
          as BlockResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockResponse create() => BlockResponse._();
  BlockResponse createEmptyInstance() => create();
  static $pb.PbList<BlockResponse> createRepeated() =>
      $pb.PbList<BlockResponse>();
  @$core.pragma('dart2js:noInline')
  static BlockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockResponse>(create);
  static BlockResponse? _defaultInstance;

  BlockResponse_BlockContent whichBlockContent() =>
      _BlockResponse_BlockContentByTag[$_whichOneof(0)]!;
  void clearBlockContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  EncodedBlock get block => $_getN(0);
  @$pb.TagNumber(1)
  set block(EncodedBlock v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlock() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlock() => clearField(1);
  @$pb.TagNumber(1)
  EncodedBlock ensureBlock() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.PrincipalId get canisterId => $_getN(1);
  @$pb.TagNumber(2)
  set canisterId($0.PrincipalId v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCanisterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanisterId() => clearField(2);
  @$pb.TagNumber(2)
  $0.PrincipalId ensureCanisterId() => $_ensure(1);
}

/// Get a set of blocks
class GetBlocksRequest extends $pb.GeneratedMessage {
  factory GetBlocksRequest({
    $fixnum.Int64? start,
    $fixnum.Int64? length,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (length != null) {
      $result.length = length;
    }
    return $result;
  }
  GetBlocksRequest._() : super();
  factory GetBlocksRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetBlocksRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBlocksRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'start', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'length', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetBlocksRequest clone() => GetBlocksRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetBlocksRequest copyWith(void Function(GetBlocksRequest) updates) =>
      super.copyWith((message) => updates(message as GetBlocksRequest))
          as GetBlocksRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBlocksRequest create() => GetBlocksRequest._();
  GetBlocksRequest createEmptyInstance() => create();
  static $pb.PbList<GetBlocksRequest> createRepeated() =>
      $pb.PbList<GetBlocksRequest>();
  @$core.pragma('dart2js:noInline')
  static GetBlocksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBlocksRequest>(create);
  static GetBlocksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get length => $_getI64(1);
  @$pb.TagNumber(2)
  set length($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearLength() => clearField(2);
}

class Refund extends $pb.GeneratedMessage {
  factory Refund({
    BlockHeight? refund,
    $core.String? error,
  }) {
    final $result = create();
    if (refund != null) {
      $result.refund = refund;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  Refund._() : super();
  factory Refund.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Refund.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Refund',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<BlockHeight>(2, _omitFieldNames ? '' : 'refund',
        subBuilder: BlockHeight.create)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Refund clone() => Refund()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Refund copyWith(void Function(Refund) updates) =>
      super.copyWith((message) => updates(message as Refund)) as Refund;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Refund create() => Refund._();
  Refund createEmptyInstance() => create();
  static $pb.PbList<Refund> createRepeated() => $pb.PbList<Refund>();
  @$core.pragma('dart2js:noInline')
  static Refund getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Refund>(create);
  static Refund? _defaultInstance;

  @$pb.TagNumber(2)
  BlockHeight get refund => $_getN(0);
  @$pb.TagNumber(2)
  set refund(BlockHeight v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRefund() => $_has(0);
  @$pb.TagNumber(2)
  void clearRefund() => clearField(2);
  @$pb.TagNumber(2)
  BlockHeight ensureRefund() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(3)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class ToppedUp extends $pb.GeneratedMessage {
  factory ToppedUp() => create();
  ToppedUp._() : super();
  factory ToppedUp.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ToppedUp.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToppedUp',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ToppedUp clone() => ToppedUp()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ToppedUp copyWith(void Function(ToppedUp) updates) =>
      super.copyWith((message) => updates(message as ToppedUp)) as ToppedUp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToppedUp create() => ToppedUp._();
  ToppedUp createEmptyInstance() => create();
  static $pb.PbList<ToppedUp> createRepeated() => $pb.PbList<ToppedUp>();
  @$core.pragma('dart2js:noInline')
  static ToppedUp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToppedUp>(create);
  static ToppedUp? _defaultInstance;
}

class EncodedBlocks extends $pb.GeneratedMessage {
  factory EncodedBlocks({
    $core.Iterable<EncodedBlock>? blocks,
  }) {
    final $result = create();
    if (blocks != null) {
      $result.blocks.addAll(blocks);
    }
    return $result;
  }
  EncodedBlocks._() : super();
  factory EncodedBlocks.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EncodedBlocks.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EncodedBlocks',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..pc<EncodedBlock>(1, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.PM,
        subBuilder: EncodedBlock.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  EncodedBlocks clone() => EncodedBlocks()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  EncodedBlocks copyWith(void Function(EncodedBlocks) updates) =>
      super.copyWith((message) => updates(message as EncodedBlocks))
          as EncodedBlocks;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EncodedBlocks create() => EncodedBlocks._();
  EncodedBlocks createEmptyInstance() => create();
  static $pb.PbList<EncodedBlocks> createRepeated() =>
      $pb.PbList<EncodedBlocks>();
  @$core.pragma('dart2js:noInline')
  static EncodedBlocks getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncodedBlocks>(create);
  static EncodedBlocks? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<EncodedBlock> get blocks => $_getList(0);
}

enum GetBlocksResponse_GetBlocksContent { blocks, error, notSet }

class GetBlocksResponse extends $pb.GeneratedMessage {
  factory GetBlocksResponse({
    EncodedBlocks? blocks,
    $core.String? error,
  }) {
    final $result = create();
    if (blocks != null) {
      $result.blocks = blocks;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  GetBlocksResponse._() : super();
  factory GetBlocksResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetBlocksResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GetBlocksResponse_GetBlocksContent>
      _GetBlocksResponse_GetBlocksContentByTag = {
    1: GetBlocksResponse_GetBlocksContent.blocks,
    2: GetBlocksResponse_GetBlocksContent.error,
    0: GetBlocksResponse_GetBlocksContent.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBlocksResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<EncodedBlocks>(1, _omitFieldNames ? '' : 'blocks',
        subBuilder: EncodedBlocks.create)
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetBlocksResponse clone() => GetBlocksResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetBlocksResponse copyWith(void Function(GetBlocksResponse) updates) =>
      super.copyWith((message) => updates(message as GetBlocksResponse))
          as GetBlocksResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBlocksResponse create() => GetBlocksResponse._();
  GetBlocksResponse createEmptyInstance() => create();
  static $pb.PbList<GetBlocksResponse> createRepeated() =>
      $pb.PbList<GetBlocksResponse>();
  @$core.pragma('dart2js:noInline')
  static GetBlocksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBlocksResponse>(create);
  static GetBlocksResponse? _defaultInstance;

  GetBlocksResponse_GetBlocksContent whichGetBlocksContent() =>
      _GetBlocksResponse_GetBlocksContentByTag[$_whichOneof(0)]!;
  void clearGetBlocksContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  EncodedBlocks get blocks => $_getN(0);
  @$pb.TagNumber(1)
  set blocks(EncodedBlocks v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlocks() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlocks() => clearField(1);
  @$pb.TagNumber(1)
  EncodedBlocks ensureBlocks() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
}

/// Iterate through blocks
class IterBlocksRequest extends $pb.GeneratedMessage {
  factory IterBlocksRequest({
    $fixnum.Int64? start,
    $fixnum.Int64? length,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (length != null) {
      $result.length = length;
    }
    return $result;
  }
  IterBlocksRequest._() : super();
  factory IterBlocksRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IterBlocksRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IterBlocksRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'start', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'length', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  IterBlocksRequest clone() => IterBlocksRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  IterBlocksRequest copyWith(void Function(IterBlocksRequest) updates) =>
      super.copyWith((message) => updates(message as IterBlocksRequest))
          as IterBlocksRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IterBlocksRequest create() => IterBlocksRequest._();
  IterBlocksRequest createEmptyInstance() => create();
  static $pb.PbList<IterBlocksRequest> createRepeated() =>
      $pb.PbList<IterBlocksRequest>();
  @$core.pragma('dart2js:noInline')
  static IterBlocksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IterBlocksRequest>(create);
  static IterBlocksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get length => $_getI64(1);
  @$pb.TagNumber(2)
  set length($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearLength() => clearField(2);
}

class IterBlocksResponse extends $pb.GeneratedMessage {
  factory IterBlocksResponse({
    $core.Iterable<EncodedBlock>? blocks,
  }) {
    final $result = create();
    if (blocks != null) {
      $result.blocks.addAll(blocks);
    }
    return $result;
  }
  IterBlocksResponse._() : super();
  factory IterBlocksResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IterBlocksResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IterBlocksResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..pc<EncodedBlock>(1, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.PM,
        subBuilder: EncodedBlock.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  IterBlocksResponse clone() => IterBlocksResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  IterBlocksResponse copyWith(void Function(IterBlocksResponse) updates) =>
      super.copyWith((message) => updates(message as IterBlocksResponse))
          as IterBlocksResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IterBlocksResponse create() => IterBlocksResponse._();
  IterBlocksResponse createEmptyInstance() => create();
  static $pb.PbList<IterBlocksResponse> createRepeated() =>
      $pb.PbList<IterBlocksResponse>();
  @$core.pragma('dart2js:noInline')
  static IterBlocksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IterBlocksResponse>(create);
  static IterBlocksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<EncodedBlock> get blocks => $_getList(0);
}

class ArchiveIndexEntry extends $pb.GeneratedMessage {
  factory ArchiveIndexEntry({
    $fixnum.Int64? heightFrom,
    $fixnum.Int64? heightTo,
    $0.PrincipalId? canisterId,
  }) {
    final $result = create();
    if (heightFrom != null) {
      $result.heightFrom = heightFrom;
    }
    if (heightTo != null) {
      $result.heightTo = heightTo;
    }
    if (canisterId != null) {
      $result.canisterId = canisterId;
    }
    return $result;
  }
  ArchiveIndexEntry._() : super();
  factory ArchiveIndexEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ArchiveIndexEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveIndexEntry',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'heightFrom', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'heightTo', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.PrincipalId>(3, _omitFieldNames ? '' : 'canisterId',
        subBuilder: $0.PrincipalId.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ArchiveIndexEntry clone() => ArchiveIndexEntry()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ArchiveIndexEntry copyWith(void Function(ArchiveIndexEntry) updates) =>
      super.copyWith((message) => updates(message as ArchiveIndexEntry))
          as ArchiveIndexEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveIndexEntry create() => ArchiveIndexEntry._();
  ArchiveIndexEntry createEmptyInstance() => create();
  static $pb.PbList<ArchiveIndexEntry> createRepeated() =>
      $pb.PbList<ArchiveIndexEntry>();
  @$core.pragma('dart2js:noInline')
  static ArchiveIndexEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveIndexEntry>(create);
  static ArchiveIndexEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get heightFrom => $_getI64(0);
  @$pb.TagNumber(1)
  set heightFrom($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasHeightFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeightFrom() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get heightTo => $_getI64(1);
  @$pb.TagNumber(2)
  set heightTo($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasHeightTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeightTo() => clearField(2);

  @$pb.TagNumber(3)
  $0.PrincipalId get canisterId => $_getN(2);
  @$pb.TagNumber(3)
  set canisterId($0.PrincipalId v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCanisterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanisterId() => clearField(3);
  @$pb.TagNumber(3)
  $0.PrincipalId ensureCanisterId() => $_ensure(2);
}

class ArchiveIndexResponse extends $pb.GeneratedMessage {
  factory ArchiveIndexResponse({
    $core.Iterable<ArchiveIndexEntry>? entries,
  }) {
    final $result = create();
    if (entries != null) {
      $result.entries.addAll(entries);
    }
    return $result;
  }
  ArchiveIndexResponse._() : super();
  factory ArchiveIndexResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ArchiveIndexResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveIndexResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..pc<ArchiveIndexEntry>(
        1, _omitFieldNames ? '' : 'entries', $pb.PbFieldType.PM,
        subBuilder: ArchiveIndexEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ArchiveIndexResponse clone() =>
      ArchiveIndexResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ArchiveIndexResponse copyWith(void Function(ArchiveIndexResponse) updates) =>
      super.copyWith((message) => updates(message as ArchiveIndexResponse))
          as ArchiveIndexResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveIndexResponse create() => ArchiveIndexResponse._();
  ArchiveIndexResponse createEmptyInstance() => create();
  static $pb.PbList<ArchiveIndexResponse> createRepeated() =>
      $pb.PbList<ArchiveIndexResponse>();
  @$core.pragma('dart2js:noInline')
  static ArchiveIndexResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveIndexResponse>(create);
  static ArchiveIndexResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ArchiveIndexEntry> get entries => $_getList(0);
}

/// * Archive canister *
/// Init the archive canister
class ArchiveInit extends $pb.GeneratedMessage {
  factory ArchiveInit({
    $core.int? nodeMaxMemorySizeBytes,
    $core.int? maxMessageSizeBytes,
  }) {
    final $result = create();
    if (nodeMaxMemorySizeBytes != null) {
      $result.nodeMaxMemorySizeBytes = nodeMaxMemorySizeBytes;
    }
    if (maxMessageSizeBytes != null) {
      $result.maxMessageSizeBytes = maxMessageSizeBytes;
    }
    return $result;
  }
  ArchiveInit._() : super();
  factory ArchiveInit.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ArchiveInit.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveInit',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'nodeMaxMemorySizeBytes', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'maxMessageSizeBytes', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ArchiveInit clone() => ArchiveInit()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ArchiveInit copyWith(void Function(ArchiveInit) updates) =>
      super.copyWith((message) => updates(message as ArchiveInit))
          as ArchiveInit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveInit create() => ArchiveInit._();
  ArchiveInit createEmptyInstance() => create();
  static $pb.PbList<ArchiveInit> createRepeated() => $pb.PbList<ArchiveInit>();
  @$core.pragma('dart2js:noInline')
  static ArchiveInit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveInit>(create);
  static ArchiveInit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get nodeMaxMemorySizeBytes => $_getIZ(0);
  @$pb.TagNumber(1)
  set nodeMaxMemorySizeBytes($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeMaxMemorySizeBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeMaxMemorySizeBytes() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxMessageSizeBytes => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxMessageSizeBytes($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMaxMessageSizeBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxMessageSizeBytes() => clearField(2);
}

/// Add blocks to the archive canister
class ArchiveAddRequest extends $pb.GeneratedMessage {
  factory ArchiveAddRequest({
    $core.Iterable<Block>? blocks,
  }) {
    final $result = create();
    if (blocks != null) {
      $result.blocks.addAll(blocks);
    }
    return $result;
  }
  ArchiveAddRequest._() : super();
  factory ArchiveAddRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ArchiveAddRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveAddRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..pc<Block>(1, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.PM,
        subBuilder: Block.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ArchiveAddRequest clone() => ArchiveAddRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ArchiveAddRequest copyWith(void Function(ArchiveAddRequest) updates) =>
      super.copyWith((message) => updates(message as ArchiveAddRequest))
          as ArchiveAddRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveAddRequest create() => ArchiveAddRequest._();
  ArchiveAddRequest createEmptyInstance() => create();
  static $pb.PbList<ArchiveAddRequest> createRepeated() =>
      $pb.PbList<ArchiveAddRequest>();
  @$core.pragma('dart2js:noInline')
  static ArchiveAddRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveAddRequest>(create);
  static ArchiveAddRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Block> get blocks => $_getList(0);
}

class ArchiveAddResponse extends $pb.GeneratedMessage {
  factory ArchiveAddResponse() => create();
  ArchiveAddResponse._() : super();
  factory ArchiveAddResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ArchiveAddResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveAddResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ArchiveAddResponse clone() => ArchiveAddResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ArchiveAddResponse copyWith(void Function(ArchiveAddResponse) updates) =>
      super.copyWith((message) => updates(message as ArchiveAddResponse))
          as ArchiveAddResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArchiveAddResponse create() => ArchiveAddResponse._();
  ArchiveAddResponse createEmptyInstance() => create();
  static $pb.PbList<ArchiveAddResponse> createRepeated() =>
      $pb.PbList<ArchiveAddResponse>();
  @$core.pragma('dart2js:noInline')
  static ArchiveAddResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveAddResponse>(create);
  static ArchiveAddResponse? _defaultInstance;
}

/// Fetch a list of all of the archive nodes
class GetNodesRequest extends $pb.GeneratedMessage {
  factory GetNodesRequest() => create();
  GetNodesRequest._() : super();
  factory GetNodesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetNodesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNodesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetNodesRequest clone() => GetNodesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetNodesRequest copyWith(void Function(GetNodesRequest) updates) =>
      super.copyWith((message) => updates(message as GetNodesRequest))
          as GetNodesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNodesRequest create() => GetNodesRequest._();
  GetNodesRequest createEmptyInstance() => create();
  static $pb.PbList<GetNodesRequest> createRepeated() =>
      $pb.PbList<GetNodesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetNodesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNodesRequest>(create);
  static GetNodesRequest? _defaultInstance;
}

class GetNodesResponse extends $pb.GeneratedMessage {
  factory GetNodesResponse({
    $core.Iterable<$0.PrincipalId>? nodes,
  }) {
    final $result = create();
    if (nodes != null) {
      $result.nodes.addAll(nodes);
    }
    return $result;
  }
  GetNodesResponse._() : super();
  factory GetNodesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetNodesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNodesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..pc<$0.PrincipalId>(1, _omitFieldNames ? '' : 'nodes', $pb.PbFieldType.PM,
        subBuilder: $0.PrincipalId.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetNodesResponse clone() => GetNodesResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetNodesResponse copyWith(void Function(GetNodesResponse) updates) =>
      super.copyWith((message) => updates(message as GetNodesResponse))
          as GetNodesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNodesResponse create() => GetNodesResponse._();
  GetNodesResponse createEmptyInstance() => create();
  static $pb.PbList<GetNodesResponse> createRepeated() =>
      $pb.PbList<GetNodesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetNodesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNodesResponse>(create);
  static GetNodesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.PrincipalId> get nodes => $_getList(0);
}

/// ** BASIC TYPES **
class ICPTs extends $pb.GeneratedMessage {
  factory ICPTs({
    $fixnum.Int64? e8s,
  }) {
    final $result = create();
    if (e8s != null) {
      $result.e8s = e8s;
    }
    return $result;
  }
  ICPTs._() : super();
  factory ICPTs.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ICPTs.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ICPTs',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'e8s', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ICPTs clone() => ICPTs()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ICPTs copyWith(void Function(ICPTs) updates) =>
      super.copyWith((message) => updates(message as ICPTs)) as ICPTs;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ICPTs create() => ICPTs._();
  ICPTs createEmptyInstance() => create();
  static $pb.PbList<ICPTs> createRepeated() => $pb.PbList<ICPTs>();
  @$core.pragma('dart2js:noInline')
  static ICPTs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ICPTs>(create);
  static ICPTs? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get e8s => $_getI64(0);
  @$pb.TagNumber(1)
  set e8s($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasE8s() => $_has(0);
  @$pb.TagNumber(1)
  void clearE8s() => clearField(1);
}

class Payment extends $pb.GeneratedMessage {
  factory Payment({
    ICPTs? receiverGets,
  }) {
    final $result = create();
    if (receiverGets != null) {
      $result.receiverGets = receiverGets;
    }
    return $result;
  }
  Payment._() : super();
  factory Payment.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Payment.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Payment',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<ICPTs>(1, _omitFieldNames ? '' : 'receiverGets',
        subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Payment clone() => Payment()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Payment copyWith(void Function(Payment) updates) =>
      super.copyWith((message) => updates(message as Payment)) as Payment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Payment create() => Payment._();
  Payment createEmptyInstance() => create();
  static $pb.PbList<Payment> createRepeated() => $pb.PbList<Payment>();
  @$core.pragma('dart2js:noInline')
  static Payment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Payment>(create);
  static Payment? _defaultInstance;

  @$pb.TagNumber(1)
  ICPTs get receiverGets => $_getN(0);
  @$pb.TagNumber(1)
  set receiverGets(ICPTs v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasReceiverGets() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiverGets() => clearField(1);
  @$pb.TagNumber(1)
  ICPTs ensureReceiverGets() => $_ensure(0);
}

class BlockHeight extends $pb.GeneratedMessage {
  factory BlockHeight({
    $fixnum.Int64? height,
  }) {
    final $result = create();
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  BlockHeight._() : super();
  factory BlockHeight.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BlockHeight.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockHeight',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BlockHeight clone() => BlockHeight()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BlockHeight copyWith(void Function(BlockHeight) updates) =>
      super.copyWith((message) => updates(message as BlockHeight))
          as BlockHeight;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockHeight create() => BlockHeight._();
  BlockHeight createEmptyInstance() => create();
  static $pb.PbList<BlockHeight> createRepeated() => $pb.PbList<BlockHeight>();
  @$core.pragma('dart2js:noInline')
  static BlockHeight getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockHeight>(create);
  static BlockHeight? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get height => $_getI64(0);
  @$pb.TagNumber(1)
  set height($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeight() => clearField(1);
}

/// This is the
class Block extends $pb.GeneratedMessage {
  factory Block({
    Hash? parentHash,
    TimeStamp? timestamp,
    Transaction? transaction,
  }) {
    final $result = create();
    if (parentHash != null) {
      $result.parentHash = parentHash;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (transaction != null) {
      $result.transaction = transaction;
    }
    return $result;
  }
  Block._() : super();
  factory Block.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Block.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Block',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<Hash>(1, _omitFieldNames ? '' : 'parentHash', subBuilder: Hash.create)
    ..aOM<TimeStamp>(2, _omitFieldNames ? '' : 'timestamp',
        subBuilder: TimeStamp.create)
    ..aOM<Transaction>(3, _omitFieldNames ? '' : 'transaction',
        subBuilder: Transaction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Block clone() => Block()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Block copyWith(void Function(Block) updates) =>
      super.copyWith((message) => updates(message as Block)) as Block;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Block create() => Block._();
  Block createEmptyInstance() => create();
  static $pb.PbList<Block> createRepeated() => $pb.PbList<Block>();
  @$core.pragma('dart2js:noInline')
  static Block getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Block>(create);
  static Block? _defaultInstance;

  @$pb.TagNumber(1)
  Hash get parentHash => $_getN(0);
  @$pb.TagNumber(1)
  set parentHash(Hash v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasParentHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentHash() => clearField(1);
  @$pb.TagNumber(1)
  Hash ensureParentHash() => $_ensure(0);

  @$pb.TagNumber(2)
  TimeStamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp(TimeStamp v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);
  @$pb.TagNumber(2)
  TimeStamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  Transaction get transaction => $_getN(2);
  @$pb.TagNumber(3)
  set transaction(Transaction v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTransaction() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransaction() => clearField(3);
  @$pb.TagNumber(3)
  Transaction ensureTransaction() => $_ensure(2);
}

class Hash extends $pb.GeneratedMessage {
  factory Hash({
    $core.List<$core.int>? hash,
  }) {
    final $result = create();
    if (hash != null) {
      $result.hash = hash;
    }
    return $result;
  }
  Hash._() : super();
  factory Hash.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Hash.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Hash',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'hash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Hash clone() => Hash()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Hash copyWith(void Function(Hash) updates) =>
      super.copyWith((message) => updates(message as Hash)) as Hash;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Hash create() => Hash._();
  Hash createEmptyInstance() => create();
  static $pb.PbList<Hash> createRepeated() => $pb.PbList<Hash>();
  @$core.pragma('dart2js:noInline')
  static Hash getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Hash>(create);
  static Hash? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);
}

class Account extends $pb.GeneratedMessage {
  factory Account({
    AccountIdentifier? identifier,
    ICPTs? balance,
  }) {
    final $result = create();
    if (identifier != null) {
      $result.identifier = identifier;
    }
    if (balance != null) {
      $result.balance = balance;
    }
    return $result;
  }
  Account._() : super();
  factory Account.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Account.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Account',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<AccountIdentifier>(1, _omitFieldNames ? '' : 'identifier',
        subBuilder: AccountIdentifier.create)
    ..aOM<ICPTs>(2, _omitFieldNames ? '' : 'balance', subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Account copyWith(void Function(Account) updates) =>
      super.copyWith((message) => updates(message as Account)) as Account;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  AccountIdentifier get identifier => $_getN(0);
  @$pb.TagNumber(1)
  set identifier(AccountIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => clearField(1);
  @$pb.TagNumber(1)
  AccountIdentifier ensureIdentifier() => $_ensure(0);

  @$pb.TagNumber(2)
  ICPTs get balance => $_getN(1);
  @$pb.TagNumber(2)
  set balance(ICPTs v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => clearField(2);
  @$pb.TagNumber(2)
  ICPTs ensureBalance() => $_ensure(1);
}

enum Transaction_Transfer { burn, mint, send, notSet }

class Transaction extends $pb.GeneratedMessage {
  factory Transaction({
    Burn? burn,
    Mint? mint,
    Send? send,
    Memo? memo,
    BlockHeight? createdAt,
    TimeStamp? createdAtTime,
  }) {
    final $result = create();
    if (burn != null) {
      $result.burn = burn;
    }
    if (mint != null) {
      $result.mint = mint;
    }
    if (send != null) {
      $result.send = send;
    }
    if (memo != null) {
      $result.memo = memo;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (createdAtTime != null) {
      $result.createdAtTime = createdAtTime;
    }
    return $result;
  }
  Transaction._() : super();
  factory Transaction.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Transaction.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Transaction_Transfer>
      _Transaction_TransferByTag = {
    1: Transaction_Transfer.burn,
    2: Transaction_Transfer.mint,
    3: Transaction_Transfer.send,
    0: Transaction_Transfer.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Transaction',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Burn>(1, _omitFieldNames ? '' : 'burn', subBuilder: Burn.create)
    ..aOM<Mint>(2, _omitFieldNames ? '' : 'mint', subBuilder: Mint.create)
    ..aOM<Send>(3, _omitFieldNames ? '' : 'send', subBuilder: Send.create)
    ..aOM<Memo>(4, _omitFieldNames ? '' : 'memo', subBuilder: Memo.create)
    ..aOM<BlockHeight>(5, _omitFieldNames ? '' : 'createdAt',
        subBuilder: BlockHeight.create)
    ..aOM<TimeStamp>(6, _omitFieldNames ? '' : 'createdAtTime',
        subBuilder: TimeStamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Transaction clone() => Transaction()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Transaction copyWith(void Function(Transaction) updates) =>
      super.copyWith((message) => updates(message as Transaction))
          as Transaction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Transaction create() => Transaction._();
  Transaction createEmptyInstance() => create();
  static $pb.PbList<Transaction> createRepeated() => $pb.PbList<Transaction>();
  @$core.pragma('dart2js:noInline')
  static Transaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Transaction>(create);
  static Transaction? _defaultInstance;

  Transaction_Transfer whichTransfer() =>
      _Transaction_TransferByTag[$_whichOneof(0)]!;
  void clearTransfer() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Burn get burn => $_getN(0);
  @$pb.TagNumber(1)
  set burn(Burn v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBurn() => $_has(0);
  @$pb.TagNumber(1)
  void clearBurn() => clearField(1);
  @$pb.TagNumber(1)
  Burn ensureBurn() => $_ensure(0);

  @$pb.TagNumber(2)
  Mint get mint => $_getN(1);
  @$pb.TagNumber(2)
  set mint(Mint v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMint() => $_has(1);
  @$pb.TagNumber(2)
  void clearMint() => clearField(2);
  @$pb.TagNumber(2)
  Mint ensureMint() => $_ensure(1);

  @$pb.TagNumber(3)
  Send get send => $_getN(2);
  @$pb.TagNumber(3)
  set send(Send v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSend() => $_has(2);
  @$pb.TagNumber(3)
  void clearSend() => clearField(3);
  @$pb.TagNumber(3)
  Send ensureSend() => $_ensure(2);

  @$pb.TagNumber(4)
  Memo get memo => $_getN(3);
  @$pb.TagNumber(4)
  set memo(Memo v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMemo() => $_has(3);
  @$pb.TagNumber(4)
  void clearMemo() => clearField(4);
  @$pb.TagNumber(4)
  Memo ensureMemo() => $_ensure(3);

  @$pb.TagNumber(5)
  BlockHeight get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt(BlockHeight v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => clearField(5);
  @$pb.TagNumber(5)
  BlockHeight ensureCreatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  TimeStamp get createdAtTime => $_getN(5);
  @$pb.TagNumber(6)
  set createdAtTime(TimeStamp v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCreatedAtTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAtTime() => clearField(6);
  @$pb.TagNumber(6)
  TimeStamp ensureCreatedAtTime() => $_ensure(5);
}

class Send extends $pb.GeneratedMessage {
  factory Send({
    AccountIdentifier? from,
    AccountIdentifier? to,
    ICPTs? amount,
    ICPTs? maxFee,
  }) {
    final $result = create();
    if (from != null) {
      $result.from = from;
    }
    if (to != null) {
      $result.to = to;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (maxFee != null) {
      $result.maxFee = maxFee;
    }
    return $result;
  }
  Send._() : super();
  factory Send.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Send.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Send',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<AccountIdentifier>(1, _omitFieldNames ? '' : 'from',
        subBuilder: AccountIdentifier.create)
    ..aOM<AccountIdentifier>(2, _omitFieldNames ? '' : 'to',
        subBuilder: AccountIdentifier.create)
    ..aOM<ICPTs>(3, _omitFieldNames ? '' : 'amount', subBuilder: ICPTs.create)
    ..aOM<ICPTs>(4, _omitFieldNames ? '' : 'maxFee', subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Send clone() => Send()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Send copyWith(void Function(Send) updates) =>
      super.copyWith((message) => updates(message as Send)) as Send;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Send create() => Send._();
  Send createEmptyInstance() => create();
  static $pb.PbList<Send> createRepeated() => $pb.PbList<Send>();
  @$core.pragma('dart2js:noInline')
  static Send getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Send>(create);
  static Send? _defaultInstance;

  @$pb.TagNumber(1)
  AccountIdentifier get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(AccountIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => clearField(1);
  @$pb.TagNumber(1)
  AccountIdentifier ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  AccountIdentifier get to => $_getN(1);
  @$pb.TagNumber(2)
  set to(AccountIdentifier v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => clearField(2);
  @$pb.TagNumber(2)
  AccountIdentifier ensureTo() => $_ensure(1);

  @$pb.TagNumber(3)
  ICPTs get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount(ICPTs v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  ICPTs ensureAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  ICPTs get maxFee => $_getN(3);
  @$pb.TagNumber(4)
  set maxFee(ICPTs v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMaxFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxFee() => clearField(4);
  @$pb.TagNumber(4)
  ICPTs ensureMaxFee() => $_ensure(3);
}

class Mint extends $pb.GeneratedMessage {
  factory Mint({
    AccountIdentifier? to,
    ICPTs? amount,
  }) {
    final $result = create();
    if (to != null) {
      $result.to = to;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  Mint._() : super();
  factory Mint.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Mint.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Mint',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<AccountIdentifier>(2, _omitFieldNames ? '' : 'to',
        subBuilder: AccountIdentifier.create)
    ..aOM<ICPTs>(3, _omitFieldNames ? '' : 'amount', subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Mint clone() => Mint()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Mint copyWith(void Function(Mint) updates) =>
      super.copyWith((message) => updates(message as Mint)) as Mint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Mint create() => Mint._();
  Mint createEmptyInstance() => create();
  static $pb.PbList<Mint> createRepeated() => $pb.PbList<Mint>();
  @$core.pragma('dart2js:noInline')
  static Mint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Mint>(create);
  static Mint? _defaultInstance;

  @$pb.TagNumber(2)
  AccountIdentifier get to => $_getN(0);
  @$pb.TagNumber(2)
  set to(AccountIdentifier v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(0);
  @$pb.TagNumber(2)
  void clearTo() => clearField(2);
  @$pb.TagNumber(2)
  AccountIdentifier ensureTo() => $_ensure(0);

  @$pb.TagNumber(3)
  ICPTs get amount => $_getN(1);
  @$pb.TagNumber(3)
  set amount(ICPTs v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  ICPTs ensureAmount() => $_ensure(1);
}

class Burn extends $pb.GeneratedMessage {
  factory Burn({
    AccountIdentifier? from,
    ICPTs? amount,
  }) {
    final $result = create();
    if (from != null) {
      $result.from = from;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  Burn._() : super();
  factory Burn.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Burn.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Burn',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..aOM<AccountIdentifier>(1, _omitFieldNames ? '' : 'from',
        subBuilder: AccountIdentifier.create)
    ..aOM<ICPTs>(3, _omitFieldNames ? '' : 'amount', subBuilder: ICPTs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Burn clone() => Burn()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Burn copyWith(void Function(Burn) updates) =>
      super.copyWith((message) => updates(message as Burn)) as Burn;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Burn create() => Burn._();
  Burn createEmptyInstance() => create();
  static $pb.PbList<Burn> createRepeated() => $pb.PbList<Burn>();
  @$core.pragma('dart2js:noInline')
  static Burn getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Burn>(create);
  static Burn? _defaultInstance;

  @$pb.TagNumber(1)
  AccountIdentifier get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(AccountIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => clearField(1);
  @$pb.TagNumber(1)
  AccountIdentifier ensureFrom() => $_ensure(0);

  @$pb.TagNumber(3)
  ICPTs get amount => $_getN(1);
  @$pb.TagNumber(3)
  set amount(ICPTs v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  ICPTs ensureAmount() => $_ensure(1);
}

class AccountIdentifier extends $pb.GeneratedMessage {
  factory AccountIdentifier({
    $core.List<$core.int>? hash,
  }) {
    final $result = create();
    if (hash != null) {
      $result.hash = hash;
    }
    return $result;
  }
  AccountIdentifier._() : super();
  factory AccountIdentifier.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AccountIdentifier.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountIdentifier',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'hash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AccountIdentifier clone() => AccountIdentifier()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AccountIdentifier copyWith(void Function(AccountIdentifier) updates) =>
      super.copyWith((message) => updates(message as AccountIdentifier))
          as AccountIdentifier;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountIdentifier create() => AccountIdentifier._();
  AccountIdentifier createEmptyInstance() => create();
  static $pb.PbList<AccountIdentifier> createRepeated() =>
      $pb.PbList<AccountIdentifier>();
  @$core.pragma('dart2js:noInline')
  static AccountIdentifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountIdentifier>(create);
  static AccountIdentifier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);
}

class Subaccount extends $pb.GeneratedMessage {
  factory Subaccount({
    $core.List<$core.int>? subAccount,
  }) {
    final $result = create();
    if (subAccount != null) {
      $result.subAccount = subAccount;
    }
    return $result;
  }
  Subaccount._() : super();
  factory Subaccount.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Subaccount.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Subaccount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'subAccount', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Subaccount clone() => Subaccount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Subaccount copyWith(void Function(Subaccount) updates) =>
      super.copyWith((message) => updates(message as Subaccount)) as Subaccount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subaccount create() => Subaccount._();
  Subaccount createEmptyInstance() => create();
  static $pb.PbList<Subaccount> createRepeated() => $pb.PbList<Subaccount>();
  @$core.pragma('dart2js:noInline')
  static Subaccount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Subaccount>(create);
  static Subaccount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get subAccount => $_getN(0);
  @$pb.TagNumber(1)
  set subAccount($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSubAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubAccount() => clearField(1);
}

class Memo extends $pb.GeneratedMessage {
  factory Memo({
    $fixnum.Int64? memo,
  }) {
    final $result = create();
    if (memo != null) {
      $result.memo = memo;
    }
    return $result;
  }
  Memo._() : super();
  factory Memo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Memo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Memo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'memo', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Memo clone() => Memo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Memo copyWith(void Function(Memo) updates) =>
      super.copyWith((message) => updates(message as Memo)) as Memo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Memo create() => Memo._();
  Memo createEmptyInstance() => create();
  static $pb.PbList<Memo> createRepeated() => $pb.PbList<Memo>();
  @$core.pragma('dart2js:noInline')
  static Memo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Memo>(create);
  static Memo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get memo => $_getI64(0);
  @$pb.TagNumber(1)
  set memo($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMemo() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemo() => clearField(1);
}

class TimeStamp extends $pb.GeneratedMessage {
  factory TimeStamp({
    $fixnum.Int64? timestampNanos,
  }) {
    final $result = create();
    if (timestampNanos != null) {
      $result.timestampNanos = timestampNanos;
    }
    return $result;
  }
  TimeStamp._() : super();
  factory TimeStamp.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TimeStamp.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeStamp',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'timestampNanos', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TimeStamp clone() => TimeStamp()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TimeStamp copyWith(void Function(TimeStamp) updates) =>
      super.copyWith((message) => updates(message as TimeStamp)) as TimeStamp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeStamp create() => TimeStamp._();
  TimeStamp createEmptyInstance() => create();
  static $pb.PbList<TimeStamp> createRepeated() => $pb.PbList<TimeStamp>();
  @$core.pragma('dart2js:noInline')
  static TimeStamp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeStamp>(create);
  static TimeStamp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampNanos => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampNanos($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTimestampNanos() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampNanos() => clearField(1);
}

class Certification extends $pb.GeneratedMessage {
  factory Certification({
    $core.List<$core.int>? certification,
  }) {
    final $result = create();
    if (certification != null) {
      $result.certification = certification;
    }
    return $result;
  }
  Certification._() : super();
  factory Certification.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Certification.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Certification',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_ledger.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'certification', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Certification clone() => Certification()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Certification copyWith(void Function(Certification) updates) =>
      super.copyWith((message) => updates(message as Certification))
          as Certification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Certification create() => Certification._();
  Certification createEmptyInstance() => create();
  static $pb.PbList<Certification> createRepeated() =>
      $pb.PbList<Certification>();
  @$core.pragma('dart2js:noInline')
  static Certification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Certification>(create);
  static Certification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get certification => $_getN(0);
  @$pb.TagNumber(1)
  set certification($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCertification() => $_has(0);
  @$pb.TagNumber(1)
  void clearCertification() => clearField(1);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
