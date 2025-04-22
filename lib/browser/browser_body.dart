import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inappwebview_proxy/inappwebview_proxy.dart';
import 'package:provider/provider.dart';
import 'browser_controller.dart';

@immutable
class BrowserBody extends StatefulWidget {
  const BrowserBody({super.key});

  @override
  State<BrowserBody> createState() => _BrowserBodyState();
}

class _BrowserBodyState extends State<BrowserBody> {
  late final BrowserController _browserController;
  InAppWebViewController? _webViewController;
  late final InappWebViewProxy _browserProxyService;

  @override
  void initState() {
    super.initState();
    _browserProxyService = InappWebViewProxy.instance
      ..initDefaultProxyHttpClient();
    _browserController = context.read<BrowserController>();
    _browserController.url.addListener(_onLoadUrl);
    _browserController.refreshPageAction.addActionListener(_onRefresh);
    _browserController.stopLoadAction.addActionListener(_onStopLoad);
  }

  _onLoadUrl() {
    _loadUrl(_browserController.url.value);
  }

  _onRefresh(Action<Intent> action) {
    _webViewController?.reload();
  }

  _onStopLoad(Action<Intent> action) {
    _webViewController?.stopLoading();
  }


  @override
  void dispose() {
    _browserController.refreshPageAction.removeActionListener(_onRefresh);
    _browserController.stopLoadAction.removeActionListener(_onStopLoad);
    _browserController.url.removeListener(_onLoadUrl);
    _webViewController?.dispose();
    _browserProxyService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InAppWebView(
    initialSettings: InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      useShouldInterceptRequest: true,
      // We can not intercept requests in IOS, so we use custom scheme to intercept requests
      resourceCustomSchemes: [if (Platform.isIOS) _browserProxyService.customProxyScheme],
      preferredContentMode: UserPreferredContentMode.MOBILE,
    ),
    onWebViewCreated: _onWebViewCreated,
    onLoadStart: _onLoadStart,

    // This is necessary to intercept requests from custom scheme.
    shouldOverrideUrlLoading: _browserProxyService.onShouldOverrideUrlLoading,

    // Intercept custom scheme requests in IOS
    onLoadResourceWithCustomScheme: _browserProxyService.onLoadResourceWithCustomScheme,

    // Intercept requests in Android
    shouldInterceptRequest: _browserProxyService.onShouldInterceptRequest,
    onReceivedError: _onReceivedError,
    onReceivedHttpError: _onReceivedHttpError,
  );

  _onWebViewCreated(InAppWebViewController controller) {
    _webViewController = controller;
    _loadUrl(_browserController.url.value);
  }

  _loadUrl(final String? text) async {
    final request = _browserProxyService.onLoadUrl(text: text);
    if(request != null) {
      _webViewController?.loadUrl(urlRequest: request);
    }
  }

  void _onLoadStart(_, Uri? uri) {
    final url = _browserProxyService.onLoadStart(uri);
    if(url != null) {
      _browserController.setUrl(url);
    }
  }

  void _onReceivedError(
      _,
      WebResourceRequest request,
      WebResourceError error,
      ) {
    debugPrint(
      'Failed to load ${request.url}: ${error.type} ${error.description}',
    );
  }

  void _onReceivedHttpError(
      InAppWebViewController controller,
      WebResourceRequest request,
      WebResourceResponse errorResponse,
      ) {
    debugPrint(
      'Failed to load ${request.url}: '
          'HTTP ${errorResponse.statusCode} '
          '${errorResponse.reasonPhrase}',
    );
  }
}
