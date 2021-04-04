import 'dart:isolate';

import 'package:flutter/material.dart';

import 'Isolate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  BackgroundService _backgroundService = new BackgroundService();

  @override
  void dispose() {
    _backgroundService.stopIsolete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Isolate Demo By WenYeh'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              elevation: 0,
              onPressed: _incrementCounter,
              tooltip: 'play',
              child: Icon(Icons.play_arrow),
            ),
            SizedBox(
              width: 30,
            ),
            FloatingActionButton(
              elevation: 0,
              onPressed: _stopIsolate,
              tooltip: 'stop',
              child: Icon(Icons.stop),
            ),
          ],
        ));
  }

  void _incrementCounter() async {
    ReceivePort res = await _backgroundService.startIsolate();

    res.listen((message) {
      setState(() {
        _counter = message["timer"];
      });
    });
  }

  void _stopIsolate() {
    _backgroundService.stopIsolete();
  }
}
