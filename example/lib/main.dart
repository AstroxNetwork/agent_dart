import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:agent_dart/agent_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HttpAgent? _agent;
  CanisterActor? _actor;
  int _count = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    initAgent();
  }

  void initAgent() async {
    var id = Ed25519KeyIdentity.generate(null);
    _agent = HttpAgent(
        defaultProtocol: 'http',
        defaultHost: '192.168.2.216',
        deaultPort: ':60916',
        options: HttpAgentOptions()..identity = id);
    if (_agent != null) {
      await _agent?.fetchRootKey();
      loading(true);
      _agent?.addTransform(HttpAgentRequestTransformFn()..call = makeNonceTransform());
      createActor(_agent!);
      readCount();
    }
  }

  loading(bool state) {
    setState(() {
      _loading = state;
    });
  }

  createActor(HttpAgent agent) {
    var canisterId = Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai");
    // var canisterId = await Actor.createCanister(CallConfig.fromMap({"agent": agent}));
    // Actor.install(FieldOptions.fromMap({"module": blobFromUint8Array(wasm)}),
    //     ActorConfig.fromMap({"canisterId": canisterId, "agent": agent}));

    var idl = IDL.Service({
      'getValue': IDL.Func([], [IDL.Nat], ['query']),
      'increment': IDL.Func([], [], []),
    });

    _actor =
        Actor.createActor(idl, ActorConfig.fromMap({"canisterId": canisterId, "agent": agent}));
  }

  void readCount() async {
    var c = (await _actor?.getFunc("getValue")?.call([]) as BigInt).toInt();
    loading(false);
    setState(() {
      _count = c;
    });
  }

  void increase() async {
    loading(true);
    await _actor?.getFunc("increment")?.call([]);
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
          onPressed: () {
            increase();
          },
        ),
      ),
    );
  }
}
