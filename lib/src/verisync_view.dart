part of "../src/verisync_button.dart";

class VerisyncView extends StatefulWidget {
  final String redirectUrl, flowId, clientId;
  final String? email;
  final void Function(BuildContext context) onSuccess;
  final void Function(BuildContext context) onError;
  final Map<dynamic, dynamic>? metadata;

  const VerisyncView({
    super.key,
    required this.redirectUrl,
    required this.flowId,
    required this.clientId,
    required this.onSuccess,
    required this.onError,
    this.email,
    this.metadata,
  });

  @override
  State<VerisyncView> createState() => _VerisyncViewState();
}

class _VerisyncViewState extends State<VerisyncView> {
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
