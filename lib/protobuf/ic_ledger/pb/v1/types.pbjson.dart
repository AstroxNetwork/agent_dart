//
//  Generated code. Do not modify.
//  source: ic_ledger/pb/v1/types.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use ledgerInitDescriptor instead')
const LedgerInit$json = {
  '1': 'LedgerInit',
  '2': [
    {
      '1': 'minting_account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'mintingAccount'
    },
    {
      '1': 'initial_values',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Account',
      '10': 'initialValues'
    },
    {
      '1': 'archive_canister',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '10': 'archiveCanister'
    },
    {
      '1': 'max_message_size_bytes',
      '3': 4,
      '4': 1,
      '5': 13,
      '10': 'maxMessageSizeBytes'
    },
  ],
};

/// Descriptor for `LedgerInit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ledgerInitDescriptor = $convert.base64Decode(
    'CgpMZWRnZXJJbml0EksKD21pbnRpbmdfYWNjb3VudBgBIAEoCzIiLmljX2xlZGdlci5wYi52MS'
    '5BY2NvdW50SWRlbnRpZmllclIObWludGluZ0FjY291bnQSPwoOaW5pdGlhbF92YWx1ZXMYAiAD'
    'KAsyGC5pY19sZWRnZXIucGIudjEuQWNjb3VudFINaW5pdGlhbFZhbHVlcxJLChBhcmNoaXZlX2'
    'NhbmlzdGVyGAMgASgLMiAuaWNfYmFzZV90eXBlcy5wYi52MS5QcmluY2lwYWxJZFIPYXJjaGl2'
    'ZUNhbmlzdGVyEjMKFm1heF9tZXNzYWdlX3NpemVfYnl0ZXMYBCABKA1SE21heE1lc3NhZ2VTaX'
    'plQnl0ZXM=');

@$core.Deprecated('Use ledgerUpgradeDescriptor instead')
const LedgerUpgrade$json = {
  '1': 'LedgerUpgrade',
};

/// Descriptor for `LedgerUpgrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ledgerUpgradeDescriptor =
    $convert.base64Decode('Cg1MZWRnZXJVcGdyYWRl');

@$core.Deprecated('Use sendRequestDescriptor instead')
const SendRequest$json = {
  '1': 'SendRequest',
  '2': [
    {
      '1': 'memo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Memo',
      '8': {},
      '10': 'memo'
    },
    {
      '1': 'payment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Payment',
      '8': {},
      '10': 'payment'
    },
    {
      '1': 'max_fee',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '8': {},
      '10': 'maxFee'
    },
    {
      '1': 'from_subaccount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Subaccount',
      '8': {},
      '10': 'fromSubaccount'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '8': {},
      '10': 'to'
    },
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '10': 'createdAt'
    },
    {
      '1': 'created_at_time',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.TimeStamp',
      '10': 'createdAtTime'
    },
  ],
  '7': {},
};

/// Descriptor for `SendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendRequestDescriptor = $convert.base64Decode(
    'CgtTZW5kUmVxdWVzdBIvCgRtZW1vGAEgASgLMhUuaWNfbGVkZ2VyLnBiLnYxLk1lbW9CBIjiCQ'
    'FSBG1lbW8SOAoHcGF5bWVudBgCIAEoCzIYLmljX2xlZGdlci5wYi52MS5QYXltZW50QgSI4gkB'
    'UgdwYXltZW50EjUKB21heF9mZWUYAyABKAsyFi5pY19sZWRnZXIucGIudjEuSUNQVHNCBIjiCQ'
    'FSBm1heEZlZRJKCg9mcm9tX3N1YmFjY291bnQYBCABKAsyGy5pY19sZWRnZXIucGIudjEuU3Vi'
    'YWNjb3VudEIEiOIJAVIOZnJvbVN1YmFjY291bnQSOAoCdG8YBSABKAsyIi5pY19sZWRnZXIucG'
    'IudjEuQWNjb3VudElkZW50aWZpZXJCBIjiCQFSAnRvEjsKCmNyZWF0ZWRfYXQYBiABKAsyHC5p'
    'Y19sZWRnZXIucGIudjEuQmxvY2tIZWlnaHRSCWNyZWF0ZWRBdBJCCg9jcmVhdGVkX2F0X3RpbW'
    'UYByABKAsyGi5pY19sZWRnZXIucGIudjEuVGltZVN0YW1wUg1jcmVhdGVkQXRUaW1lOgSA4gkB');

@$core.Deprecated('Use sendResponseDescriptor instead')
const SendResponse$json = {
  '1': 'SendResponse',
  '2': [
    {
      '1': 'resulting_height',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '10': 'resultingHeight'
    },
  ],
};

