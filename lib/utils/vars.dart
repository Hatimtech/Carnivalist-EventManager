import 'dart:ui';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

const String appName = 'White Dry Wash';

//API
int ok200 = 200;
int apiCodeSuccess = 1;
int apiCodeError = 0;

const String redirectUrlValue =
    'https://dev.managers.aktv.life/login/forgotpassword';

const String emailParam = 'email';

//DRAWER

//TITLE
const String titleSignUp = 'Sign Up';
const String titleForgotPassword = 'Forgot Password';
const String titleSignIn = 'Sign In';
const String titleDashboard = 'Dashboard';
const String titleCreateEvent = 'Create Event';
const String titleBasicInfo = 'Basic Info';
const String titleEventDate = 'Event Date';
const String titleAddress = 'Address';
const String titleDescription = 'Description';
const String titleTicketDetails = 'Enter your ticket details';
const String titlePaymentAndFees = 'Payments and fees';
const String titleCustomLabels = 'Custom Labels';
const String titleCustomSettings = 'Custom Settings';
const String titleCustomField = 'Create your custom field';

//TODO LABEL
const labelForgotPassword = 'Forgot Password';
const labelSignUp = "Sign Up";
const labelSignIn = "Sign In";
const labelDoNotAccount = "Dont't have an account?";
const labelBecomeAVendorPartner = "Become a vendor partner.";
const labelSignUpAgreement = "By signing up, you agree to our \nTerms & Privacy Policy.";
const labelAlredyAccount = "Alredy have an account?";
const  labelEventName = 'Event name';
const  labelCarnivalName = 'Carnival';
const  labelTimeZone = 'Time zone';
const  labelTags = 'Tags';
const  labelStartDate = 'Start date';
const  labelStartTime = 'Start time';
const  labelEndDate = 'End date';
const  labelEndTime = 'End time';
const  labelLocation = 'Location';
const  labelState = 'State';
const  labelCity = 'City';
const  labelPostalCode = 'Postal code';
const  labelSelectState = 'Select state';
const  labelTypeCityName = 'Type city name';
const  labelTypePostalCode = 'Type postal code';
const  labelTicketName = 'Ticket Name';
const  labelPrice = 'Price';
const  labelSalesEnds = 'Sales Ends';
const  labelTotalAvailable = 'Total Available';
const  labelMinBooking = 'Min Booking';
const  labelMaxBooking = 'Max Booking';
const  labelDescription = 'Description';
const  labelConvenienceFee = 'Convenience Fee';
const  labelPaymentGatewayCharge = 'Who will pay payment Gateway charges';
const  labelBookingCancel = 'Booking Cancellation';
const  labelTicketResale = 'Ticket Resale';
const  labelRemainingTickets = 'Remaining Tickets';
const  labelRegistrationButton = 'Registration button label';
const  labelFacebookLink = 'Facebook Link';
const  labelTwitterLink = 'Twitter Link';
const  labelLinkedInLink = 'Linkedin Link';
const  labelWebsiteLink = 'Website Link';
const  labelAmountValue = 'Amount Value';
const  labelPercentageValue = 'Percentage Value';
const  labelFieldName = 'Field Name';
const  labelMandatory = 'Mandatory';

const String menuBasic = 'Basic';
const String menuTickets = 'Tickets';
const String menuForms = 'Forms';
const String menuGallery = 'Gallery';
const String menuSettings = 'Settings';

const String msgNoData = 'No Data';

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


const String btnSignIn = 'Sign In';
const String btnSignUp = 'Sign Up';
const String btnBack = 'Back';
const String btnReset = 'Reset';
const String btnSubmit = 'Submit';
const String btnNext = 'Next';
const String btnCancel = 'Cancel';
const String btnPrevious = 'Previous';
const String btnClose = 'Close';
const String btnSave = 'Save';
const String btnLogout = 'Logout';
const String btnCreateTicket = 'Create Ticket';
const String btnCreateFields = 'Create Fields';

const String inputHintPhoneEmail = 'Phone No/Email';
const String inputHintEmail = 'Email';
const String inputHintPassword = 'Password';
const String inputHintConfirmPassword = 'Confirm Password';
const String inputHintFirstName = 'First Name';
const String inputHintPhoneNo = 'Phone No';
const String inputHintEventName = 'Type your event name';
const String inputHintCarnival= 'Select your carnival';
const String inputHintTimeZone = 'Select your zone';
const String inputHintTagEvent = 'Tag your event';
const String inputHintTag= 'Tag your event';
const String inputHintTime = '00:00';
const String inputHintDate = 'DD/MM/YYYY';
const String inputHintTypeYourLocation = 'Type your Location';
const String inputHintDescription = 'Description';
const String inputHintQuantity= 'Quantity';
const String inputHintPrice= 'Enter ticket price';
const String inputHintTicketName = 'Type your ticket name';
const String inputHintSalesEndDate= 'Sales end date';
const String inputHintPercentage = 'Type your Percentage';
const String inputHintBookNow = 'Ex:- Book Now';
const String inputHintFacebookLink = 'Ex:-https://faecbook.com/hat...';
const String inputHintTwitterLink = 'Ex:-https://twitter.com/hat...';
const String inputHintLinkedInLink = 'Ex:-https://linkedin.com/hat...';
const String inputHintWebsiteLink = 'Ex:-https://Carnivallist.com/';
const String inputHintAmount = 'Type your Amount';
const String inputHintFieldName = 'Type your field name';

const String profileImage = 'assets/images/user_profile.png';
const String headerBackgroundImage = 'assets/images/header_background.png';

const String bottomMenuBarHomeImage = 'assets/images/bottom_menu_bar_home.png';
const String bottomMenuBarEventImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarCouponsImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarAddImage = 'assets/images/bottom_menu_bar_user.png';
const String bottomMenuBarUserImage = 'assets/images/bottom_menu_bar_user.png';


//TODO COLOR
const String colorProgressBar = '#10089b';
const String colorTitle = '#10089b';
const String bgColorFloatingActionButton = '#af52de';
const String bgColor = '#FFF4FF';
const String colorBottomBarMenu = '#FEFEFE';
const Color colorHeaderTitle = Colors.white;
const Color colorSubHeader = Colors.black;
const String colorCreateEventBg = '#8c3ee9';


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