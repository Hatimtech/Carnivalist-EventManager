import 'dart:async';
import 'dart:ui';

import 'package:eventmanagement/intl/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final String _localeName;

  AppLocalizations(this._localeName) {}

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  String get appTitle =>
      Intl.message("Carnivalist", name: "appTitle", locale: _localeName);

  //TITLE
  String get titleSignUp =>
      Intl.message('Sign Up', name: "titleSignUp", locale: _localeName);

  String get titleForgotPassword => Intl.message('Forgot Password',
      name: "titleForgotPassword", locale: _localeName);

  String get titleSignIn =>
      Intl.message('Sign In', name: "titleSignIn", locale: _localeName);

  String get titleDashboard =>
      Intl.message('Dashboard', name: "titleDashboard", locale: _localeName);

  String get titleCreateEvent => Intl.message('Create Event',
      name: "titleCreateEvent", locale: _localeName);

  String get titleBasicInfo =>
      Intl.message('Basic Info', name: "titleBasicInfo", locale: _localeName);

  String get titleEventDate =>
      Intl.message('Event Date', name: "titleEventDate", locale: _localeName);

  String get titleAddress =>
      Intl.message('Address', name: "titleAddress", locale: _localeName);

  String get titleDescription => Intl.message('Description',
      name: "titleDescription", locale: _localeName);

  String get titleTicketDetails => Intl.message('Enter your ticket details',
      name: "titleTicketDetails", locale: _localeName);

  String get titlePaymentAndFees => Intl.message('Payments and fees',
      name: "titlePaymentAndFees", locale: _localeName);

  String get titleCustomLabels => Intl.message('Custom Labels',
      name: "titleCustomLabels", locale: _localeName);

  String get titleCustomSettings => Intl.message('Custom Settings',
      name: "titleCustomSettings", locale: _localeName);

  String get titleCustomField => Intl.message('Create your custom field',
      name: "titleCustomField", locale: _localeName);

