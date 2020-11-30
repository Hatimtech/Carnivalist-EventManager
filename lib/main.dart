import 'dart:io';

import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_bloc.dart';
import 'package:eventmanagement/bloc/dashboard/dashboard_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_bloc.dart';
import 'package:eventmanagement/bloc/event/gallery/gallery_bloc.dart';
import 'package:eventmanagement/bloc/login/login_bloc.dart';
import 'package:eventmanagement/bloc/staff/staff_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/menu/event_menu_page.dart';
import 'package:eventmanagement/ui/page/dashboard/event_staff_home.dart';
import 'package:eventmanagement/ui/page/eventdetails/event_detail_root_page.dart';
import 'package:eventmanagement/ui/page/user_info_page.dart';
import 'package:eventmanagement/ui/platform/widget/platform_app.dart';
import 'package:eventmanagement/utils/orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/event/basic/basic_bloc.dart';
import 'bloc/event/setting/setting_bloc.dart';
import 'bloc/event/tickets/tickets_bloc.dart';
import 'bloc/forgotpassword/forgot_password_bloc.dart';
import 'bloc/signup/sign_up_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'service/di/dependency_injection.dart';
import 'ui/menu/bottom_menu_page.dart';
import 'ui/page/forgot_password_page.dart';
import 'ui/page/login_page.dart';
import 'ui/page/signup_page.dart';
import 'ui/page/splash_screen.dart';
import 'utils/vars.dart';

var _logFilename = 'back_to_now.txt';

void main() async {
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

//  var docsDir = await getSystemDirPath();
//  String canonFilename = '$docsDir/$_logFilename';
//  await Logger.initializeLogging(canonFilename);
//  await Logger.log('ENTERED main() ...');

//  await FlutterDownloader.initialize(
//      debug: true // optional: set false to disable printing logs to console
//  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => UserBloc(),
      child: BlocProvider(
        create: (context) => EventBloc(),
        child: _buildPlatformApp(),
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
          loginRoute: (BuildContext context) => loginPageRoute,
          signUpRoute: (BuildContext context) => signupPageRoute,
          forgotPasswordRoute: (BuildContext context) =>
          forgotPasswordPageRoute,
          bottomMenuRoute: (BuildContext context) => bottomMenuPageRoute,
          eventMenuRoute: (BuildContext context) =>
              createEventPageRoute(context),
          eventDetailRoute: (BuildContext context) =>
              eventDetailPageRoute(context),
          userInfoRoute: (BuildContext context) => UserInfoPage(),
          bandStaffHomeRoute: (BuildContext context) => EventStaffHomePage(),
        });
  }

  Widget get bottomMenuPageRoute {
    return BlocProvider(
      create: (context) => PageNavBloc(),
      child: BlocProvider(
        create: (context) => DashboardBloc(),
        child: BlocProvider(
          create: (context) => AddonBloc(),
          child: BlocProvider(
            create: (context) => CouponBloc(),
            child: BlocProvider(
              create: (context) => StaffBloc(),
              child: BottomMenuPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget get loginPageRoute =>
      BlocProvider(
        create: (context) => LoginBloc(),
        child: LoginPage(),
      );

  Widget get signupPageRoute =>
      BlocProvider(
        create: (context) => SignUpBloc(),
        child: SignUpPage(),
      );

  Widget get forgotPasswordPageRoute =>
      BlocProvider(
        create: (context) => ForgotPasswordBloc(),
        child: ForgotPasswordPage(),
      );

  Widget eventDetailPageRoute(BuildContext context) =>
      BlocProvider(
        create: (ctx) =>
            EventDetailBloc(
                eventId: ModalRoute
                    .of(context)
                    .settings
                    .arguments as String),
        child: EventDetailRootPage(),
      );

  Widget createEventPageRoute(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddonBloc(assigning: true),
      child: BlocProvider(
        create: (context) => BasicBloc(),
        child: BlocProvider(
          create: (context) => SettingBloc(),
          child: BlocProvider(
            create: (context) => TicketsBloc(),
            child: BlocProvider(
                create: (context) => FormBloc(),
                child: BlocProvider(
                  create: (context) => GalleryBloc(),
                  child: EventMenuPage(
                    ModalRoute
                        .of(context)
                        .settings
                        .arguments,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

bool get isPlatformAndroid {
  return Platform.isAndroid;
//  return false;
}
