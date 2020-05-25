import 'package:eventmanagement/ui/platform/platform_widget.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformApp extends PlatformWidget<Theme, MaterialApp> {
  final GlobalKey navigatorKey;
  final GenerateAppTitle onGenerateTitle;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;

  PlatformApp({
    this.navigatorKey,
    this.onGenerateTitle,
    this.supportedLocales,
    this.localizationsDelegates,
    this.initialRoute,
    this.routes,
  });

  @override
  MaterialApp createAndroidWidget(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        onGenerateTitle: onGenerateTitle,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        theme: _buildThemeData(),
        initialRoute: initialRoute,
        //routes
        routes: routes);
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      accentColor: colorAccent,
      primaryColor: colorPrimary,
      primarySwatch: Colors.indigo,
      fontFamily: montserratFont,
      cardColor: bgColorCard,
      primaryIconTheme: ThemeData
          .light()
          .iconTheme
          .copyWith(
        color: colorIcon,
      ),
      accentIconTheme: ThemeData
          .light()
          .iconTheme
          .copyWith(
        color: colorIcon,
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            title: const TextStyle(
              fontSize: 18,
              color: colorTextTitle,
              fontWeight: FontWeight.bold,
            ),
            subtitle: const TextStyle(
              fontSize: 16,
              color: colorTextSubtitle,
              fontWeight: FontWeight.bold,
            ),
            button: const TextStyle(
              color: colorTextButton,
            ),
            subhead: const TextStyle(
              fontSize: 10,
              color: colorTextSubhead,
              fontWeight: FontWeight.bold,
            ),
            body1: const TextStyle(
              fontSize: 14,
              color: colorTextBody1,
            ),
            body2: const TextStyle(
              fontSize: 10,
              color: colorTextBody2,
            ),
            caption: const TextStyle(),
          ),
      buttonTheme: ThemeData.light().buttonTheme.copyWith(
        buttonColor: bgColorButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
      iconTheme: ThemeData.light().iconTheme.copyWith(
            color: colorIcon,
          ),
      appBarTheme: AppBarTheme(
        textTheme: ThemeData.light().textTheme.copyWith(
              title: const TextStyle(fontSize: 16, color: colorHeaderTitle),
            ),
        iconTheme: ThemeData.light().iconTheme.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  @override
  Theme createIosWidget(BuildContext context) {
    return Theme(
      data: _buildThemeData(),
      child: CupertinoApp(
          navigatorKey: navigatorKey,
          onGenerateTitle: onGenerateTitle,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          initialRoute: initialRoute,
          //routes
          routes: routes),
    );
  }
}
