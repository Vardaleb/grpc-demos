import 'dart:async';

import 'package:flutter/material.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int i = 0;
  late StreamSubscription streamSubscription;
  final streamController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      streamController.add(i++);
      if (i > 10) {
        timer.cancel();
        streamController.close();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Clock"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (streamController.isClosed) {
              return const Icon(
                Icons.done,
                color: Colors.greenAccent,
              );
            }
            return Text("Data: ${snapshot.data}",
                style: const TextStyle(fontSize: 50, color: Colors.blue));
          },
        ),
      ),
    );
  }
}
