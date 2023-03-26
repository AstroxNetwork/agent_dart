// import 'package:flutter/material.dart';

// import 'counter.dart';
// import 'init.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _count = 0;
//   bool _loading = false;

//   Counter? _counter;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     loading(true);
//     readCount();
//   }

//   Future<void> initCounter() async {
//     _counter = (await AgentFactory.create(
//       canisterId: 'sbzkb-zqaaa-aaaaa-aaaiq-cai',
//       url: 'https://03af-58-62-205-141.ngrok.io',
//       // For Android emulator, please use 10.0.2.2 as endpoint
//       idl: idl,
//     ))
//         .hook(Counter());
//   }

//   void loading(bool state) {
//     setState(() {
//       _loading = state;
//     });
//   }

//   Future<void> readCount() async {
//     if (_counter == null) {
//       await initCounter();
//     }
//     final int c = await _counter!.count();
//     loading(false);
//     setState(() {
//       _count = c;
//     });
//   }

//   void increase() async {
//     loading(true);
//     await _counter!.add();
//     readCount();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: const Text('Dfinity flutter Dapp'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(_loading ? 'loading contract count' : '$_count'),
//               Container(
//                 height: 30,
//               ),
//               Container(
//                 height: 30,
//               ),
//               const Text('Please Login 👆'),
//               Container(height: 30),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed: () async {
//             increase();
//           },
//         ),
//       ),
//     );
//   }
// }
