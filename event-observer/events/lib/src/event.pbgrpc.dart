//
//  Generated code. Do not modify.
//  source: event.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'event.pb.dart' as $1;
import 'google/protobuf/empty.pb.dart' as $0;

export 'event.pb.dart';

@$pb.GrpcServiceName('events.EventService')
class EventServiceClient extends $grpc.Client {
  static final _$observe = $grpc.ClientMethod<$0.Empty, $1.Event>(
      '/events.EventService/Observe',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Event.fromBuffer(value));

  EventServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$1.Event> observe($0.Empty request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$observe, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('events.EventService')
abstract class EventServiceBase extends $grpc.Service {
  $core.String get $name => 'events.EventService';

  EventServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.Event>(
        'Observe',
        observe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.Event value) => value.writeToBuffer()));
  }

  $async.Stream<$1.Event> observe_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* observe(call, await request);
  }

  $async.Stream<$1.Event> observe($grpc.ServiceCall call, $0.Empty request);
}
