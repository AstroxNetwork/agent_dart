///
//  Generated code. Do not modify.
//  source: ic_base_types/pb/v1/types.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PrincipalId extends $pb.GeneratedMessage {
  PrincipalId._();
  factory PrincipalId({
    $core.List<$core.int>? serializedId,
  }) {
    final _result = create();
    if (serializedId != null) {
      _result.serializedId = serializedId;
    }
    return _result;
  }
  factory PrincipalId.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(i, r);
  factory PrincipalId.fromJson(
    $core.String i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(i, r);
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    const $core.bool.fromEnvironment('protobuf.omit_message_names')
        ? ''
        : 'PrincipalId',
    package: const $pb.PackageName(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ic_base_types.pb.v1',
    ),
    createEmptyInstance: create,
  )
    ..a<$core.List<$core.int>>(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_field_names')
          ? ''
          : 'serializedId',
      $pb.PbFieldType.OY,
    )
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
          as PrincipalId; // ignore: deprecated_member_use
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
    const $core.bool.fromEnvironment('protobuf.omit_message_names')
        ? ''
        : 'google.protobuf.MessageOptions',
    const $core.bool.fromEnvironment('protobuf.omit_field_names')
        ? ''
        : 'tuiSignedMessage',
    20000,
    $pb.PbFieldType.OB,
  );
  static final tuiSignedDisplayQ22021 = $pb.Extension<$core.bool>(
    const $core.bool.fromEnvironment('protobuf.omit_message_names')
        ? ''
        : 'google.protobuf.FieldOptions',
    const $core.bool.fromEnvironment('protobuf.omit_field_names')
        ? ''
        : 'tuiSignedDisplayQ22021',
    20001,
    $pb.PbFieldType.OB,
    protoName: 'tui_signed_display_q2_2021',
  );
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(tuiSignedMessage);
    registry.add(tuiSignedDisplayQ22021);
  }
}
