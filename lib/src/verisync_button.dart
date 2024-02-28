import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
part 'verisync_view.dart';

class VerisyncButton extends StatelessWidget {
  final String redirectUrl, flowId, clientId;
  final String? email;
  final void Function(BuildContext context)? onSuccess;
  final void Function(BuildContext context)? onError;
  final Map<dynamic, dynamic>? metadata;
  const VerisyncButton({
    super.key,
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    this.onSuccess,
    this.onError,
    this.email,
    this.metadata,
  });

  Future<void> requestPermissions() async {
    WidgetsFlutterBinding.ensureInitialized();
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Verify your identity'),
      onPressed: () async {
        await requestPermissions().then(
          (value) => showAdaptiveDialog(
            context: context,
            builder: (BuildContext dialogContext) => VerisyncView(
              flowId: flowId,
              redirectUrl: redirectUrl,
              clientId: clientId,
              email: email,
              metadata: metadata,
              onSuccess: onSuccess ??
                  (dialogContext) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification successful"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
              onError: onError ??
                  (dialogContext) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification failed"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
            ),
          ),
        );
      },
    );
  }
}
