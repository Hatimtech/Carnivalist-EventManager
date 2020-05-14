import 'dart:io';
import 'dart:ui';

import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
const String eventDetailRoute = '/eventDetail';

const String profileImage = 'assets/images/user_profile.png';
const String headerBackgroundImage = 'assets/images/header_background.png';

const String bottomMenuBarHomeImage = 'assets/images/bottom_menu_bar_home.png';
const String bottomMenuBarEventImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarCouponsImage =
    'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarAddImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarUserImage = 'assets/images/bottom_menu_bar_user.png';

// Navigation Pages Constants
const int PAGE_DASHBOARD = 0;
const int PAGE_COUPONS = 1;
const int PAGE_ADDONS = 2;
const int PAGE_REPORTS = 3;
const int PAGE_STAFF = 4;

//TODO COLOR
const Color colorPrimary = Color(0xFF0713D1);
const Color colorAccent = Color(0xFF9249F4);

const Color colorTextTitle = Colors.black;
const Color colorTextSubtitle = Color(0xFF8C3EE9);
const Color colorTextSubhead = Color(0xFF8C3EE9);
const Color colorTextBody1 = Colors.black;
const Color colorTextBody2 = Colors.black;
const Color colorTextButton = Colors.white;
const Color colorTextAction = Color(0xFF0713D1);

const Color bgColor = Color(0xFFFFF4FF);
const Color bgColorSecondary = Color(0xFFF7E4FC);
const Color bgColorSelection = Color(0xFF7E007E);
const Color bgColorCard = Color(0xFFFFFFFF);
const Color bgColorButton = Color(0xFF8C3EE9);
const Color bgColorFAB = Color(0xFF9249F4);
const Color bgColorFABHome = Color(0xFFF5066E);
const Color bgColorFilterRow = Color(0xFFEEEEEE);

const Color colorIcon = Color(0xFF8C3EE9);
const Color colorIconSecondary = Color(0xFF6700E2);
const Color colorIconBottomBar = Color(0xFF5D5D5D);

const Color colorFocusedBorder = Color(0xFF8C3EE9);

const Color colorProgressBar = Color(0xFF10089b);
const Color colorTitle = Color(0xFF10089b);
const Color colorBottomBarMenu = Color(0xFFFEFEFE);
const Color colorHeaderTitle = Colors.white;
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

bool isValid(String value) =>
    value != null && value
        .trim()
        .isNotEmpty;

String formatDateTime(DateFormat dateFormat, DateTime dateTime) {
  return dateFormat.format(dateTime);
}

String uiLabelWeekday(String label, BuildContext context) {
  final appLoc = AppLocalizations.of(context);
  switch (label) {
    case 'Sunday':
      return appLoc.labelSunday;
    case 'Monday':
      return appLoc.labelMonday;
    case 'Tuesday':
      return appLoc.labelTuesday;
    case 'Wednesday':
      return appLoc.labelWednesday;
    case 'Thursday':
      return appLoc.labelThursday;
    case 'Friday':
      return appLoc.labelFriday;
    case 'Saturday':
      return appLoc.labelSaturday;
  }
}

// Page Storage Keys
const String PAGE_STORAGE_KEY_DASHBOARD = 'DashboardPage';
const String PAGE_STORAGE_KEY_COUPONS = 'CouponPage';
const String PAGE_STORAGE_KEY_ADDON = 'AddonPage';

// Error Codes
const int ERR_EVENT_NAME = 1;
const int ERR_EVENT_TYPE = 2;
const int ERR_EVENT_TIMEZONE = 3;

const int ERR_EVENT_ADDRESS = 4;
const int ERR_EVENT_STATE = 5;
const int ERR_EVENT_CITY = 6;
const int ERR_EVENT_POSTAL = 7;

const int ERR_EVENT_DESC = 8;

const int ERR_START_DATE = 9;
const int ERR_START_TIME = 10;
const int ERR_END_DATE = 11;
const int ERR_END_TIME = 12;
const int ERR_END_TIME_LESS = 13;
const int ERR_WEEK_DAY = 14;
const int ERR_START_DATE_WEEK_DAY = 15;
const int ERR_END_DATE_WEEK_DAY = 16;
const int ERR_TWO_DATES_REQ = 17;

const int ERR_DUPLICATE_TAG = 18;