/// Descriptor for `SendResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendResponseDescriptor = $convert.base64Decode(
    'CgxTZW5kUmVzcG9uc2USRwoQcmVzdWx0aW5nX2hlaWdodBgBIAEoCzIcLmljX2xlZGdlci5wYi'
    '52MS5CbG9ja0hlaWdodFIPcmVzdWx0aW5nSGVpZ2h0');

@$core.Deprecated('Use notifyRequestDescriptor instead')
const NotifyRequest$json = {
  '1': 'NotifyRequest',
  '2': [
    {
      '1': 'block_height',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '8': {},
      '10': 'blockHeight'
    },
    {
      '1': 'max_fee',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '8': {},
      '10': 'maxFee'
    },
    {
      '1': 'from_subaccount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Subaccount',
      '8': {},
      '10': 'fromSubaccount'
    },
    {
      '1': 'to_canister',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '8': {},
      '10': 'toCanister'
    },
    {
      '1': 'to_subaccount',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Subaccount',
      '8': {},
      '10': 'toSubaccount'
    },
  ],
  '7': {},
};

/// Descriptor for `NotifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifyRequestDescriptor = $convert.base64Decode(
    'Cg1Ob3RpZnlSZXF1ZXN0EkUKDGJsb2NrX2hlaWdodBgBIAEoCzIcLmljX2xlZGdlci5wYi52MS'
    '5CbG9ja0hlaWdodEIEiOIJAVILYmxvY2tIZWlnaHQSNQoHbWF4X2ZlZRgCIAEoCzIWLmljX2xl'
    'ZGdlci5wYi52MS5JQ1BUc0IEiOIJAVIGbWF4RmVlEkoKD2Zyb21fc3ViYWNjb3VudBgDIAEoCz'
    'IbLmljX2xlZGdlci5wYi52MS5TdWJhY2NvdW50QgSI4gkBUg5mcm9tU3ViYWNjb3VudBJHCgt0'
    'b19jYW5pc3RlchgEIAEoCzIgLmljX2Jhc2VfdHlwZXMucGIudjEuUHJpbmNpcGFsSWRCBIjiCQ'
    'FSCnRvQ2FuaXN0ZXISRgoNdG9fc3ViYWNjb3VudBgFIAEoCzIbLmljX2xlZGdlci5wYi52MS5T'
    'dWJhY2NvdW50QgSI4gkBUgx0b1N1YmFjY291bnQ6BIDiCQE=');

@$core.Deprecated('Use notifyResponseDescriptor instead')
const NotifyResponse$json = {
  '1': 'NotifyResponse',
};

/// Descriptor for `NotifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifyResponseDescriptor =
    $convert.base64Decode('Cg5Ob3RpZnlSZXNwb25zZQ==');

@$core.Deprecated('Use transactionNotificationRequestDescriptor instead')
const TransactionNotificationRequest$json = {
  '1': 'TransactionNotificationRequest',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '10': 'from'
    },
    {
      '1': 'from_subaccount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Subaccount',
      '10': 'fromSubaccount'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '10': 'to'
    },
    {
      '1': 'to_subaccount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Subaccount',
      '10': 'toSubaccount'
    },
    {
      '1': 'block_height',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '10': 'blockHeight'
    },
    {
      '1': 'amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'amount'
    },
    {
      '1': 'memo',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Memo',
      '10': 'memo'
    },
  ],
};

/// Descriptor for `TransactionNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionNotificationRequestDescriptor = $convert.base64Decode(
    'Ch5UcmFuc2FjdGlvbk5vdGlmaWNhdGlvblJlcXVlc3QSNAoEZnJvbRgBIAEoCzIgLmljX2Jhc2'
    'VfdHlwZXMucGIudjEuUHJpbmNpcGFsSWRSBGZyb20SRAoPZnJvbV9zdWJhY2NvdW50GAIgASgL'
    'MhsuaWNfbGVkZ2VyLnBiLnYxLlN1YmFjY291bnRSDmZyb21TdWJhY2NvdW50EjAKAnRvGAMgAS'
    'gLMiAuaWNfYmFzZV90eXBlcy5wYi52MS5QcmluY2lwYWxJZFICdG8SQAoNdG9fc3ViYWNjb3Vu'
    'dBgEIAEoCzIbLmljX2xlZGdlci5wYi52MS5TdWJhY2NvdW50Ugx0b1N1YmFjY291bnQSPwoMYm'
    'xvY2tfaGVpZ2h0GAUgASgLMhwuaWNfbGVkZ2VyLnBiLnYxLkJsb2NrSGVpZ2h0UgtibG9ja0hl'
    'aWdodBIuCgZhbW91bnQYBiABKAsyFi5pY19sZWRnZXIucGIudjEuSUNQVHNSBmFtb3VudBIpCg'
    'RtZW1vGAcgASgLMhUuaWNfbGVkZ2VyLnBiLnYxLk1lbW9SBG1lbW8=');

