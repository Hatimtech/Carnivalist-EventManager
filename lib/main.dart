import 'dart:io';

import 'package:eventmanagement/bloc/login/login_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/menu/event_menu_page.dart';
import 'package:eventmanagement/ui/platform/widget/platform_app.dart';
import 'package:eventmanagement/utils/orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/event/basic/basic_bloc.dart';
import 'bloc/event/createfield/create_field_bloc.dart';
import 'bloc/event/createticket/create_ticket_bloc.dart';
import 'bloc/event/setting/setting_bloc.dart';
import 'bloc/event/tickets/tickets_bloc.dart';
import 'bloc/forgotpassword/forgot_password_bloc.dart';
import 'bloc/signup/sign_up_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'service/di/dependency_injection.dart';
import 'ui/menu/bottom_menu_page.dart';
import 'ui/page/dashboard_page.dart';
import 'ui/page/forgot_password_page.dart';
import 'ui/page/login_page.dart';
import 'ui/page/signup_page.dart';
import 'ui/page/splash_screen.dart';
import 'utils/vars.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.indigo,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.purpleAccent,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(dark);

  Injector.configure(Flavor.Network);

  runApp(MyApp());
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => UserBloc(),
      child: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocProvider(
          create: (context) => SignUpBloc(),
          child: BlocProvider(
            create: (context) => ForgotPasswordBloc(),
            child: BlocProvider(
              create: (context) => BasicBloc(),
              child: BlocProvider(
                create: (context) => SettingBloc(),
                child: BlocProvider(
                  create: (context) => CreateFieldBloc(),
                  child: BlocProvider(
                    create: (context) => TicketsBloc(),
                    child: BlocProvider(
                      create: (context) => CreateTicketBloc(),
                      child: _buildPlatformApp(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformApp() {
    return PlatformApp(
        onGenerateTitle: (ctx) =>
        AppLocalizations
            .of(ctx)
            .appTitle,
        supportedLocales: [
          const Locale('en'),
          const Locale('fr'),
        ],
        localizationsDelegates: [
          const AppTranslationsDelegate(),
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
          //provides IOS localization
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/',
        //routes
        routes: <String, WidgetBuilder>{
          '/': (context) => SplashPage(),
          loginRoute: (BuildContext context) => LoginPage(),
          signUpRoute: (BuildContext context) => SignUpPage(),
          forgotPasswordRoute: (BuildContext context) => ForgotPasswordPage(),
          bottomMenuRoute: (BuildContext context) => BottomMenuPage(),
          dashboardRoute: (BuildContext context) => DashboardPage(),
          eventMenuRoute: (BuildContext context) => EventMenuPage()
        });
  }
}

bool get isPlatformAndroid {
  return Platform.isAndroid;
//  return false;
}
