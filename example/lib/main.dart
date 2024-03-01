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
                flowId: "3ea0117e-e04c-4d22-aec9-08fd5b2ab2da",
                redirectUrl: "https://synchronizer-demo.vercel.app/success",
                clientId: "71156b6946cc8917755d1ff815cd62cb",
              ),
            ],
          ),
        ));
  }
}