//TODO LABEL
  String get labelForgotPassword => Intl.message('Forgot Password',
      name: "labelForgotPassword", locale: _localeName);

  String get labelSignUp =>
      Intl.message("Sign Up", name: "labelSignUp", locale: _localeName);

  String get labelSignIn =>
      Intl.message("Sign In", name: "labelSignIn", locale: _localeName);

  String get labelDoNotAccount => Intl.message("Dont't have an account?",
      name: "labelDoNotAccount", locale: _localeName);

  String get labelBecomeAVendorPartner =>
      Intl.message("Become a vendor partner.",
          name: "labelBecomeAVendorPartner", locale: _localeName);

  String get labelSignUpAgreement =>
      Intl.message("By signing up, you agree to our \nTerms & Privacy Policy.",
          name: "labelSignUpAgreement", locale: _localeName);

  String get labelAlredyAccount => Intl.message("Alredy have an account?",
      name: "labelAlredyAccount", locale: _localeName);

  String get labelEventName =>
      Intl.message('Event name', name: "labelEventName", locale: _localeName);

  String get labelCarnivalName =>
      Intl.message('Carnival', name: "labelCarnivalName", locale: _localeName);

  String get labelTimeZone =>
      Intl.message('Time zone', name: "labelTimeZone", locale: _localeName);

  String get labelTags =>
      Intl.message('Tags', name: "labelTags", locale: _localeName);

  String get labelStartDate =>
      Intl.message('Start date', name: "labelStartDate", locale: _localeName);

  String get labelStartTime =>
      Intl.message('Start time', name: "labelStartTime", locale: _localeName);

  String get labelEndDate =>
      Intl.message('End date', name: "labelEndDate", locale: _localeName);

  String get labelEndTime =>
      Intl.message('End time', name: "labelEndTime", locale: _localeName);

  String get labelLocation =>
      Intl.message('Location', name: "labelLocation", locale: _localeName);

  String get labelState =>
      Intl.message('State', name: "labelState", locale: _localeName);

  String get labelCity =>
      Intl.message('City', name: "labelCity", locale: _localeName);

  String get labelPostalCode =>
      Intl.message('Postal code', name: "labelPostalCode", locale: _localeName);

  String get labelSelectState => Intl.message('Select state',
      name: "labelSelectState", locale: _localeName);

  String get labelTypeCityName => Intl.message('Type city name',
      name: "labelTypeCityName", locale: _localeName);

  String get labelTypePostalCode => Intl.message('Type postal code',
      name: "labelTypePostalCode", locale: _localeName);

  String get labelTicketName =>
      Intl.message('Ticket Name', name: "labelTicketName", locale: _localeName);

  String get labelPrice =>
      Intl.message('Price', name: "labelPrice", locale: _localeName);

  String get labelSalesEnds =>
      Intl.message('Sales Ends', name: "labelSalesEnds", locale: _localeName);

  String get labelTotalAvailable => Intl.message('Total Available',
      name: "labelTotalAvailable", locale: _localeName);

  String get labelMinBooking =>
      Intl.message('Min Booking', name: "labelMinBooking", locale: _localeName);

  String get labelMaxBooking =>
      Intl.message('Max Booking', name: "labelMaxBooking", locale: _localeName);

  String get labelDescription => Intl.message('Description',
      name: "labelDescription", locale: _localeName);

  String get labelConvenienceFee => Intl.message('Convenience Fee',
      name: "labelConvenienceFee", locale: _localeName);

  String get labelPaymentGatewayCharge =>
      Intl.message('Who will pay payment Gateway charges',
          name: "labelPaymentGatewayCharge", locale: _localeName);

  String get labelBookingCancel => Intl.message('Booking Cancellation',
      name: "labelBookingCancel", locale: _localeName);

  String get labelTicketResale => Intl.message('Ticket Resale',
      name: "labelTicketResale", locale: _localeName);

  String get labelRemainingTickets => Intl.message('Remaining Tickets',
      name: "labelRemainingTickets", locale: _localeName);

  String get labelRegistrationButton =>
      Intl.message('Registration button label',
          name: "labelRegistrationButton", locale: _localeName);

  String get labelFacebookLink => Intl.message('Facebook Link',
      name: "labelFacebookLink", locale: _localeName);

  String get labelTwitterLink => Intl.message('Twitter Link',
      name: "labelTwitterLink", locale: _localeName);

  String get labelLinkedInLink => Intl.message('Linkedin Link',
      name: "labelLinkedInLink", locale: _localeName);

  String get labelWebsiteLink => Intl.message('Website Link',
      name: "labelWebsiteLink", locale: _localeName);

  String get labelAmountValue => Intl.message('Amount Value',
      name: "labelAmountValue", locale: _localeName);

  String get labelPercentageValue => Intl.message('Percentage Value',
      name: "labelPercentageValue", locale: _localeName);

  String get labelFieldName =>
      Intl.message('Field Name', name: "labelFieldName", locale: _localeName);

  String get typeFieldName => Intl.message('Type your field name',
      name: "typeFieldName", locale: _localeName);

  String get labelMandatory =>
      Intl.message('Mandatory', name: "labelMandatory", locale: _localeName);

  String get menuBasic =>
      Intl.message('Basic', name: "menuBasic", locale: _localeName);

  String get menuTickets =>
      Intl.message('Tickets', name: "menuTickets", locale: _localeName);

  String get menuForms =>
      Intl.message('Forms', name: "menuForms", locale: _localeName);

  String get menuGallery =>
      Intl.message('Gallery', name: "menuGallery", locale: _localeName);

  String get menuSettings =>
      Intl.message('Settings', name: "menuSettings", locale: _localeName);

  String get msgNoData =>
      Intl.message('No Data', name: "msgNoData", locale: _localeName);

  String get btnSignIn =>
      Intl.message('Sign In', name: "btnSignIn", locale: _localeName);

  String get btnSignUp =>
      Intl.message('Sign Up', name: "btnSignUp", locale: _localeName);

  String get btnBack =>
      Intl.message('Back', name: "btnBack", locale: _localeName);

  String get btnReset =>
      Intl.message('Reset', name: "btnReset", locale: _localeName);

  String get btnSubmit =>
      Intl.message('Submit', name: "btnSubmit", locale: _localeName);

  String get btnNext =>
      Intl.message('Next', name: "btnNext", locale: _localeName);

  String get btnCancel =>
      Intl.message('Cancel', name: "btnCancel", locale: _localeName);

  String get btnPrevious =>
      Intl.message('Previous', name: "btnPrevious", locale: _localeName);

  String get btnClose =>
      Intl.message('Close', name: "btnClose", locale: _localeName);

  String get btnSave =>
      Intl.message('Save', name: "btnSave", locale: _localeName);

  String get btnLogout =>
      Intl.message('Logout', name: "btnLogout", locale: _localeName);

  String get btnCreateTicket => Intl.message('Create Ticket',
      name: "btnCreateTicket", locale: _localeName);

  String get btnCreateFields => Intl.message('Create Fields',
      name: "btnCreateFields", locale: _localeName);

  String get inputHintPhoneEmail => Intl.message('Phone No/Email',
      name: "inputHintPhoneEmail", locale: _localeName);

  String get inputHintEmail =>
      Intl.message('Email', name: "inputHintEmail", locale: _localeName);

  String get inputHintPassword =>
      Intl.message('Password', name: "inputHintPassword", locale: _localeName);

  String get inputHintConfirmPassword => Intl.message('Confirm Password',
      name: "inputHintConfirmPassword", locale: _localeName);

  String get inputHintFirstName => Intl.message('First Name',
      name: "inputHintFirstName", locale: _localeName);

  String get inputHintPhoneNo =>
      Intl.message('Phone No', name: "inputHintPhoneNo", locale: _localeName);

  String get inputHintEventName => Intl.message('Type your event name',
      name: "inputHintEventName", locale: _localeName);

  String get inputHintCarnival => Intl.message('Select your carnival',
      name: "inputHintCarnival", locale: _localeName);

  String get inputHintTimeZone => Intl.message('Select your zone',
      name: "inputHintTimeZone", locale: _localeName);

  String get inputHintTagEvent => Intl.message('Tag your event',
      name: "inputHintTagEvent", locale: _localeName);

  String get inputHintTag =>
      Intl.message('Tag your event', name: "inputHintTag", locale: _localeName);

  String get inputHintTime =>
      Intl.message('00:00', name: "inputHintTime", locale: _localeName);

  String get inputHintDate =>
      Intl.message('DD/MM/YYYY', name: "inputHintDate", locale: _localeName);

  String get inputHintTypeYourLocation => Intl.message('Type your Location',
      name: "inputHintTypeYourLocation", locale: _localeName);

  String get inputHintDescription => Intl.message('Description',
      name: "inputHintDescription", locale: _localeName);

  String get inputHintQuantity =>
      Intl.message('Quantity', name: "inputHintQuantity", locale: _localeName);

  String get inputHintPrice => Intl.message('Enter ticket price',
      name: "inputHintPrice", locale: _localeName);

  String get inputHintTicketName => Intl.message('Type your ticket name',
      name: "inputHintTicketName", locale: _localeName);

  String get inputHintSalesEndDate => Intl.message('Sales end date',
      name: "inputHintSalesEndDate", locale: _localeName);

  String get inputHintPercentage => Intl.message('Type your Percentage',
      name: "inputHintPercentage", locale: _localeName);

  String get inputHintBookNow => Intl.message('Ex:- Book Now',
      name: "inputHintBookNow", locale: _localeName);

  String get inputHintFacebookLink =>
      Intl.message('Ex:-https://faecbook.com/hat...',
          name: "inputHintFacebookLink", locale: _localeName);

  String get inputHintTwitterLink =>
      Intl.message('Ex:-https://twitter.com/hat...',
          name: "inputHintTwitterLink", locale: _localeName);

  String get inputHintLinkedInLink =>
      Intl.message('Ex:-https://linkedin.com/hat...',
          name: "inputHintLinkedInLink", locale: _localeName);

  String get inputHintWebsiteLink =>
      Intl.message('Ex:-https://Carnivallist.com/',
          name: "inputHintWebsiteLink", locale: _localeName);

  String get inputHintAmount => Intl.message('Type your Amount',
      name: "inputHintAmount", locale: _localeName);

  String get inputHintFieldName => Intl.message('Type your field name',
      name: "inputHintFieldName", locale: _localeName);
}

class AppTranslationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale newLocale;

  const AppTranslationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return ["en", "fr"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