@$core.Deprecated('Use transactionNotificationResponseDescriptor instead')
const TransactionNotificationResponse$json = {
  '1': 'TransactionNotificationResponse',
  '2': [
    {'1': 'response', '3': 1, '4': 1, '5': 12, '10': 'response'},
  ],
};

/// Descriptor for `TransactionNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionNotificationResponseDescriptor =
    $convert.base64Decode(
        'Ch9UcmFuc2FjdGlvbk5vdGlmaWNhdGlvblJlc3BvbnNlEhoKCHJlc3BvbnNlGAEgASgMUghyZX'
        'Nwb25zZQ==');

@$core.Deprecated('Use cyclesNotificationResponseDescriptor instead')
const CyclesNotificationResponse$json = {
  '1': 'CyclesNotificationResponse',
  '2': [
    {
      '1': 'created_canister_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '9': 0,
      '10': 'createdCanisterId'
    },
    {
      '1': 'refund',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Refund',
      '9': 0,
      '10': 'refund'
    },
    {
      '1': 'topped_up',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ToppedUp',
      '9': 0,
      '10': 'toppedUp'
    },
  ],
  '8': [
    {'1': 'response'},
  ],
};

/// Descriptor for `CyclesNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cyclesNotificationResponseDescriptor = $convert.base64Decode(
    'ChpDeWNsZXNOb3RpZmljYXRpb25SZXNwb25zZRJSChNjcmVhdGVkX2NhbmlzdGVyX2lkGAEgAS'
    'gLMiAuaWNfYmFzZV90eXBlcy5wYi52MS5QcmluY2lwYWxJZEgAUhFjcmVhdGVkQ2FuaXN0ZXJJ'
    'ZBIxCgZyZWZ1bmQYAiABKAsyFy5pY19sZWRnZXIucGIudjEuUmVmdW5kSABSBnJlZnVuZBI4Cg'
    'l0b3BwZWRfdXAYAyABKAsyGS5pY19sZWRnZXIucGIudjEuVG9wcGVkVXBIAFIIdG9wcGVkVXBC'
    'CgoIcmVzcG9uc2U=');

@$core.Deprecated('Use accountBalanceRequestDescriptor instead')
const AccountBalanceRequest$json = {
  '1': 'AccountBalanceRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'account'
    },
  ],
};

/// Descriptor for `AccountBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountBalanceRequestDescriptor = $convert.base64Decode(
    'ChVBY2NvdW50QmFsYW5jZVJlcXVlc3QSPAoHYWNjb3VudBgBIAEoCzIiLmljX2xlZGdlci5wYi'
    '52MS5BY2NvdW50SWRlbnRpZmllclIHYWNjb3VudA==');

