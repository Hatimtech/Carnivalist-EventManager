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
    'https://manager.carnivalist.tk/login/forgotpassword';

const String emailParam = 'email';
const String redirectParam = 'redirectUri';

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
const String bottomMenuRoute = '/bottomMenu';
const String eventMenuRoute = '/eventMenu';
const String eventDetailRoute = '/eventDetail';
const String userInfoRoute = '/userInfo';
const String bandStaffHomeRoute = '/bandStaffHome';

const String profileImage = 'assets/images/user_profile.png';
const String headerBackgroundImage = 'assets/images/header_background.png';
const String placeholderImage = 'assets/images/image_placeholder.png';

const String bottomMenuBarHomeImage = 'assets/images/bottom_menu_bar_home.png';
const String bottomMenuBarEventImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarCouponsImage =
    'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarAddImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarUserImage = 'assets/images/bottom_menu_bar_user.png';

// Navigation Pages Constants
const int PAGE_REPORTS = 0;
const int PAGE_ACCOUNTS = 1;
const int PAGE_DASHBOARD = 2;
const int PAGE_ADDONS = 3;
const int PAGE_COUPONS = 4;
const int PAGE_STAFF = 5;

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
const Color colorUnselectedIconBottomBar = Color(0xFF5D5D5D);
const Color colorUnselectedTextBottomBar = Color(0xFF5D5D5D);

const Color colorFocusedBorder = Color(0xFF8C3EE9);

const Color colorProgressBar = Color(0xFF10089b);
const Color colorTitle = Color(0xFF10089b);
const Color colorBottomBarMenu = Color(0xFFFEFEFE);
const Color colorHeaderTitle = Colors.white;
const Color colorHeaderBgFilter = Colors.transparent;

const Color colorActive = Colors.green;
const Color colorInactive = Colors.red;

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
String validatePhoneEmail(String value, AppLocalizations appLocalizations) {
  String patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExpEmail = new RegExp(patternEmail);

  if (value.isEmpty) {
    return appLocalizations.errorPhoneEmail;
  } else if (isNumeric(value)) {
    if (value
        .replaceAll(" ", "")
        .length < 10) {
      return appLocalizations.errorPhoneNoLength;
    } else {
      return null;
    }
  } else if (!regExpEmail.hasMatch(value)) {
    return appLocalizations.errorInvalidEmail;
  } else {
    return null;
  }
}

bool isValidEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.isEmpty || !regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

String validateEmail(String value, AppLocalizations appLocalizations) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.isEmpty) {
    return appLocalizations.errorEmail;
  } else if (!regExp.hasMatch(value)) {
    return appLocalizations.errorInvalidEmail;
  } else {
    return null;
  }
}

String validateMobile(String value, AppLocalizations appLocalizations) {
  String pattern = r'(^(?:[+0])?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.replaceAll(" ", "").isEmpty) {
    return appLocalizations.errorPhoneNo;
  } else if (value
      .replaceAll(" ", "")
      .length < 10) {
    return appLocalizations.errorPhoneNoLength;
  } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
    return appLocalizations.errorPhoneNoLength;
  }
  return null;
}

String validatePassword(String value, AppLocalizations appLocalizations) {
  if (value.isEmpty) {
    return appLocalizations.errorPassword;
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

String validateName(String value, AppLocalizations appLocalizations) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return appLocalizations.errorFirstName;
  } else if (!regExp.hasMatch(value)) {
    return appLocalizations.errorFirstNameValid;
  }
  return null;
}

