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

  String get subtitleCancellationPolicy =>
      Intl.message('Cancellation Policy',
          name: "subtitleCancellationPolicy", locale: _localeName);

  String get titleCustomField => Intl.message('Create your custom field',
      name: "titleCustomField", locale: _localeName);

  String get titleFieldListDetails =>
      Intl.message('Enter list details',
          name: "titleFieldListDetails", locale: _localeName);

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

  String get labelEventType =>
      Intl.message('Event type', name: "labelEventType", locale: _localeName);

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

  String get labelEventDay =>
      Intl.message('Event Day', name: "labelEventDay", locale: _localeName);

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

  String get labelTicketCoupons =>
      Intl.message('Coupon: ', name: "labelTicketCoupons", locale: _localeName);

  String get labelTicketAddons =>
      Intl.message('Add ons: ', name: "labelTicketAddons", locale: _localeName);

  String get labelAssignAddon =>
      Intl.message('Assign Add-on',
          name: "labelAssignAddon", locale: _localeName);

  String get labelAssignCoupon =>
      Intl.message('Assign Coupon',
          name: "labelAssignCoupon", locale: _localeName);

  String get labelActiveTicket =>
      Intl.message('Active Ticket',
          name: "labelActiveTicket", locale: _localeName);

  String get labelInactiveTicket =>
      Intl.message('Inactive Ticket',
          name: "labelInactiveTicket", locale: _localeName);

  String get labelEditTicket =>
      Intl.message('Edit Ticket', name: "labelEditTicket", locale: _localeName);

  String get labelDeleteTicket =>
      Intl.message('Delete Ticket',
          name: "labelDeleteTicket", locale: _localeName);

  String get labelTicketSalesEnd =>
      Intl.message('sales end:',
          name: "labelTicketSalesEnd", locale: _localeName);

  String get labelTicketName =>
      Intl.message('Ticket Name', name: "labelTicketName", locale: _localeName);

  String get labelTicketCurrency =>
      Intl.message('Ticket Currency',
          name: "labelTicketCurrency", locale: _localeName);

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

  String get labelEditField =>
      Intl.message('Edit Field', name: "labelEditField", locale: _localeName);

  String get labelDeleteField =>
      Intl.message('Delete Field',
          name: "labelDeleteField", locale: _localeName);

  String get labelDescription => Intl.message('Description',
      name: "labelDescription", locale: _localeName);

  String get labelConvenienceFee => Intl.message('Convenience Fee',
      name: "labelConvenienceFee", locale: _localeName);

  String get labelPaymentGatewayCharge =>
      Intl.message('Who will pay payment Gateway charges',
          name: "labelPaymentGatewayCharge", locale: _localeName);

  String get labelBookingCancel => Intl.message('Booking Cancellation',
      name: "labelBookingCancel", locale: _localeName);

  String get labelCancellationDeductAmount =>
      Intl.message('Deduct amount in fixed value',
          name: "labelCancellationDeductAmount", locale: _localeName);

  String get labelCancellationDeductPercentage =>
      Intl.message('Deduct amount in percentage',
          name: "labelCancellationDeductPercentage", locale: _localeName);

  String get labelCancellationDeductAmountInput =>
      Intl.message('Amount will be deducted',
          name: "labelCancellationDeductAmountInput", locale: _localeName);

  String get labelCancellationDeductPercentageInput =>
      Intl.message('Percentage will be deducted',
          name: "labelCancellationDeductPercentageInput", locale: _localeName);

  String get labelCancellationEndDate =>
      Intl.message('Cancellation End Date',
          name: "labelCancellationEndDate", locale: _localeName);

  String get labelCancellationEndDateInput =>
      Intl.message('End Date',
          name: "labelCancellationEndDateInput", locale: _localeName);

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

  String get labelFieldPlaceholder =>
      Intl.message(
          'Placeholder', name: "labelFieldPlaceholder", locale: _localeName);

  String get typeFieldName => Intl.message('Type your field name',
      name: "typeFieldName", locale: _localeName);

  String get typeFieldPlaceholder =>
      Intl.message('Type your field placeholder',
          name: "typeFieldPlaceholder", locale: _localeName);

  String get typeListItemValue =>
      Intl.message('Type your list item value',
          name: "typeListItemValue", locale: _localeName);

  String get btnListItemAdd =>
      Intl.message('ADD',
          name: "btnListItemAdd", locale: _localeName);

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

  String get validateStep1 =>
      Intl.message('Please complete the current step.', name: "validateStep1",
          locale: _localeName);

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

  String get btnConfirm =>
      Intl.message('Confirm', name: "btnConfirm", locale: _localeName);

  String get btnLogout =>
      Intl.message('Logout', name: "btnLogout", locale: _localeName);

  String get btnCreateTicket => Intl.message('Create Ticket',
      name: "btnCreateTicket", locale: _localeName);

  String get btnCreateFields => Intl.message('Create Fields',
      name: "btnCreateFields", locale: _localeName);

  String get btnAddCancellationOption =>
      Intl.message('ADD MORE',
          name: "btnAddCancellationOption", locale: _localeName);

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

  String get inputHintEventType =>
      Intl.message('Select event tpye',
          name: "inputHintEventType", locale: _localeName);

  String get inputHintTimeZone => Intl.message('Select your zone',
      name: "inputHintTimeZone", locale: _localeName);

  String get inputHintTagEvent => Intl.message('Tag your event',
      name: "inputHintTagEvent", locale: _localeName);

  String get inputHintTag =>
      Intl.message('Tag your event', name: "inputHintTag", locale: _localeName);

  String get inputHintTime =>
      Intl.message('00:00', name: "inputHintTime", locale: _localeName);

  String get inputHintDate =>
      Intl.message('MM DD, YYYY', name: "inputHintDate", locale: _localeName);

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

  String get inputHintTicketCurrency =>
      Intl.message('Select Currency',
          name: "inputHintTicketCurrency", locale: _localeName);

  String get inputHintSalesEndDate => Intl.message('Sales end date',
      name: "inputHintSalesEndDate", locale: _localeName);

  String get inputHintPercentage => Intl.message('Type your Percentage',
      name: "inputHintPercentage", locale: _localeName);

  String get inputHintCancellationDesc =>
      Intl.message('Cancellation Policy Description',
          name: "inputHintCancellationDesc", locale: _localeName);

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

  String get labelYes =>
      Intl.message('Yes', name: "labelYes", locale: _localeName);

  String get labelNo =>
      Intl.message('No', name: "labelNo", locale: _localeName);

  String get labelUploadBanner =>
      Intl.message(
          'Click to Upload Your Banner Image', name: "labelUploadBanner",
          locale: _localeName);

  String get labelUpdateBanner =>
      Intl.message(
          'Click to Update Your Banner Image', name: "labelUpdateBanner",
          locale: _localeName);

  String get labelUploadEventGallery =>
      Intl.message('Upload your event gallery', name: "labelUploadEventGallery",
          locale: _localeName);

  String get labelUploadImage =>
      Intl.message(
          'Upload Image', name: "labelUploadImage", locale: _localeName);

  String get labelUploadVideo =>
      Intl.message(
          'Upload Video', name: "labelUploadVideo", locale: _localeName);

  /// Custom Menu Items
  String get labelEventOnce =>
      Intl.message('Once', name: "labelEventOnce", locale: _localeName);

  String get labelEventDaily =>
      Intl.message('Daily', name: "labelEventDaily", locale: _localeName);

  String get labelEventWeekly =>
      Intl.message('Weekly', name: "labelEventWeekly", locale: _localeName);

  String get labelEventCustom =>
      Intl.message('Custom', name: "labelEventCustom", locale: _localeName);

  String get labelEventCustomButton =>
      Intl.message('ADD THIS DATE',
          name: "labelEventCustomButton", locale: _localeName);

  String get labelEventPublic =>
      Intl.message('Public', name: "labelEventPublic", locale: _localeName);

  String get labelEventPrivate =>
      Intl.message('Private', name: "labelEventPrivate", locale: _localeName);

  String get labelEventPaymentMe =>
      Intl.message('Me', name: "labelEventPaymentMe", locale: _localeName);

  String get labelEventPaymentBuyer =>
      Intl.message('Buyer',
          name: "labelEventPaymentBuyer", locale: _localeName);

  String get labelEventFormText =>
      Intl.message('Text', name: "labelEventFormText", locale: _localeName);

  String get labelEventFormDate =>
      Intl.message('Date', name: "labelEventFormDate", locale: _localeName);

  String get labelEventFormSingleSelect =>
      Intl.message('Single Select',
          name: "labelEventFormSingleSelect", locale: _localeName);

  String get labelEventFormMultiSelect =>
      Intl.message('Multi-Select',
          name: "labelEventFormMultiSelect", locale: _localeName);

  String get labelSunday =>
      Intl.message('Sunday', name: "labelSunday", locale: _localeName);

  String get labelMonday =>
      Intl.message('Monday', name: "labelMonday", locale: _localeName);

  String get labelTuesday =>
      Intl.message('Tuesday', name: "labelTuesday", locale: _localeName);

  String get labelWednesday =>
      Intl.message('Wednesday', name: "labelWednesday", locale: _localeName);

  String get labelThursday =>
      Intl.message('Thursday', name: "labelThursday", locale: _localeName);

  String get labelFriday =>
      Intl.message('Friday', name: "labelFriday", locale: _localeName);

  String get labelSaturday =>
      Intl.message('Saturday', name: "labelSaturday", locale: _localeName);

  String get labelCamera =>
      Intl.message('Camera', name: "labelCamera", locale: _localeName);

  String get labelGallery =>
      Intl.message('Gallery', name: "labelGallery", locale: _localeName);

  String get inputValue =>
      Intl.message('Input Value', name: "inputValue", locale: _localeName);

  // Error Messages
  String get errorEventName =>
      Intl.message('Event name can not be empty',
          name: "errorEventName", locale: _localeName);

  String get errorEventDesc =>
      Intl.message('Event description can not be empty',
          name: "errorEventDesc", locale: _localeName);

  String get errorEventType =>
      Intl.message('Event type can not be empty',
          name: "errorEventType", locale: _localeName);

  String get errorEventTimezone =>
      Intl.message('Timezone can not be empty',
          name: "errorEventTimezone", locale: _localeName);

  String get errorEventAddress =>
      Intl.message('Address can not be empty',
          name: "errorEventAddress", locale: _localeName);

  String get errorEventState =>
      Intl.message('State can not be empty',
          name: "errorEventState", locale: _localeName);

  String get errorEventCity =>
      Intl.message('City can not be empty',
          name: "errorEventCity", locale: _localeName);

  String get errorEventPostal =>
      Intl.message('Postal code can be empty',
          name: "errorEventPostal", locale: _localeName);

  String get errorStartDate =>
      Intl.message('Start date can not be empty',
          name: "errorStartDate", locale: _localeName);

  String get errorStartTime =>
      Intl.message('Start time can not be empty',
          name: "errorStartTime", locale: _localeName);

  String get errorEndDate =>
      Intl.message('End date can not be empty',
          name: "errorEndDate", locale: _localeName);

  String get errorEndTime =>
      Intl.message('End time can not be empty',
          name: "errorEndTime", locale: _localeName);

  String get errorEndTimeLess =>
      Intl.message('End time can not be less than start time',
          name: "errorEndTimeLess", locale: _localeName);

  String get errorWeekday =>
      Intl.message('Weekday can not be empty',
          name: "errorWeekday", locale: _localeName);

  String get errorStartDateWeekday =>
      Intl.message('Start date should be on ',
          name: "errorStartDateWeekday", locale: _localeName);

  String get errorEndDateWeekday =>
      Intl.message('End date should be on ',
          name: "errorEndDateWeekday", locale: _localeName);

  String get errorTwoDateReq =>
      Intl.message('Atleast 2 custom dates are required',
          name: "errorTwoDateReq", locale: _localeName);

  String get errorDuplicateTag =>
      Intl.message('Duplicate Tag',
          name: "errorDuplicateTag", locale: _localeName);

  String get errorTicketLength =>
      Intl.message('Please create atleast 1 ticket.',
          name: "errorTicketLength", locale: _localeName);

  String get errorTicketName =>
      Intl.message('Ticket name can not be empty',
          name: "errorTicketName", locale: _localeName);

  String get errorTicketCurrency =>
      Intl.message('Ticket currency can not be empty',
          name: "errorTicketCurrency", locale: _localeName);

  String get errorTicketSaleEnd =>
      Intl.message('Sale end date can not be empty',
          name: "errorTicketSaleEnd", locale: _localeName);

  String get errorTicketAvailableQua =>
      Intl.message('Available quantity can not be empty',
          name: "errorTicketAvailableQua", locale: _localeName);

  String get errorTicketMinQua =>
      Intl.message('Min quantity can not be empty',
          name: "errorTicketMinQua", locale: _localeName);

  String get errorTicketMaxQua =>
      Intl.message('Max quantity can not be empty',
          name: "errorTicketMaxQua", locale: _localeName);

  String get errorTicketMinQuaLess =>
      Intl.message('Min quantity should be less than Max quantity',
          name: "errorTicketMinQuaLess", locale: _localeName);

  String get errorTicketMinMaxBet =>
      Intl.message(
          'Min and Max quantity should be less than or equal to Availabe quantity',
          name: "errorTicketMinMaxBet",
          locale: _localeName);

  String get errorFieldLabel =>
      Intl.message(
          'Field name can not be empty',
          name: "errorFieldLabel",
          locale: _localeName);

  String get errorFieldPlaceholder =>
      Intl.message(
          'Placeholder can not be empty',
          name: "errorFieldPlaceholder",
          locale: _localeName);

  String get errorDuplicateListItem =>
      Intl.message(
          'Duplicate list item is not allowed',
          name: "errorDuplicateListItem",
          locale: _localeName);

  String get errorNoListItem =>
      Intl.message(
          'Add atleast 1 list item',
          name: "errorNoListItem",
          locale: _localeName);

  String get errorCancellationDesc =>
      Intl.message(
          'Cancellation description can not be empty',
          name: "errorCancellationDesc",
          locale: _localeName);

  String get errorNoCancellationOption =>
      Intl.message(
          'Add atleast 1 cancellation option',
          name: "errorNoCancellationOption",
          locale: _localeName);

  String get errorTnc =>
      Intl.message(
          'Please review and accept terms of use and privacy policy.',
          name: "errorTnc",
          locale: _localeName);

  String get errorUnsavedBasic =>
      Intl.message(
          'You have unsaved changes in \'Basic\' section. Please submit them first.',
          name: "errorUnsavedBasic",
          locale: _localeName);

  String get errorUnsavedForm =>
      Intl.message(
          'You have unsaved changes in \'Forms\'. Please submit them first.',
          name: "errorUnsavedForm",
          locale: _localeName);

  String get errorUnsavedGallery =>
      Intl.message(
          'You have unsaved changes in \'Gallery\'. Please submit them first.',
          name: "errorUnsavedGallery",
          locale: _localeName);

  String get errorNoEventTypesAvailable =>
      Intl.message(
          'No event types available',
          name: "errorNoEventTypesAvailable",
          locale: _localeName);

  String get errorSomethingWrong =>
      Intl.message('Something went wrong',
          name: "errorSomethingWrong", locale: _localeName);
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