const int ERR_TICKET_NAME = 19;
const int ERR_TICKET_CURRENCY = 20;
const int ERR_TICKET_SALE_END = 21;
const int ERR_TICKET_AVAILABLE_QUA = 22;
const int ERR_TICKET_MIN_QUA = 23;
const int ERR_TICKET_MAX_QUA = 24;
const int ERR_TICKET_MIN_QUA_LESS = 25;
const int ERR_TICKET_MIN_MAX_BET = 26;

const int ERR_FIELD_LABEL = 27;
const int ERR_FIELD_PLACEHOLDER = 28;

const int ERR_DUPLICATE_LIST_ITEM = 29;
const int ERR_NO_LIST_ITEM = 30;

const int ERR_CANCELLATION_DESC = 31;
const int ERR_CANCELLATION_OPTION = 32;
const int ERR_TNC = 33;

const int ERR_ADDON_NAME = 34;
const int ERR_ADDON_START_DATE = 35;
const int ERR_ADDON_END_DATE = 36;
const int ERR_ADDON_START_DATE_AFTER = 37;
const int ERR_ADDON_TOTAL_AVA = 38;
const int ERR_ADDON_PRICE = 39;
const int ERR_ADDON_DESCRIPTION = 40;
const int ERR_ADDON_CONV_FEE_TYPE = 41;
const int ERR_ADDON_CONV_FEE = 42;
const int ERR_ADDON_IMAGE = 43;

const int ERR_DISCOUNT_NAME = 44;
const int ERR_COUPON_START_DATE = 45;
const int ERR_COUPON_END_DATE = 46;
const int ERR_COUPON_START_DATE_AFTER = 47;
const int ERR_COUPON_NO_OF_DISCOUNT = 48;
const int ERR_COUPON_NO_OF_DISCOUNT_ZERO = 49;
const int ERR_COUPON_CODE = 50;
const int ERR_COUPON_DISCOUNT = 51;
const int ERR_COUPON_EVENT_SELECTION = 52;
const int ERR_COUPON_TICKET_SELECTION = 53;
const int ERR_COUPON_MIN_TICKET = 54;
const int ERR_COUPON_MIN_TICKET_ZERO = 55;
const int ERR_COUPON_MAX_TICKET = 56;
const int ERR_COUPON_MAX_TICKET_ZERO = 57;
const int ERR_COUPON_AFFILIATE_EMAIL = 58;
const int ERR_COUPON_AFFILIATE_EMAIL_VALID = 59;

const int ERR_COUPON_PAST_EVENT_SELECTION = 60;

const int ERR_NO_INTERNET = 99;
const int ERR_SOMETHING_WENT_WRONG = 100;

