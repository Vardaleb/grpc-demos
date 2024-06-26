import 'package:events/all.dart';
import 'package:grpc/grpc.dart';

class EventService extends EventServiceBase {
  @override
  Stream<Event> observe(ServiceCall call, Empty request) async* {
    // runs until program gets killed
    while (true) {
      // wait for a second
      await Future.delayed(Duration(seconds: 1));

      // send new time event
      var dateTime = DateTime.now();
      yield Event(
          time: Timestamp.fromDateTime(dateTime),
          offsetSeconds: dateTime.timeZoneOffset.inSeconds,
          timezoneName: dateTime.timeZoneName);
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
