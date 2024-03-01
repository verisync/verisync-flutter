import 'dart:async';
import 'package:flutter/material.dart';
import 'package:verisync/verisync.dart';

Future main() async {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verisync Example'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              VerisyncButton(
                flowId: "<your flowId>",
                redirectUrl: "your redirectUrl",
                clientId: "your clientId",
              ),
            ],
          ),
        ));
  }
}