String validateLastName(String value, AppLocalizations appLocalizations) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return appLocalizations.errorLastName;
  } else if (!regExp.hasMatch(value)) {
    return appLocalizations.errorLastNameValid;
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
const String PAGE_STORAGE_KEY_STAFF = 'StaffPage';

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

const int ERR_MAIL_SUBJECT_NAME = 61;
const int ERR_MAIL_FROM_NAME = 62;
const int ERR_MAIL_REPLY_TO = 63;
const int ERR_MAIL_REPLY_TO_VALID = 64;
const int ERR_MAIL_MESSAGE_BODY = 65;

const int ERR_GALLERY_BANNER = 66;
const int ERR_CONV_FEE_PERCENT = 67;
const int ERR_CONV_FEE_PERCENT_VALID = 68;
const int ERR_CONV_FEE_AMOUNT = 69;
const int ERR_CONV_FEE_AMOUNT_VALID = 70;

const int ERR_STAFF_NAME = 71;
const int ERR_STAFF_EMAIL = 72;
const int ERR_STAFF_EMAIL_VALID = 73;
const int ERR_STAFF_DOB = 74;
const int ERR_STAFF_STATE = 75;
const int ERR_STAFF_CITY = 76;
const int ERR_STAFF_MOBILE_NO = 77;
const int ERR_STAFF_MOBILE_NO_LENGTH = 78;
const int ERR_STAFF_USERNAME = 79;
const int ERR_STAFF_PASSWORD = 80;
const int ERR_STAFF_SELECT_EVENTS = 81;

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

    case ERR_CONV_FEE_PERCENT:
      return appLoc.errorConvFeePercent;
    case ERR_CONV_FEE_PERCENT_VALID:
      return appLoc.errorConvFeePercentValid;
    case ERR_CONV_FEE_AMOUNT:
      return appLoc.errorConvFeeAmount;
    case ERR_CONV_FEE_AMOUNT_VALID:
      return appLoc.errorConvFeeAmountValid;
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

    case ERR_MAIL_SUBJECT_NAME:
      return appLoc.errorMailSubject;
    case ERR_MAIL_FROM_NAME:
      return appLoc.errorMailFromName;
    case ERR_MAIL_REPLY_TO:
      return appLoc.errorMailReplyTo;
    case ERR_MAIL_REPLY_TO_VALID:
      return appLoc.errorMailReplyToValid;
    case ERR_MAIL_MESSAGE_BODY:
      return appLoc.errorMailMessage;
    case ERR_GALLERY_BANNER:
      return appLoc.errorGalleryBanner;

    case ERR_STAFF_NAME:
      return appLoc.errorStaffName;
    case ERR_STAFF_EMAIL:
      return appLoc.errorStaffEmail;
    case ERR_STAFF_EMAIL_VALID:
      return appLoc.errorStaffInvalidEmail;
    case ERR_STAFF_DOB:
      return appLoc.errorStaffDOB;
    case ERR_STAFF_STATE:
      return appLoc.errorStaffState;
    case ERR_STAFF_CITY:
      return appLoc.errorStaffCity;
    case ERR_STAFF_MOBILE_NO:
      return appLoc.errorStaffMobileNo;
    case ERR_STAFF_MOBILE_NO_LENGTH:
      return appLoc.errorStaffMobileNoLength;
    case ERR_STAFF_USERNAME:
      return appLoc.errorStaffUsername;
    case ERR_STAFF_PASSWORD:
      return appLoc.errorStaffPassword;
    case ERR_STAFF_SELECT_EVENTS:
      return appLoc.errorStaffSelectEvents;

    case ERR_NO_INTERNET:
      return appLoc.errorNoInternet;
    case ERR_SOMETHING_WENT_WRONG:
      return appLoc.errorSomethingWrong;

    default:
      return appLoc.errorSomethingWrong;
  }
}

const String fallbackPath =
    '/storage/emulated/0/Android/data/com.carnivalist.eventmanagement/files/';

Future<String> getSystemDirPath() async {
  Directory externalFilesDir = Platform.isIOS
      ? await getApplicationSupportDirectory()
      : await getExternalStorageDirectory();
  return externalFilesDir.path ?? fallbackPath;
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String get userBase64 =>
    'data:image/jpeg;base64,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';

extension NumExtension on num {
  bool get isInt => this is int || this == this.roundToDouble();
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}
