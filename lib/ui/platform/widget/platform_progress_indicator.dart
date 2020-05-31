import 'package:eventmanagement/ui/platform/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformProgressIndicator extends PlatformWidget<
    CupertinoActivityIndicator, CircularProgressIndicator> {
  const PlatformProgressIndicator();

  @override
  CupertinoActivityIndicator createIosWidget(BuildContext context) =>
      CupertinoActivityIndicator();

  @override
  CircularProgressIndicator createAndroidWidget(BuildContext context) =>
      CircularProgressIndicator(
        backgroundColor: Colors.white,
      );
}
