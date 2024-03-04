import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

part 'verisync_view.dart';

class VerisyncButton extends StatelessWidget {
  final String redirectUrl, flowId, clientId;

  final String? email;

  final void Function(BuildContext context)? onSuccess, onError, onClose;

  final Map<dynamic, dynamic>? metadata;

  final ButtonStyle? style;

  final Widget? child;

  /// [VerisyncButton] Creates a new Verisync button widget.
  /// The [VerisyncButton.redirectUrl] to redirect to after the verification process. This URL must be whitelisted in the Verisync dashboard.
  /// This is a required parameter. The [VerisyncButton.flowID] for the verification process. This is a required parameter.
  /// The [VerisyncButton.clientId] for the verification process. This is a required parameter.
  /// The [VerisyncButton.email] of the user to verify. This is an optional parameter.
  /// The [VerisyncButton.onSuccess] callback to be called when the verification process is successful. This is an optional parameter.
  /// The [VerisyncButton.onError] callback to be called when the verification process fails. This is an optional parameter.
  /// The [VerisyncButton.onClose] callback to be called when the verification user specifically closes the verification dialog. This is an optional parameter.
  /// The [VerisyncButton.metadata] to be sent to the Verisync API. This is an optional parameter.
  /// The [VerisyncButton.style] to be applied to the button. This is an optional parameter.
  /// The [VerisyncButton.child] to be displayed on the button. This is an optional parameter.
  const VerisyncButton({
    super.key,
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    this.onSuccess,
    this.onError,
    this.onClose,
    this.email,
    this.metadata,
    this.style,
    this.child,
  });

  /// Loads the Verisync view.
  Future<void> _loadVerisyncView(BuildContext context) async {
    /// Ensure that the widgets binding is initialized.
    WidgetsFlutterBinding.ensureInitialized();

    /// Request for camera permission.
    var status = await Permission.camera.status;

    /// Check the status of the camera permission.
    switch (status) {
      /// If the permission is granted, show the Verisync view.
      case PermissionStatus.granted:

        /// If the permission is denied, request for the permission.
        if (!context.mounted) return;

        /// If the permission is granted, show the Verisync view.
        _showVerisyncView(context);
        break;

      /// If the permission is denied, request for the permission.
      case PermissionStatus.denied:

        /// If the permission is denied, request for the permission.
        await Permission.camera.request().then((value) => value.isGranted ? _showVerisyncView(context) : null);
        break;

      /// If the permission is permanently denied, show a dialog to open the settings.
      case PermissionStatus.permanentlyDenied:
        if (!context.mounted) return;

        /// If the permission is permanently denied, show a dialog to open the settings.
        _showOpenSettingsForCameraPermission(context);
        break;
      default:
        break;
    }
  }

  /// [_showOpenSettingsForCameraPermission]Shows a dialog to open the settings for the camera permission.
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
            /// Opens the settings for the camera permission.
            onPressed: () async {
              await openAppSettings().then((value) => Navigator.of(context).pop());
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// [_showVerisyncView] Shows the Verisync view.
  void _showVerisyncView(BuildContext context) {
    /// Shows the Verisync view.
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext dialogContext) => _VerisyncView(
        flowId: flowId,
        redirectUrl: redirectUrl,
        clientId: clientId,
        email: email,
        metadata: metadata,
        onSuccess: onSuccess,
        onError: onError,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () {
        /// Loads the Verisync view.
        _loadVerisyncView(context);
      },
      child: child ?? const Text('Verify your identity'),
    );
  }
}
