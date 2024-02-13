library verisync_widget;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VerisyncWidget extends StatefulWidget {
  final String redirectUrl, flowId, clientId;
  final String? email;
  final void Function(BuildContext context) callbackSuccess;
  final void Function(BuildContext context)? callbackError;
  final Map<dynamic, dynamic>? metadata;

  /// This file contains the [VerisyncWidget] class, which is a Flutter widget that displays a fullscreen dialog with an embedded web view.
  /// The web view is used to authorize a user and perform a callback upon successful authorization.
  /// The widget requires the following parameters:
  /// - [redirectUrl] : The URL to redirect to after successful authorization.
  /// - [flowId] : The ID of the authorization flow.
  /// - [clientId] : The ID of the client.
  /// - optional [email] : The email of the client.
  /// - [callbackSuccess] : A callback function that is called upon successful authorization.
  /// - optional [callbackError] : An optional callback function that is called if there is an error during authorization.
  /// The widget also includes methods for handling actions such as closing the dialog and refreshing the web view.
  /// The progress of the web view loading is displayed using a progress bar.

  const VerisyncWidget({
    Key? key,
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    required this.callbackSuccess,
    this.callbackError,
    this.email,
    this.metadata,
  }) : super(key: key);

  @override
  State<VerisyncWidget> createState() => _VerisyncWidgetState();
}

class _VerisyncWidgetState extends State<VerisyncWidget> {
  late InAppWebViewController _webViewController;
  final GlobalKey _webViewKey = GlobalKey();
  double _progress = 0;

  final InAppWebViewSettings _settings =
      InAppWebViewSettings(iframeAllow: "camera", iframeAllowFullscreen: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog.fullscreen(
        child: Column(
          children: [
            _buildActionBar(context),
            Expanded(
              child: _buildWebView(),
            ),
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.callbackError?.call(context);
            _handleClose(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _handleRefresh,
        ),
      ],
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      key: _webViewKey,
      initialUrlRequest: URLRequest(
        url: WebUri(
          "https://app.verisync.co/synchronizer/authorize?flow_id=${widget.flowId}&client_id=${widget.clientId}&redirect_url=${widget.redirectUrl}&email=${widget.email}&metadata=${json.encode(widget.metadata)}",
        ),
      ),
      initialSettings: _settings,
      onWebViewCreated: (controller) => _webViewController = controller,
      onLoadStart: (controller, url) => setState(() {}),
      onLoadStop: (controller, url) async {
        if (url?.rawValue == widget.redirectUrl) {
          widget.callbackSuccess(context);
          _handleClose(context);
        }
      },
      onProgressChanged: (controller, progress) => setState(() {
        _progress = progress / 100;
      }),
    );
  }

  Widget _buildProgressBar() {
    return _progress < 1.0
        ? LinearProgressIndicator(value: _progress)
        : Container();
  }

  void _handleClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleRefresh() {
    _webViewController.reload();
  }
}
