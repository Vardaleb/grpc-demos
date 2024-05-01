import 'dart:io';

import 'package:dart_grpc/gen/v1/hello.pbgrpc.dart';
import 'package:grpc/grpc.dart';

Future<void> main(List<String> arguments) async {
  print("Connecting to localhost:50051");
  var channel = ClientChannel("localhost",
      port: 50051,
      options:
          const ChannelOptions(credentials: ChannelCredentials.insecure()));

  var greeterClient = GreeterClient(channel);
  var result = await greeterClient.greet(Greeting(message: "Dart-Client"));
  print('Server said: ${result.message}');
  exit(0);
}
