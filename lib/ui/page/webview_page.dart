import 'dart:async';
import 'dart:convert';

import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String data;
  final bool raw, applyContentHeight, mockNativeView;

  const WebViewPage(this.data, {
    this.raw = false,
    this.applyContentHeight = false,
    this.mockNativeView = false,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  double _MAX_WEBVIEW_HEIGHT;
  double _webViewHeight;
  bool _loaded = false,
      webviewLoading = false;

  @override
  void initState() {
    super.initState();
    _webViewHeight = widget.applyContentHeight ? 256 : double.infinity;
  }

  @override
  void didUpdateWidget(WebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.future.then((webViewController) {
      webViewController.loadUrl(widget.raw
          ? Uri.dataFromString(widget.data,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString()
          : widget.data);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final mediaQuery = MediaQuery.of(context);
      _MAX_WEBVIEW_HEIGHT =
          mediaQuery.size.height * mediaQuery.devicePixelRatio;
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: _webViewHeight,
          child: WebView(
            initialUrl: widget.raw
                ? 'data:text/html;base64,${base64Encode(
                const Utf8Encoder().convert(widget.data))}'
                : widget.data,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
//      gestureRecognizers: [
//        Factory(() => PlatformViewVerticalGestureRecognizer()),
//      ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              print('navigationDelegate--->$request');
              if (widget.mockNativeView) {
                _launchURL(request.url);
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
              if (!widget.raw ?? false)
                setState(() {
                  webviewLoading = true;
                });
            },
            onPageFinished: (String url) async {
              print('Page finished loading: $url');
              if (!widget.raw ?? false)
                setState(() {
                  webviewLoading = false;
                });

              if (widget.applyContentHeight) {
                final _webViewController = await _controller.future;

                final height = double.tryParse(
                    await _webViewController.evaluateJavascript(
                        "document.documentElement.scrollHeight;")) ??
                    250;
                _webViewHeight =
                height > _MAX_WEBVIEW_HEIGHT ? _MAX_WEBVIEW_HEIGHT : height;
                print('WebView Scroll Height--->$_webViewHeight');
                setState(() {});
              }
            },
            gestureNavigationEnabled: true,
          ),
        ),
        if (webviewLoading)
          Center(
            child: const PlatformProgressIndicator(),
          ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
