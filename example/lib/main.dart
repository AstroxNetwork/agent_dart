// import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/identity/ed25519.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:agent_dart/utils/extension.dart';
// import 'package:url_launcher/link.dart';
// import 'package:url_launcher/url_launcher.dart';
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
  String _status = "No Status";
  String _pub = "";
  late Counter _counter;

  @override
  void initState() {
    super.initState();
    initCounter();
    loading(true);
    readCount();
  }

  void initCounter() {
    var agent = AgentFactory.create(
        canisterId: "ryjl3-tyaaa-aaaaa-aaaba-cai", url: "http://localhost:60916", idl: idl);

    _counter = agent.hook(Counter());
    _pub =
        (agent.identity as Ed25519KeyIdentity).getPublicKey().toDer().buffer.asUint8List().toHex();
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

  void authenticate() async {
    final url =
        'http://rkp4c-7iaaa-aaaaa-aaaca-cai.localhost:8000/#authorize?callback_uri=identity://auth&&sessionPublicKey=$_pub';
    const callbackUrlScheme = 'identity';

    try {
      final result =
          await FlutterWebAuth.authenticate(url: url, callbackUrlScheme: callbackUrlScheme);

      // var resultUri = Uri.parse(result);

      // if (resultUri.queryParameters["success"] == "true") {
      //   var payload = resultUri.queryParameters["payload"];
      //   var decoded = cborDecode<Map<String, dynamic>>((payload as String).toU8a());
      // }

      setState(() {
        _status = 'Got result: $result';
      });

      // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Got error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dfinity flutter Dapp'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(_loading ? 'loading contract count' : '$_count'),
            Container(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  authenticate();
                },
                child: const Text("Authroize"))
          ]),
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