@$core.Deprecated('Use accountBalanceResponseDescriptor instead')
const AccountBalanceResponse$json = {
  '1': 'AccountBalanceResponse',
  '2': [
    {
      '1': 'balance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `AccountBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountBalanceResponseDescriptor =
    $convert.base64Decode(
        'ChZBY2NvdW50QmFsYW5jZVJlc3BvbnNlEjAKB2JhbGFuY2UYASABKAsyFi5pY19sZWRnZXIucG'
        'IudjEuSUNQVHNSB2JhbGFuY2U=');

@$core.Deprecated('Use tipOfChainRequestDescriptor instead')
const TipOfChainRequest$json = {
  '1': 'TipOfChainRequest',
};

/// Descriptor for `TipOfChainRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tipOfChainRequestDescriptor =
    $convert.base64Decode('ChFUaXBPZkNoYWluUmVxdWVzdA==');

@$core.Deprecated('Use tipOfChainResponseDescriptor instead')
const TipOfChainResponse$json = {
  '1': 'TipOfChainResponse',
  '2': [
    {
      '1': 'certification',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Certification',
      '10': 'certification'
    },
    {
      '1': 'chain_length',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '10': 'chainLength'
    },
  ],
};

/// Descriptor for `TipOfChainResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tipOfChainResponseDescriptor = $convert.base64Decode(
    'ChJUaXBPZkNoYWluUmVzcG9uc2USRAoNY2VydGlmaWNhdGlvbhgBIAEoCzIeLmljX2xlZGdlci'
    '5wYi52MS5DZXJ0aWZpY2F0aW9uUg1jZXJ0aWZpY2F0aW9uEj8KDGNoYWluX2xlbmd0aBgCIAEo'
    'CzIcLmljX2xlZGdlci5wYi52MS5CbG9ja0hlaWdodFILY2hhaW5MZW5ndGg=');

@$core.Deprecated('Use totalSupplyRequestDescriptor instead')
const TotalSupplyRequest$json = {
  '1': 'TotalSupplyRequest',
};

/// Descriptor for `TotalSupplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List totalSupplyRequestDescriptor =
    $convert.base64Decode('ChJUb3RhbFN1cHBseVJlcXVlc3Q=');

@$core.Deprecated('Use totalSupplyResponseDescriptor instead')
const TotalSupplyResponse$json = {
  '1': 'TotalSupplyResponse',
  '2': [
    {
      '1': 'total_supply',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'totalSupply'
    },
  ],
};

/// Descriptor for `TotalSupplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List totalSupplyResponseDescriptor = $convert.base64Decode(
    'ChNUb3RhbFN1cHBseVJlc3BvbnNlEjkKDHRvdGFsX3N1cHBseRgBIAEoCzIWLmljX2xlZGdlci'
    '5wYi52MS5JQ1BUc1ILdG90YWxTdXBwbHk=');

@$core.Deprecated('Use ledgerArchiveRequestDescriptor instead')
const LedgerArchiveRequest$json = {
  '1': 'LedgerArchiveRequest',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.TimeStamp',
      '10': 'timestamp'
    },
  ],
};

/// Descriptor for `LedgerArchiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ledgerArchiveRequestDescriptor = $convert.base64Decode(
    'ChRMZWRnZXJBcmNoaXZlUmVxdWVzdBI4Cgl0aW1lc3RhbXAYASABKAsyGi5pY19sZWRnZXIucG'
    'IudjEuVGltZVN0YW1wUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use blockRequestDescriptor instead')
const BlockRequest$json = {
  '1': 'BlockRequest',
  '2': [
    {'1': 'block_height', '3': 1, '4': 1, '5': 4, '10': 'blockHeight'},
  ],
};

/// Descriptor for `BlockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockRequestDescriptor = $convert.base64Decode(
    'CgxCbG9ja1JlcXVlc3QSIQoMYmxvY2tfaGVpZ2h0GAEgASgEUgtibG9ja0hlaWdodA==');

@$core.Deprecated('Use encodedBlockDescriptor instead')
const EncodedBlock$json = {
  '1': 'EncodedBlock',
  '2': [
    {'1': 'block', '3': 1, '4': 1, '5': 12, '10': 'block'},
  ],
};

/// Descriptor for `EncodedBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encodedBlockDescriptor =
    $convert.base64Decode('CgxFbmNvZGVkQmxvY2sSFAoFYmxvY2sYASABKAxSBWJsb2Nr');

@$core.Deprecated('Use blockResponseDescriptor instead')
const BlockResponse$json = {
  '1': 'BlockResponse',
  '2': [
    {
      '1': 'block',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.EncodedBlock',
      '9': 0,
      '10': 'block'
    },
    {
      '1': 'canister_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '9': 0,
      '10': 'canisterId'
    },
  ],
  '8': [
    {'1': 'block_content'},
  ],
};

/// Descriptor for `BlockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockResponseDescriptor = $convert.base64Decode(
    'Cg1CbG9ja1Jlc3BvbnNlEjUKBWJsb2NrGAEgASgLMh0uaWNfbGVkZ2VyLnBiLnYxLkVuY29kZW'
    'RCbG9ja0gAUgVibG9jaxJDCgtjYW5pc3Rlcl9pZBgCIAEoCzIgLmljX2Jhc2VfdHlwZXMucGIu'
    'djEuUHJpbmNpcGFsSWRIAFIKY2FuaXN0ZXJJZEIPCg1ibG9ja19jb250ZW50');

@$core.Deprecated('Use getBlocksRequestDescriptor instead')
const GetBlocksRequest$json = {
  '1': 'GetBlocksRequest',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 4, '10': 'start'},
    {'1': 'length', '3': 2, '4': 1, '5': 4, '10': 'length'},
  ],
};

/// Descriptor for `GetBlocksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBlocksRequestDescriptor = $convert.base64Decode(
    'ChBHZXRCbG9ja3NSZXF1ZXN0EhQKBXN0YXJ0GAEgASgEUgVzdGFydBIWCgZsZW5ndGgYAiABKA'
    'RSBmxlbmd0aA==');

