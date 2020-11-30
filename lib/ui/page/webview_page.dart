import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/platform_interface.dart';
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
      webViewController
          .currentUrl()
          .then((value) => print('Current Url--->$value'));
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
            onWebResourceError: (WebResourceError webResourceError) {
              print(
                  'webResourceError--->${webResourceError
                      .failingUrl} ${webResourceError.description}');
            },
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'carnivalist_app',
                  onMessageReceived: (JavascriptMessage message) async {
                    //This is where you receive message from
                    //javascript code and handle in Flutter/Dart
                    //like here, the message is just being printed
                    //in Run/LogCat window of android studio
                    print(message.message);
                    if (message.message != null &&
                        message.message.isNotEmpty &&
                        message.message.startsWith('http')) {
                      setState(() {
                        webviewLoading = true;
                      });
                      File downloadFile = await _downloadFile(message.message);
                      if (downloadFile != null) {
                        OpenFile.open(downloadFile.path);
                      } else {
                        Fluttertoast.showToast(
                          msg: AppLocalizations
                              .of(context)
                              .downloadFailure,
                        );
                      }
                      setState(() {
                        webviewLoading = false;
                      });
                    }
                  })
            ]),
          ),
        ),
        if (webviewLoading)
          Center(
            child: const PlatformProgressIndicator(),
          ),
      ],
    );
  }

  Future<File> _downloadFile(String url) async {
    try {
      http.Client client = new http.Client();
      http.Response response = await client.get(Uri.parse(url));
      Map<String, String> headers = response.headers;

      String fileName;
      if (headers != null && headers['content-disposition'] != null) {
        List<String> nameSplit =
        headers['content-disposition'].split('filename=');
        if (nameSplit.length > 1) fileName = nameSplit.last.replaceAll('"', '');
      } else
        fileName = '${DateTime.now()}.pdf';

      print('fileName--->$fileName');
      var bytes = response.bodyBytes;
      String dir = await getSystemDirPath();
      Directory directory = Directory('$dir/user_downloads');
      if (!directory.existsSync()) directory.createSync();
      File file = new File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      return null;
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
