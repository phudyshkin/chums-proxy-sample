# chums_proxy_sample

[![License: AGPLv3][license_badge]][license_link]

Chums Proxy example flutter application

## Getting Started

In order to use Chums Proxy in your application, we need two flutter plugins: `inapp_web_view_proxy` and `chums_proxy`.
* [flutter_inappwebview_proxy](https://github.com/Chums-Team/flutter-inappwebview-proxy-plugin) is required in order to use [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview ) together with the local proxy.
* [chums_proxy](https://github.com/Chums-Team/chums-proxy) - run a proxy service locally

First, we need to run our local proxy:

<pre>
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ChumsProxyLifecycle().start();
  runApp(const ProxyApp());
}
</pre>

Then we will need the InappWebViewProxy instance to process requests:
<pre>
late final InappWebViewProxy _browserProxyService;
void initState() {
    super.initState();
    _browserProxyService = InappWebViewProxy.instance
      ..initDefaultProxyHttpClient();
}
</pre>
We also need to specify the settings for InAppWebView:

<pre>
InAppWebView(
    initialSettings: InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      useShouldInterceptRequest: true,
      resourceCustomSchemes: [if (Platform.isIOS) _browserProxyService.customProxyScheme],
    ),
    onWebViewCreated: _onWebViewCreated,
    onLoadStart: _onLoadStart,
    shouldOverrideUrlLoading: _browserProxyService.onShouldOverrideUrlLoading,
    onLoadResourceWithCustomScheme: _browserProxyService.onLoadResourceWithCustomScheme,
    shouldInterceptRequest: _browserProxyService.onShouldInterceptRequest,
// ...
)
</pre>

And some additional methods
<pre>
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
    // on start load url
  }
}
</pre>

[license_badge]: https://img.shields.io/badge/license-AGPLv3-blue.svg
[license_link]: https://opensource.org/license/agpl-v3/
