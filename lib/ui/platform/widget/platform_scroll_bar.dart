import 'package:eventmanagement/ui/platform/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformScrollbar extends PlatformWidget<CupertinoScrollbar, Scrollbar> {
  final Widget child;

  PlatformScrollbar({
    this.child,
  });

  @override
  CupertinoScrollbar createIosWidget(BuildContext context) =>
      new CupertinoScrollbar(
        child: child,
      );

  @override
  Scrollbar createAndroidWidget(BuildContext context) => new Scrollbar(
        child: child,
      );
}
