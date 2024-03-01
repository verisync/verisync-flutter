part of "../src/verisync_button.dart";

/// This class represents the Verisync view.
///
/// The Verisync view is a stateful widget that displays a fullscreen dialog
/// containing a web view. It is used to authorize a user and perform certain
/// actions based on the success or failure of the authorization process.
///
/// The Verisync view requires the following parameters:
/// - [redirectUrl]: The URL to redirect to after the authorization process.
/// - [flowId]: The ID of the flow to be used for authorization.
/// - [clientId]: The ID of the client for which the authorization is being performed.
/// - [onSuccess]: A callback function to be called when the authorization is successful.
/// - [onError]: A callback function to be called when an error occurs during the authorization process.
/// - [email]: The email address of the user performing the authorization (optional).
/// - [metadata]: Additional metadata to be passed during the authorization process (optional).
///
/// The Verisync view internally uses the InAppWebView package to display the web content.
/// It also includes an action bar with close and refresh buttons, and a progress bar
/// to indicate the loading progress of the web view.

class _VerisyncView extends StatefulWidget {
  final String redirectUrl, flowId, clientId;
  final String? email;
  final void Function(BuildContext context) onSuccess;
  final void Function(BuildContext context) onError;
  final Map<dynamic, dynamic>? metadata;

  const _VerisyncView({
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    required this.onSuccess,
    required this.onError,
    this.email,
    this.metadata,
  });

  @override
  State<_VerisyncView> createState() => _VerisyncViewState();
}

class _VerisyncViewState extends State<_VerisyncView> {
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
            widget.onError.call(context);
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
    var webUri = WebUri(
      "https://app.verisync.co/synchronizer/authorize?flow_id=${widget.flowId}&client_id=${widget.clientId}&redirect_url=${widget.redirectUrl}&email=${widget.email}&metadata=${json.encode(widget.metadata)}",
    );

    return InAppWebView(
      key: _webViewKey,
      initialUrlRequest: URLRequest(
        url: webUri,
      ),
      initialSettings: _settings,
      onWebViewCreated: (controller) => _webViewController = controller,
      onLoadStart: (controller, url) => setState(() {}),
      onLoadStop: (controller, url) async {
        if (url?.rawValue == widget.redirectUrl) {
          widget.onSuccess(context);
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
