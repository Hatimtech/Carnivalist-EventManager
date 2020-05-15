import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPluginPage extends StatefulWidget {
  final String pageUrl;

  const WebViewPluginPage(this.pageUrl);

  @override
  _WebViewPluginPageState createState() => _WebViewPluginPageState();
}

class _WebViewPluginPageState extends State<WebViewPluginPage> {
  final kAndroidUserAgent =
      'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
  UserBloc _userBloc;

  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
    _userBloc = BlocProvider.of<UserBloc>(context);
    print('_userBloc.state.authToken ${_userBloc.state.authToken}');
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.pageUrl,
      withJavascript: true,
      headers: {
        'Authorization': 'Bearer ${_userBloc.state.authToken}',
        'Referer': 'https://manager.carnivalist.tk/',
        'User-Agent': kAndroidUserAgent,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.dispose();
  }
}