@$core.Deprecated('Use refundDescriptor instead')
const Refund$json = {
  '1': 'Refund',
  '2': [
    {
      '1': 'refund',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '10': 'refund'
    },
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `Refund`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundDescriptor = $convert.base64Decode(
    'CgZSZWZ1bmQSNAoGcmVmdW5kGAIgASgLMhwuaWNfbGVkZ2VyLnBiLnYxLkJsb2NrSGVpZ2h0Ug'
    'ZyZWZ1bmQSFAoFZXJyb3IYAyABKAlSBWVycm9y');

@$core.Deprecated('Use toppedUpDescriptor instead')
const ToppedUp$json = {
  '1': 'ToppedUp',
};

/// Descriptor for `ToppedUp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toppedUpDescriptor =
    $convert.base64Decode('CghUb3BwZWRVcA==');

@$core.Deprecated('Use encodedBlocksDescriptor instead')
const EncodedBlocks$json = {
  '1': 'EncodedBlocks',
  '2': [
    {
      '1': 'blocks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.ic_ledger.pb.v1.EncodedBlock',
      '10': 'blocks'
    },
  ],
};

/// Descriptor for `EncodedBlocks`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encodedBlocksDescriptor = $convert.base64Decode(
    'Cg1FbmNvZGVkQmxvY2tzEjUKBmJsb2NrcxgBIAMoCzIdLmljX2xlZGdlci5wYi52MS5FbmNvZG'
    'VkQmxvY2tSBmJsb2Nrcw==');

@$core.Deprecated('Use getBlocksResponseDescriptor instead')
const GetBlocksResponse$json = {
  '1': 'GetBlocksResponse',
  '2': [
    {
      '1': 'blocks',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.EncodedBlocks',
      '9': 0,
      '10': 'blocks'
    },
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'get_blocks_content'},
  ],
};

/// Descriptor for `GetBlocksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBlocksResponseDescriptor = $convert.base64Decode(
    'ChFHZXRCbG9ja3NSZXNwb25zZRI4CgZibG9ja3MYASABKAsyHi5pY19sZWRnZXIucGIudjEuRW'
    '5jb2RlZEJsb2Nrc0gAUgZibG9ja3MSFgoFZXJyb3IYAiABKAlIAFIFZXJyb3JCFAoSZ2V0X2Js'
    'b2Nrc19jb250ZW50');

@$core.Deprecated('Use iterBlocksRequestDescriptor instead')
const IterBlocksRequest$json = {
  '1': 'IterBlocksRequest',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 4, '10': 'start'},
    {'1': 'length', '3': 2, '4': 1, '5': 4, '10': 'length'},
  ],
};

/// Descriptor for `IterBlocksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iterBlocksRequestDescriptor = $convert.base64Decode(
    'ChFJdGVyQmxvY2tzUmVxdWVzdBIUCgVzdGFydBgBIAEoBFIFc3RhcnQSFgoGbGVuZ3RoGAIgAS'
    'gEUgZsZW5ndGg=');

@$core.Deprecated('Use iterBlocksResponseDescriptor instead')
const IterBlocksResponse$json = {
  '1': 'IterBlocksResponse',
  '2': [
    {
      '1': 'blocks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.ic_ledger.pb.v1.EncodedBlock',
      '10': 'blocks'
    },
  ],
};

/// Descriptor for `IterBlocksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iterBlocksResponseDescriptor = $convert.base64Decode(
    'ChJJdGVyQmxvY2tzUmVzcG9uc2USNQoGYmxvY2tzGAEgAygLMh0uaWNfbGVkZ2VyLnBiLnYxLk'
    'VuY29kZWRCbG9ja1IGYmxvY2tz');

@$core.Deprecated('Use archiveIndexEntryDescriptor instead')
const ArchiveIndexEntry$json = {
  '1': 'ArchiveIndexEntry',
  '2': [
    {'1': 'height_from', '3': 1, '4': 1, '5': 4, '10': 'heightFrom'},
    {'1': 'height_to', '3': 2, '4': 1, '5': 4, '10': 'heightTo'},
    {
      '1': 'canister_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '10': 'canisterId'
    },
  ],
};

/// Descriptor for `ArchiveIndexEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveIndexEntryDescriptor = $convert.base64Decode(
    'ChFBcmNoaXZlSW5kZXhFbnRyeRIfCgtoZWlnaHRfZnJvbRgBIAEoBFIKaGVpZ2h0RnJvbRIbCg'
    'loZWlnaHRfdG8YAiABKARSCGhlaWdodFRvEkEKC2NhbmlzdGVyX2lkGAMgASgLMiAuaWNfYmFz'
    'ZV90eXBlcy5wYi52MS5QcmluY2lwYWxJZFIKY2FuaXN0ZXJJZA==');