String getErrorMessage(int errorCode, BuildContext context) {
  final appLoc = AppLocalizations.of(context);
  switch (errorCode) {
    case ERR_EVENT_NAME:
      return appLoc.errorEventName;
    case ERR_EVENT_TYPE:
      return appLoc.errorEventType;
    case ERR_EVENT_TIMEZONE:
      return appLoc.errorEventTimezone;
    case ERR_EVENT_ADDRESS:
      return appLoc.errorEventAddress;
    case ERR_EVENT_STATE:
      return appLoc.errorEventState;
    case ERR_EVENT_CITY:
      return appLoc.errorEventCity;
    case ERR_EVENT_POSTAL:
      return appLoc.errorEventPostal;
    case ERR_EVENT_DESC:
      return appLoc.errorEventDesc;
    case ERR_START_DATE:
      return appLoc.errorStartDate;
    case ERR_START_TIME:
      return appLoc.errorStartTime;
    case ERR_END_DATE:
      return appLoc.errorEndDate;
    case ERR_END_TIME:
      return appLoc.errorEndTime;
    case ERR_END_TIME_LESS:
      return appLoc.errorEndTimeLess;
    case ERR_WEEK_DAY:
      return appLoc.errorWeekday;
    case ERR_START_DATE_WEEK_DAY:
      return appLoc.errorStartDateWeekday;
    case ERR_END_DATE_WEEK_DAY:
      return appLoc.errorEndDateWeekday;
    case ERR_TWO_DATES_REQ:
      return appLoc.errorTwoDateReq;
    case ERR_DUPLICATE_TAG:
      return appLoc.errorDuplicateTag;

    case ERR_TICKET_NAME:
      return appLoc.errorTicketName;
    case ERR_TICKET_CURRENCY:
      return appLoc.errorTicketCurrency;
    case ERR_TICKET_SALE_END:
      return appLoc.errorTicketSaleEnd;
    case ERR_TICKET_AVAILABLE_QUA:
      return appLoc.errorTicketAvailableQua;
    case ERR_TICKET_MIN_QUA:
      return appLoc.errorTicketMinQua;
    case ERR_TICKET_MAX_QUA:
      return appLoc.errorTicketMaxQua;
    case ERR_TICKET_MIN_QUA_LESS:
      return appLoc.errorTicketMinQuaLess;
    case ERR_TICKET_MIN_MAX_BET:
      return appLoc.errorTicketMinMaxBet;

    case ERR_FIELD_LABEL:
      return appLoc.errorFieldLabel;
    case ERR_FIELD_PLACEHOLDER:
      return appLoc.errorFieldPlaceholder;

    case ERR_DUPLICATE_LIST_ITEM:
      return appLoc.errorDuplicateListItem;
    case ERR_NO_LIST_ITEM:
      return appLoc.errorNoListItem;

    case ERR_CANCELLATION_DESC:
      return appLoc.errorCancellationDesc;
    case ERR_CANCELLATION_OPTION:
      return appLoc.errorNoCancellationOption;
    case ERR_TNC:
      return appLoc.errorTnc;

    case ERR_ADDON_NAME:
      return appLoc.errorAddonName;
    case ERR_ADDON_START_DATE:
      return appLoc.errorAddonStartDate;
    case ERR_ADDON_END_DATE:
      return appLoc.errorAddonEndDate;
    case ERR_ADDON_START_DATE_AFTER:
      return appLoc.errorAddonStartDateAfter;
    case ERR_ADDON_TOTAL_AVA:
      return appLoc.errorAddonTotalAva;
    case ERR_ADDON_PRICE:
      return appLoc.errorAddonPrice;
    case ERR_ADDON_DESCRIPTION:
      return appLoc.errorAddonDesc;
    case ERR_ADDON_CONV_FEE_TYPE:
      return appLoc.errorAddonConvFeeType;
    case ERR_ADDON_CONV_FEE:
      return appLoc.errorAddonConvFee;
    case ERR_ADDON_IMAGE:
      return appLoc.errorAddonImage;

    case ERR_DISCOUNT_NAME:
      return appLoc.errorCouponDiscountName;
    case ERR_COUPON_START_DATE:
      return appLoc.errorCouponAvailStartDate;
    case ERR_COUPON_END_DATE:
      return appLoc.errorCouponAvailEndDate;
    case ERR_COUPON_START_DATE_AFTER:
      return appLoc.errorCouponStartDateAfter;
    case ERR_COUPON_NO_OF_DISCOUNT:
      return appLoc.errorCouponNoOfDiscount;
    case ERR_COUPON_NO_OF_DISCOUNT_ZERO:
      return appLoc.errorCouponNoOfDiscountZero;
    case ERR_COUPON_CODE:
      return appLoc.errorCouponCode;
    case ERR_COUPON_DISCOUNT:
      return appLoc.errorCouponDiscountValue;
    case ERR_COUPON_EVENT_SELECTION:
      return appLoc.errorCouponSelectEvent;
    case ERR_COUPON_TICKET_SELECTION:
      return appLoc.errorCouponSelectTicket;

    case ERR_COUPON_MIN_TICKET:
      return appLoc.errorCouponMinTicket;
    case ERR_COUPON_MIN_TICKET_ZERO:
      return appLoc.errorCouponMinTicketZero;
    case ERR_COUPON_MAX_TICKET:
      return appLoc.errorCouponMaxTicket;
    case ERR_COUPON_MAX_TICKET_ZERO:
      return appLoc.errorCouponMaxTicketZero;

    case ERR_COUPON_PAST_EVENT_SELECTION:
      return appLoc.errorCouponSelectPastEvent;

    case ERR_COUPON_AFFILIATE_EMAIL:
      return appLoc.errorCouponAffEmail;
    case ERR_COUPON_AFFILIATE_EMAIL_VALID:
      return appLoc.errorCouponAffEmailValid;

    case ERR_NO_INTERNET:
      return appLoc.errorNoInternet;
    case ERR_SOMETHING_WENT_WRONG:
      return appLoc.errorSomethingWrong;

    default:
      return appLoc.errorSomethingWrong;
  }
}

Future<String> getSystemDirPath() async {
  Directory externalFilesDir = Platform.isIOS
      ? await getApplicationSupportDirectory()
      : await getExternalStorageDirectory();
  return externalFilesDir.path;
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
