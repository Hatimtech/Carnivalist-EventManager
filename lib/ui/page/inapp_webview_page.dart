import 'dart:async';

import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewPage extends StatefulWidget {
  final String data;

  const InAppWebViewPage(this.data);

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool webviewLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InAppWebView(
          initialUrl: widget.data,
          initialHeaders: {},
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                debuggingEnabled: true, useOnDownloadStart: true),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
//            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            setState(() => webviewLoading = true);
          },
          onLoadStop: (InAppWebViewController controller, String url) {
            setState(() => webviewLoading = false);
          },
          onDownloadStart: (controller, url) async {
            print("onDownloadStart $url");
//            final taskId = await FlutterDownloader.enqueue(
//              url: url,
//              savedDir: (await getExternalStorageDirectory()).path,
//              showNotification: true,
//              // show download progress in status bar (for Android)
//              openFileFromNotification:
//                  true, // click on notification to open downloaded file (for Android)
//            );
          },
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
