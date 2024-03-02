part of "../src/verisync_button.dart";

class _VerisyncView extends StatefulWidget {
  final String redirectUrl, flowId, clientId;
  final String? email;
  final void Function(BuildContext context)? onSuccess, onError;
  final Map<dynamic, dynamic>? metadata;

  /// [_VerisyncView] Creates a new Verisync view widget.
  /// The [redirectUrl] to redirect to after the verification process. This URL must be whitelisted in the Verisync dashboard.
  /// This is a required parameter. The [flowID] for the verification process. This is a required parameter.
  /// The [clientId] for the verification process. This is a required parameter.
  /// The [email] of the user to verify. This is an optional parameter.
  /// The [onSuccess] callback to be called when the verification process is successful. This is an optional parameter.
  /// The [onError] callback to be called when the verification process fails. This is an optional parameter.
  /// The [metadata] to be sent to the Verisync API. This is an optional parameter.
  const _VerisyncView({
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    this.onSuccess,
    this.onError,
    this.email,
    this.metadata,
  });

  @override
  State<_VerisyncView> createState() => _VerisyncViewState();
}

/// The state for the Verisync view widget.
class _VerisyncViewState extends State<_VerisyncView> {
  late InAppWebViewController _webViewController;
  final GlobalKey _webViewKey = GlobalKey();
  double _progress = 0;

  /// The settings for the web view.
  final InAppWebViewSettings _settings = InAppWebViewSettings(iframeAllow: "camera", iframeAllowFullscreen: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog.fullscreen(
        child: Column(
          children: [
            /// The action bar.
            _buildActionBar(context),
            Expanded(
              /// The web view.
              child: _buildWebView(),
            ),

            /// The progress bar.
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  /// Builds the action bar.
  Widget _buildActionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.close),

          /// Closes the view.
          onPressed: () {
            widget.onError?.call(context);
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

  /// Builds the web view.
  Widget _buildWebView() {
    var newRedirectUrl = "${widget.redirectUrl}?verisync-redirect";
    var webUri = WebUri(
      "https://app.verisync.co/synchronizer/authorize?flow_id=${widget.flowId}&client_id=${widget.clientId}&redirect_url=$newRedirectUrl&email=${widget.email ?? ""}&metadata=${json.encode(widget.metadata ?? {})}",
    );

    return InAppWebView(
      key: _webViewKey,
      initialUrlRequest: URLRequest(
        url: webUri,
      ),

      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        if (url!.queryParametersAll.containsKey('verisync-redirect')) {
          widget.onSuccess?.call(context);
          _handleClose(context);
        }
      },

      /// The settings for the web view.
      initialSettings: _settings,
      onWebViewCreated: (controller) => _webViewController = controller,
      onLoadStart: (controller, url) => setState(() {}),

      /// Updates the progress.
      onProgressChanged: (controller, progress) => setState(() {
        _progress = progress / 100;
      }),
    );
  }

  /// Builds the progress bar.
  Widget _buildProgressBar() {
    return _progress < 1.0 ? LinearProgressIndicator(value: _progress) : Container();
  }

  /// Closes the view.
  void _handleClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Reloads the web view.
  void _handleRefresh() {
    _webViewController.reload();
  }
}