@$core.Deprecated('Use archiveIndexResponseDescriptor instead')
const ArchiveIndexResponse$json = {
  '1': 'ArchiveIndexResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ArchiveIndexEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ArchiveIndexResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveIndexResponseDescriptor = $convert.base64Decode(
    'ChRBcmNoaXZlSW5kZXhSZXNwb25zZRI8CgdlbnRyaWVzGAEgAygLMiIuaWNfbGVkZ2VyLnBiLn'
    'YxLkFyY2hpdmVJbmRleEVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use archiveInitDescriptor instead')
const ArchiveInit$json = {
  '1': 'ArchiveInit',
  '2': [
    {
      '1': 'node_max_memory_size_bytes',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'nodeMaxMemorySizeBytes'
    },
    {
      '1': 'max_message_size_bytes',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'maxMessageSizeBytes'
    },
  ],
};

/// Descriptor for `ArchiveInit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveInitDescriptor = $convert.base64Decode(
    'CgtBcmNoaXZlSW5pdBI6Chpub2RlX21heF9tZW1vcnlfc2l6ZV9ieXRlcxgBIAEoDVIWbm9kZU'
    '1heE1lbW9yeVNpemVCeXRlcxIzChZtYXhfbWVzc2FnZV9zaXplX2J5dGVzGAIgASgNUhNtYXhN'
    'ZXNzYWdlU2l6ZUJ5dGVz');

@$core.Deprecated('Use archiveAddRequestDescriptor instead')
const ArchiveAddRequest$json = {
  '1': 'ArchiveAddRequest',
  '2': [
    {
      '1': 'blocks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Block',
      '10': 'blocks'
    },
  ],
};

/// Descriptor for `ArchiveAddRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveAddRequestDescriptor = $convert.base64Decode(
    'ChFBcmNoaXZlQWRkUmVxdWVzdBIuCgZibG9ja3MYASADKAsyFi5pY19sZWRnZXIucGIudjEuQm'
    'xvY2tSBmJsb2Nrcw==');

@$core.Deprecated('Use archiveAddResponseDescriptor instead')
const ArchiveAddResponse$json = {
  '1': 'ArchiveAddResponse',
};

/// Descriptor for `ArchiveAddResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveAddResponseDescriptor =
    $convert.base64Decode('ChJBcmNoaXZlQWRkUmVzcG9uc2U=');

@$core.Deprecated('Use getNodesRequestDescriptor instead')
const GetNodesRequest$json = {
  '1': 'GetNodesRequest',
};

/// Descriptor for `GetNodesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNodesRequestDescriptor =
    $convert.base64Decode('Cg9HZXROb2Rlc1JlcXVlc3Q=');

@$core.Deprecated('Use getNodesResponseDescriptor instead')
const GetNodesResponse$json = {
  '1': 'GetNodesResponse',
  '2': [
    {
      '1': 'nodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.ic_base_types.pb.v1.PrincipalId',
      '10': 'nodes'
    },
  ],
};

/// Descriptor for `GetNodesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNodesResponseDescriptor = $convert.base64Decode(
    'ChBHZXROb2Rlc1Jlc3BvbnNlEjYKBW5vZGVzGAEgAygLMiAuaWNfYmFzZV90eXBlcy5wYi52MS'
    '5QcmluY2lwYWxJZFIFbm9kZXM=');

@$core.Deprecated('Use iCPTsDescriptor instead')
const ICPTs$json = {
  '1': 'ICPTs',
  '2': [
    {'1': 'e8s', '3': 1, '4': 1, '5': 4, '8': {}, '10': 'e8s'},
  ],
  '7': {},
};

/// Descriptor for `ICPTs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCPTsDescriptor = $convert
    .base64Decode('CgVJQ1BUcxIWCgNlOHMYASABKARCBIjiCQFSA2U4czoEgOIJAQ==');

@$core.Deprecated('Use paymentDescriptor instead')
const Payment$json = {
  '1': 'Payment',
  '2': [
    {
      '1': 'receiver_gets',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '8': {},
      '10': 'receiverGets'
    },
  ],
  '7': {},
};

/// Descriptor for `Payment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentDescriptor = $convert.base64Decode(
    'CgdQYXltZW50EkEKDXJlY2VpdmVyX2dldHMYASABKAsyFi5pY19sZWRnZXIucGIudjEuSUNQVH'
    'NCBIjiCQFSDHJlY2VpdmVyR2V0czoEgOIJAQ==');

