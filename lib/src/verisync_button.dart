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

  Future<void> loadVerisyncView(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    var status = await Permission.camera.status;
    switch (status) {
      case PermissionStatus.granted:
        if (!context.mounted) return;
        showVerisyncView(context);
        break;
      case PermissionStatus.denied:
        await Permission.camera.request().then(
            (value) => value.isGranted ? showVerisyncView(context) : null);
        break;
      case PermissionStatus.permanentlyDenied:
        if (!context.mounted) return;
        showAdaptiveDialog(
          context: context,
          builder: (builder) => AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text('Please enable camera permission to continue'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await openAppSettings()
                      .then((value) => Navigator.of(context).pop());
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        break;
      default:
        break;
    }
  }

  void showVerisyncView(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext dialogContext) => VerisyncView(
        flowId: flowId,
        redirectUrl: redirectUrl,
        clientId: clientId,
        email: email,
        metadata: metadata,
        onSuccess: onSuccess ??
            (BuildContext dialogContext) {
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                const SnackBar(
                  content: Text("Verification successful"),
                  duration: Duration(seconds: 3),
                ),
              );
            },
        onError: onError ??
            (BuildContext dialogContext) {
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                const SnackBar(
                  content: Text("Verification failed"),
                  duration: Duration(seconds: 3),
                ),
              );
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Verify your identity'),
      onPressed: () {
        loadVerisyncView(context);
      },
    );
  }
}
