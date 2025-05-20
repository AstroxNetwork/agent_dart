import 'package:agent_dart/agent_dart.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AgentDart.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String phrase = generateMnemonic();

  void _refreshMnemonic() {
    phrase = generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Phrase: $phrase',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                FutureBuilder(
                  future: mnemonicPhraseToSeed(
                    req: PhraseToSeedReq(phrase: phrase, password: ''),
                  ),
                  builder: (context, snapshot) =>
                      Text('Seed: ${snapshot.data?.toHex()}'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _refreshMnemonic();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
