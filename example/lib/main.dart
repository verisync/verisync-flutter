import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:verisync/verisync.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.camera.status;
  if (status.isDenied) {
    await Permission.camera.request();
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => VerisyncWidget(
                      flowId: "3ea0117e-e04c-4d22-aec9-08fd5b2ab2da",
                      redirectUrl:
                          "https://synchronizer-demo.vercel.app/success",
                      clientId: "71156b6946cc8917755d1ff815cd62cb",
                      callbackSuccess: (dialogContext) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text("Verification successful"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Text('Verify your identity'),
              ),
            ],
          ),
        ));
  }
}
