import 'dart:async';
import 'dart:io';

import 'package:client/generated/event.pbgrpc.dart';
import 'package:client/src/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<Event> stream;

  @override
  void initState() {
    super.initState();

    stream = EventService.instance.observe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Server clock"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (!snapshot.hasData) {
              print(snapshot);
              if( snapshot.connectionState == ConnectionState.done) {
                print("Connection lost. Exiting...");
                exit(-1);
              }

              return const CircularProgressIndicator();
            }
            var time =
                DateFormat('HH:mm:ss').format(snapshot.data!.time.toDateTime());
            return Text("Time on the server\n$time",
                style: const TextStyle(fontSize: 50, color: Colors.blue));
          },
        ),
      ),
    );
  }
}
