import 'package:flutter/material.dart';
import 'counter.dart';
import 'init.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _count = 0;
  bool _loading = false;
  late Counter _counter;

  @override
  void initState() {
    super.initState();
    initCounter();
    loading(true);
    readCount();
  }

  void initCounter() {
    _counter = AgentFactory.create(
            canisterId: "ryjl3-tyaaa-aaaaa-aaaba-cai", url: "http://192.168.3.11:60916", idl: idl)
        .hook(Counter());
  }

  void loading(bool state) {
    setState(() {
      _loading = state;
    });
  }

  void readCount() async {
    int c = await _counter.count();
    loading(false);
    setState(() {
      _count = c;
    });
  }

  void increase() async {
    loading(true);
    await _counter.add();
    readCount();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dfinity flutter Dapp'),
        ),
        body: Center(
          child: Text(_loading ? 'loading contract count' : '$_count'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            increase();
          },
        ),
      ),
    );
  }
}
