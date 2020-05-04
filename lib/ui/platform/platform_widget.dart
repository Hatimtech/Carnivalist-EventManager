import 'package:eventmanagement/main.dart';
import 'package:flutter/material.dart';

abstract class PlatformWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {

  const PlatformWidget();

  @override
  Widget build(BuildContext context) {
    bool isAndroid = isPlatformAndroid;
    if (isAndroid) {
      return createAndroidWidget(context);
    } else if (!isAndroid) {
      return createIosWidget(context);
    }
    // platform not supported returns an empty widget
    return new Container();
  }

  I createIosWidget(BuildContext context);

  A createAndroidWidget(BuildContext context);
}
