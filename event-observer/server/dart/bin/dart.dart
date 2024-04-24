import 'package:dart/generated/event.pbgrpc.dart';
import 'package:dart/generated/google/protobuf/empty.pb.dart';
import 'package:dart/generated/google/protobuf/timestamp.pb.dart';
import 'package:grpc/grpc.dart';

class EventService extends EventServiceBase {
  @override
  Stream<Event> observe(ServiceCall call, Empty request) async* {
    // runs until program gets killed
    while (true) {
      // wait for a second
      await Future.delayed(Duration(seconds: 1));

      // send new time event
      yield Event(time: Timestamp.fromDateTime(DateTime.now()));
    }
  }
}

Future<void> main(List<String> args) async {
  final server = Server.create(
      services: [EventService()],
      interceptors: const <Interceptor>[],
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]));

  await server.serve(port: 50051);
  print('Server listening on port ${server.port}...');
}
