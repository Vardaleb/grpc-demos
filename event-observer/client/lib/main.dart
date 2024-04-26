import 'dart:async';
import 'dart:io';

import 'package:client/src/event_service.dart';
import 'package:client/src/ui/result_table.dart';
import 'package:events/all.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EventObserverClient());
}

class EventObserverClient extends StatelessWidget {
  const EventObserverClient({super.key});

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
      home: const EventObserverClientHomePage(),
    );
  }
}

class EventObserverClientHomePage extends StatefulWidget {
  const EventObserverClientHomePage({super.key});

  @override
  State<EventObserverClientHomePage> createState() =>
      _EventObserverClientHomePageState();
}

class _EventObserverClientHomePageState
    extends State<EventObserverClientHomePage> {
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
              if (snapshot.connectionState == ConnectionState.done) {
                // ignore: avoid_print
                print("Connection lost. Exiting...");
                exit(-1);
              }

              return const CircularProgressIndicator();
            }
            var event = snapshot.data!;

            return ResultTable(event: event);
          },
        ),
      ),
    );
  }
}
