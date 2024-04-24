import 'package:client/generated/event.pbgrpc.dart';
import 'package:client/generated/google/protobuf/empty.pb.dart';
import 'package:grpc/grpc.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  late ClientChannel _channel;
  late EventServiceClient _stub;

  EventService._internal() {
    _init();
  }

  void _init() {
    _channel = ClientChannel('localhost',
        port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    _stub = EventServiceClient(_channel);
  }

  factory EventService() => _instance;

  static EventService get instance => _instance;
  EventServiceClient get stub => _stub;

  ResponseStream<Event> observe() {
    return stub.observe(Empty.getDefault());
  }
}
