import 'dart:ui';

import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

//API
int ok200 = 200;
int apiCodeSuccess = 1;
int apiCodeError = 0;

const String redirectUrlValue =
    'https://dev.managers.aktv.life/login/forgotpassword';

const String emailParam = 'email';

//DRAWER

//TODO IMAGE
const String appIconImage = 'assets/images/user_profile.png';
const String backgroundImage = 'assets/images/splash_backgroud.png';
const String logoImage = 'assets/images/application_logo.png';

const String bottomMenuHome = 'assets/images/.png';

//TODO FONT NAME
const String montserratFont = 'Montserrat';
const String montserratRegularFont = 'montserrat_regular.ttf';
const String montserratMediumFont = 'montserrat_medium.ttf';
const String montserratBoldFont = 'montserrat_bold.ttf';

//TODO ROUTE
const String SplashScreenRoute = '/splashScreen';
const String loginRoute = '/login';
const String signUpRoute = '/signup';
const String forgotPasswordRoute = '/forgotPassword';
const String profileRoute = '/profile';
const String profileEditRoute = '/profileEdit';
const String contactRoute = '/contact';
const String dashboardRoute = '/dashboard';
const String bottomMenuRoute = '/bottomMenu';
const String eventMenuRoute = '/eventMenu';

const String profileImage = 'assets/images/user_profile.png';
const String headerBackgroundImage = 'assets/images/header_background.png';

const String bottomMenuBarHomeImage = 'assets/images/bottom_menu_bar_home.png';
const String bottomMenuBarEventImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarCouponsImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarAddImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarUserImage = 'assets/images/bottom_menu_bar_user.png';


//TODO COLOR
const Color colorPrimary = Color(0xFF462FB6);
const Color colorAccent = Color(0xFF9249F4);

const Color colorTextTitle = Colors.black;
const Color colorTextSubtitle = Color(0xFF8C3EE9);
const Color colorTextSubhead = Color(0xFF8C3EE9);
const Color colorTextBody1 = Colors.black;
const Color colorTextBody2 = Colors.black;
const Color colorTextButton = Colors.white;

const Color bgColor = Color(0xFFFFF4FF);
const Color bgColorSecondary = Color(0xFFF4E6FA);
const Color cardBgColor = Color(0xFFFFFFFF);
const Color colorBgButton = Color(0xFF8C3EE9);

const Color colorIcon = Color(0xFF8C3EE9);
const Color colorIconSecondary = Color(0xFF6700E2);
const Color colorIconBottomBar = Color(0xFF5D5D5D);

const Color colorFocusedBorder = Color(0xFF8C3EE9);

const Color colorProgressBar = Color(0xFF10089b);
const Color colorTitle = Color(0xFF10089b);
const Color bgColorFloatingActionButton = Color(0xFFAF52DE);
const Color colorBottomBarMenu = Color(0xFFFEFEFE);
const Color colorHeaderTitle = Colors.white;
const Color colorSubHeader = Colors.black;
const Color colorCreateEventBg = Color(0xFF8C3EE9);
const Color colorHeaderBgFilter = Colors.transparent;


List<Color> gradientsClipper = [Colors.grey.shade200, Colors.white];

List<Color> gradientsButton = [Colors.grey.shade200, Colors.white];

List<Color> kitGradients = [
  Colors.grey.shade100,
  Colors.grey.shade200,
];

buttonBg() {
  return BoxDecoration(
      borderRadius: new BorderRadius.all(
        Radius.circular(10.0),
      ),
      gradient:
          LinearGradient(colors: [HexColor('#0408a4'), HexColor('#eb0a0b')]));
}

//TODO WIDGET
expandStyle(int flex, Widget child) => Expanded(flex: flex, child: child);

//VALIDATION
String validatePhoneEmail(String value) {
  String patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExpEmail = new RegExp(patternEmail);

  if (value.isEmpty) {
    return 'Phone No/Email is required';
  } else if (isNumeric(value)) {
    if (value.replaceAll(" ", "").length != 10) {
      return 'Mobile number must be 10 digits';
    } else {
      return null;
    }
  } else if (!regExpEmail.hasMatch(value)) {
    return 'Invalid email';
  } else {
    return null;
  }
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Email is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Invalid email';
  } else {
    return null;
  }
}

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.replaceAll(" ", "").isEmpty) {
    return 'Phone no is required';
  } else if (value.replaceAll(" ", "").length != 10) {
    return 'Phone no number must 10 digits';
  } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
    return 'Phone no number must be 10 digits';
  }
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password is required';
  } else if (value.length < 4) {
    return 'Password at least 4 characters';
  }
  return null;
}

String validateOldPassword(String value) {
  if (value.isEmpty) {
    return null;
  } else if (value.length < 4) {
    return 'Old password must be at least 4 characters';
  }
  return null;
}

String validateNewPassword(String value) {
  if (value.isEmpty) {
    return null;
  } else if (value.length < 4) {
    return 'New password must be at least 4 characters';
  }
  return null;
}

String validateConfirmPassword(String value) {
  if (value.isEmpty) {
    return 'Confirm password is required';
  } else if (value.length < 4) {
    return 'Confirm password must be at least 4 characters';
  }
  return null;
}

String validateEditName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(value)) {
    return 'Name must be a-z and A-Z';
  }
  return null;
}

String validateEditMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.replaceAll(" ", "").isEmpty) {
    return null;
  } else if (value.replaceAll(" ", "").length != 10) {
    return 'Mobile number must 10 digits';
  } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
    return 'Mobile number must be digits';
  }
  return null;
}

bool validationEqual(String currentValue, String checkValue) {
  if (currentValue == checkValue) {
    return true;
  } else {
    return false;
  }
}

String validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'First name is required';
  } else if (!regExp.hasMatch(value)) {
    return 'First name must be a-z and A-Z';
  }
  return null;
}

String validateAddress(String value) {
  String pattern = r'(^[a-zA-Z0-9-, ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Address is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Address must be text and numeric';
  }
  return null;
}

String validateEditAddress(String value) {
  String pattern = r'(^[a-zA-Z0-9-, ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(value)) {
    return 'Address must be text and numeric';
  }
  return null;
}

String validateTicketName(String value) {
  if (value.isEmpty) {
    return 'Ticket name is required';
  }
  return null;
}

String validatePrice(String value) {
  if (value.isEmpty) {
    return 'Price is required';
  }
  return null;
}

String validateSalesEndDate(String value) {
  if (value.isEmpty) {
    return 'Sales end date is required';
  }
  return null;
}

String validateQuantity(String value) {
  if (value.isEmpty) {
    return 'Quantity is required';
  }
  return null;
}