@$core.Deprecated('Use blockHeightDescriptor instead')
const BlockHeight$json = {
  '1': 'BlockHeight',
  '2': [
    {'1': 'height', '3': 1, '4': 1, '5': 4, '8': {}, '10': 'height'},
  ],
  '7': {},
};

/// Descriptor for `BlockHeight`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockHeightDescriptor = $convert.base64Decode(
    'CgtCbG9ja0hlaWdodBIcCgZoZWlnaHQYASABKARCBIjiCQFSBmhlaWdodDoEgOIJAQ==');

@$core.Deprecated('Use blockDescriptor instead')
const Block$json = {
  '1': 'Block',
  '2': [
    {
      '1': 'parent_hash',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Hash',
      '10': 'parentHash'
    },
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.TimeStamp',
      '10': 'timestamp'
    },
    {
      '1': 'transaction',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Transaction',
      '10': 'transaction'
    },
  ],
};

/// Descriptor for `Block`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockDescriptor = $convert.base64Decode(
    'CgVCbG9jaxI2CgtwYXJlbnRfaGFzaBgBIAEoCzIVLmljX2xlZGdlci5wYi52MS5IYXNoUgpwYX'
    'JlbnRIYXNoEjgKCXRpbWVzdGFtcBgCIAEoCzIaLmljX2xlZGdlci5wYi52MS5UaW1lU3RhbXBS'
    'CXRpbWVzdGFtcBI+Cgt0cmFuc2FjdGlvbhgDIAEoCzIcLmljX2xlZGdlci5wYi52MS5UcmFuc2'
    'FjdGlvblILdHJhbnNhY3Rpb24=');

@$core.Deprecated('Use hashDescriptor instead')
const Hash$json = {
  '1': 'Hash',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 12, '10': 'hash'},
  ],
};

/// Descriptor for `Hash`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hashDescriptor =
    $convert.base64Decode('CgRIYXNoEhIKBGhhc2gYASABKAxSBGhhc2g=');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {
      '1': 'identifier',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'identifier'
    },
    {
      '1': 'balance',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50EkIKCmlkZW50aWZpZXIYASABKAsyIi5pY19sZWRnZXIucGIudjEuQWNjb3VudE'
    'lkZW50aWZpZXJSCmlkZW50aWZpZXISMAoHYmFsYW5jZRgCIAEoCzIWLmljX2xlZGdlci5wYi52'
    'MS5JQ1BUc1IHYmFsYW5jZQ==');

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction$json = {
  '1': 'Transaction',
  '2': [
    {
      '1': 'burn',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Burn',
      '9': 0,
      '10': 'burn'
    },
    {
      '1': 'mint',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Mint',
      '9': 0,
      '10': 'mint'
    },
    {
      '1': 'send',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Send',
      '9': 0,
      '10': 'send'
    },
    {
      '1': 'memo',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.Memo',
      '10': 'memo'
    },
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.BlockHeight',
      '10': 'createdAt'
    },
    {
      '1': 'created_at_time',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.TimeStamp',
      '10': 'createdAtTime'
    },
  ],
  '8': [
    {'1': 'transfer'},
  ],
};

/// Descriptor for `Transaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionDescriptor = $convert.base64Decode(
    'CgtUcmFuc2FjdGlvbhIrCgRidXJuGAEgASgLMhUuaWNfbGVkZ2VyLnBiLnYxLkJ1cm5IAFIEYn'
    'VybhIrCgRtaW50GAIgASgLMhUuaWNfbGVkZ2VyLnBiLnYxLk1pbnRIAFIEbWludBIrCgRzZW5k'
    'GAMgASgLMhUuaWNfbGVkZ2VyLnBiLnYxLlNlbmRIAFIEc2VuZBIpCgRtZW1vGAQgASgLMhUuaW'
    'NfbGVkZ2VyLnBiLnYxLk1lbW9SBG1lbW8SOwoKY3JlYXRlZF9hdBgFIAEoCzIcLmljX2xlZGdl'
    'ci5wYi52MS5CbG9ja0hlaWdodFIJY3JlYXRlZEF0EkIKD2NyZWF0ZWRfYXRfdGltZRgGIAEoCz'
    'IaLmljX2xlZGdlci5wYi52MS5UaW1lU3RhbXBSDWNyZWF0ZWRBdFRpbWVCCgoIdHJhbnNmZXI=');

@$core.Deprecated('Use sendDescriptor instead')
const Send$json = {
  '1': 'Send',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'to'
    },
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'amount'
    },
    {
      '1': 'max_fee',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'maxFee'
    },
  ],
};

