//
//  Generated code. Do not modify.
//  source: event.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $2;

class Event extends $pb.GeneratedMessage {
  factory Event({
    $2.Timestamp? time,
    $core.int? offsetSeconds,
    $core.String? timezoneName,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (offsetSeconds != null) {
      $result.offsetSeconds = offsetSeconds;
    }
    if (timezoneName != null) {
      $result.timezoneName = timezoneName;
    }
    return $result;
  }
  Event._() : super();
  factory Event.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Event.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Event', package: const $pb.PackageName(_omitMessageNames ? '' : 'events'), createEmptyInstance: create)
    ..aOM<$2.Timestamp>(1, _omitFieldNames ? '' : 'time', subBuilder: $2.Timestamp.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'offsetSeconds', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'timezoneName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Event clone() => Event()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Event copyWith(void Function(Event) updates) => super.copyWith((message) => updates(message as Event)) as Event;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  Event createEmptyInstance() => create();
  static $pb.PbList<Event> createRepeated() => $pb.PbList<Event>();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Timestamp get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($2.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
  @$pb.TagNumber(1)
  $2.Timestamp ensureTime() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get offsetSeconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set offsetSeconds($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOffsetSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffsetSeconds() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get timezoneName => $_getSZ(2);
  @$pb.TagNumber(3)
  set timezoneName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimezoneName() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimezoneName() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
