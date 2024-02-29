import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

part 'verisync_view.dart';

/// A button widget for Verisync identity verification.
///
/// This button widget is used to initiate the Verisync identity verification process.
/// It requires the [redirectUrl], [flowId], and [clientId] parameters to be provided.
/// Optionally, you can provide an [email] address, [metadata], [onSuccess] and [onError] callbacks,
/// a custom [style], and a [child] widget to customize the button's appearance and behavior.
///
/// When the button is pressed, it checks for camera permission and handles the permission status accordingly.
/// If the camera permission is granted, it shows the Verisync identity verification view.
/// If the camera permission is denied, it requests the camera permission and shows the view if granted.
/// If the camera permission is permanently denied, it prompts the user to open the app settings to enable the camera permission.
///
/// The Verisync identity verification view is shown using a dialog and the [VerisyncView] widget.
/// The [flowId], [redirectUrl], [clientId], [email], [metadata], [onSuccess], and [onError] parameters are passed to the [VerisyncView].
/// If [onSuccess] is not provided, a default success snackbar is shown.
/// If [onError] is not provided, a default error snackbar is shown.
///
/// Example usage:
/// ```dart
/// VerisyncButton(
///   redirectUrl: 'https://example.com/redirect',
///   flowId: '123456',
///   clientId: 'abcdef',
///   email: 'john@example.com',
///   onSuccess: (context) {
///     // Handle verification success
///   },
///   onError: (context) {
///     // Handle verification error
///   },
///   style: ButtonStyle(
///     backgroundColor: MaterialStateProperty.all(Colors.blue),
///   ),
///   child: Text('Verify Identity'),
/// )
/// ```
class VerisyncButton extends StatelessWidget {
  final String redirectUrl, flowId, clientId;
  final String? email;
  final void Function(BuildContext context)? onSuccess, onError;
  final Map<dynamic, dynamic>? metadata;
  final ButtonStyle? style;
  final Widget? child;
  const VerisyncButton({
    super.key,
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    this.onSuccess,
    this.onError,
    this.email,
    this.metadata,
    this.style,
    this.child,
  });

  Future<void> _loadVerisyncView(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    var status = await Permission.camera.status;
    switch (status) {
      case PermissionStatus.granted:
        if (!context.mounted) return;
        _showVerisyncView(context);
        break;
      case PermissionStatus.denied:
        await Permission.camera.request().then(
            (value) => value.isGranted ? _showVerisyncView(context) : null);
        break;
      case PermissionStatus.permanentlyDenied:
        if (!context.mounted) return;
        _showOpenSettingsForCameraPermission(context);
        break;
      default:
        break;
    }
  }

  void _showOpenSettingsForCameraPermission(BuildContext context) {
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
  }

  void _showVerisyncView(BuildContext context) {
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
      style: style,
      onPressed: () {
        _loadVerisyncView(context);
      },
      child: child ?? const Text('Verify your identity'),
    );
  }
}
