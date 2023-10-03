//
//  Generated code. Do not modify.
//  source: ic_base_types/pb/v1/types.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// A PB container for a PrincipalId, which uniquely identifies
/// a principal.
class PrincipalId extends $pb.GeneratedMessage {
  factory PrincipalId({
    $core.List<$core.int>? serializedId,
  }) {
    final $result = create();
    if (serializedId != null) {
      $result.serializedId = serializedId;
    }
    return $result;
  }
  PrincipalId._() : super();
  factory PrincipalId.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PrincipalId.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'ic_base_types.pb.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'serializedId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PrincipalId clone() => PrincipalId()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PrincipalId copyWith(void Function(PrincipalId) updates) =>
      super.copyWith((message) => updates(message as PrincipalId))
          as PrincipalId;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalId create() => PrincipalId._();
  PrincipalId createEmptyInstance() => create();
  static $pb.PbList<PrincipalId> createRepeated() => $pb.PbList<PrincipalId>();
  @$core.pragma('dart2js:noInline')
  static PrincipalId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalId>(create);
  static PrincipalId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get serializedId => $_getN(0);
  @$pb.TagNumber(1)
  set serializedId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSerializedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSerializedId() => clearField(1);
}

class Types {
  static final tuiSignedMessage = $pb.Extension<$core.bool>(
      _omitMessageNames ? '' : 'google.protobuf.MessageOptions',
      _omitFieldNames ? '' : 'tuiSignedMessage',
      20000,
      $pb.PbFieldType.OB);
  static final tuiSignedDisplayQ22021 = $pb.Extension<$core.bool>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'tuiSignedDisplayQ22021',
      20001,
      $pb.PbFieldType.OB,
      protoName: 'tui_signed_display_q2_2021');
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(tuiSignedMessage);
    registry.add(tuiSignedDisplayQ22021);
  }
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