/// Descriptor for `Send`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendDescriptor = $convert.base64Decode(
    'CgRTZW5kEjYKBGZyb20YASABKAsyIi5pY19sZWRnZXIucGIudjEuQWNjb3VudElkZW50aWZpZX'
    'JSBGZyb20SMgoCdG8YAiABKAsyIi5pY19sZWRnZXIucGIudjEuQWNjb3VudElkZW50aWZpZXJS'
    'AnRvEi4KBmFtb3VudBgDIAEoCzIWLmljX2xlZGdlci5wYi52MS5JQ1BUc1IGYW1vdW50Ei8KB2'
    '1heF9mZWUYBCABKAsyFi5pY19sZWRnZXIucGIudjEuSUNQVHNSBm1heEZlZQ==');

@$core.Deprecated('Use mintDescriptor instead')
const Mint$json = {
  '1': 'Mint',
  '2': [
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'to'
    },
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'amount'
    },
  ],
};

/// Descriptor for `Mint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mintDescriptor = $convert.base64Decode(
    'CgRNaW50EjIKAnRvGAIgASgLMiIuaWNfbGVkZ2VyLnBiLnYxLkFjY291bnRJZGVudGlmaWVyUg'
    'J0bxIuCgZhbW91bnQYAyABKAsyFi5pY19sZWRnZXIucGIudjEuSUNQVHNSBmFtb3VudA==');

@$core.Deprecated('Use burnDescriptor instead')
const Burn$json = {
  '1': 'Burn',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.AccountIdentifier',
      '10': 'from'
    },
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ic_ledger.pb.v1.ICPTs',
      '10': 'amount'
    },
  ],
};

/// Descriptor for `Burn`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List burnDescriptor = $convert.base64Decode(
    'CgRCdXJuEjYKBGZyb20YASABKAsyIi5pY19sZWRnZXIucGIudjEuQWNjb3VudElkZW50aWZpZX'
    'JSBGZyb20SLgoGYW1vdW50GAMgASgLMhYuaWNfbGVkZ2VyLnBiLnYxLklDUFRzUgZhbW91bnQ=');

@$core.Deprecated('Use accountIdentifierDescriptor instead')
const AccountIdentifier$json = {
  '1': 'AccountIdentifier',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 12, '8': {}, '10': 'hash'},
  ],
  '7': {},
};

/// Descriptor for `AccountIdentifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountIdentifierDescriptor = $convert.base64Decode(
    'ChFBY2NvdW50SWRlbnRpZmllchIYCgRoYXNoGAEgASgMQgSI4gkBUgRoYXNoOgSA4gkB');

@$core.Deprecated('Use subaccountDescriptor instead')
const Subaccount$json = {
  '1': 'Subaccount',
  '2': [
    {'1': 'sub_account', '3': 1, '4': 1, '5': 12, '8': {}, '10': 'subAccount'},
  ],
  '7': {},
};

/// Descriptor for `Subaccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subaccountDescriptor = $convert.base64Decode(
    'CgpTdWJhY2NvdW50EiUKC3N1Yl9hY2NvdW50GAEgASgMQgSI4gkBUgpzdWJBY2NvdW50OgSA4g'
    'kB');

@$core.Deprecated('Use memoDescriptor instead')
const Memo$json = {
  '1': 'Memo',
  '2': [
    {'1': 'memo', '3': 1, '4': 1, '5': 4, '8': {}, '10': 'memo'},
  ],
  '7': {},
};

/// Descriptor for `Memo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memoDescriptor = $convert
    .base64Decode('CgRNZW1vEhgKBG1lbW8YASABKARCBIjiCQFSBG1lbW86BIDiCQE=');

@$core.Deprecated('Use timeStampDescriptor instead')
const TimeStamp$json = {
  '1': 'TimeStamp',
  '2': [
    {'1': 'timestamp_nanos', '3': 1, '4': 1, '5': 4, '10': 'timestampNanos'},
  ],
};

/// Descriptor for `TimeStamp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeStampDescriptor = $convert.base64Decode(
    'CglUaW1lU3RhbXASJwoPdGltZXN0YW1wX25hbm9zGAEgASgEUg50aW1lc3RhbXBOYW5vcw==');

@$core.Deprecated('Use certificationDescriptor instead')
const Certification$json = {
  '1': 'Certification',
  '2': [
    {'1': 'certification', '3': 1, '4': 1, '5': 12, '10': 'certification'},
  ],
};

/// Descriptor for `Certification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List certificationDescriptor = $convert.base64Decode(
    'Cg1DZXJ0aWZpY2F0aW9uEiQKDWNlcnRpZmljYXRpb24YASABKAxSDWNlcnRpZmljYXRpb24=');
