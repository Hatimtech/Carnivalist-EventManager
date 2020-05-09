import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';

abstract class SettingEvent {}

class AuthTokenSave extends SettingEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class SettingDefault extends SettingEvent {
  SettingDefault();
}

class PopulateExistingEvent extends SettingEvent {
  final EventData eventData;

  PopulateExistingEvent({this.eventData});
}

class PaymentType extends SettingEvent {
}

class SelectPaymentGatewayPayBy extends SettingEvent {
  final MenuCustom paymentBy;

  SelectPaymentGatewayPayBy({this.paymentBy});
}

class SelectConvenienceFee extends SettingEvent {
  final bool enable;

  SelectConvenienceFee({this.enable});
}

class ConveniencePercentageInput extends SettingEvent {
  final String input;

  ConveniencePercentageInput({this.input});
}

class ConvenienceAmountInput extends SettingEvent {
  final String input;

  ConvenienceAmountInput({this.input});
}

class SelectBookingCancellation extends SettingEvent {
  final bool enable;

  SelectBookingCancellation({this.enable});
}

class BookingCancellationDescInput extends SettingEvent {
  final String input;

  BookingCancellationDescInput({this.input});
}

class AddCancellationPolicyOption extends SettingEvent {
  AddCancellationPolicyOption();
}

class RemoveCancellationPolicyOption extends SettingEvent {
  final int index;

  RemoveCancellationPolicyOption({this.index});
}

class CancellationPolicyDeductionType extends SettingEvent {
  final int index;
  final bool isPercentage;

  CancellationPolicyDeductionType({this.index, this.isPercentage});
}

class CancellationPolicyDeductionInput extends SettingEvent {
  final int index;
  final double input;

  CancellationPolicyDeductionInput({this.index, this.input});
}

class CancellationPolicyEndDate extends SettingEvent {
  final int index;
  final DateTime dateTime;

  CancellationPolicyEndDate({this.index, this.dateTime});
}

class SelectBookingTransfer extends SettingEvent {
  final bool enable;

  SelectBookingTransfer({this.enable});
}

class SelectRemainingTickets extends SettingEvent {
  final bool enable;

  SelectRemainingTickets({this.enable});
}

class RegistrationLabelInput extends SettingEvent {
  final String input;

  RegistrationLabelInput({this.input});
}

class FacebookLinkInput extends SettingEvent {
  final String input;

  FacebookLinkInput({this.input});
}

class TwitterLinkInput extends SettingEvent {
  final String input;

  TwitterLinkInput({this.input});
}

class LinkedInLinkInput extends SettingEvent {
  final String input;

  LinkedInLinkInput({this.input});
}

class WebsiteLinkInput extends SettingEvent {
  final String input;

  WebsiteLinkInput({this.input});
}

class TnCInput extends SettingEvent {
  final bool input;

  TnCInput({this.input});
}

class UploadSettings extends SettingEvent {
  Function callback;

  UploadSettings({this.callback});
}

class SettingDataUploadResult extends SettingEvent {
  final bool success;
  final dynamic uiMsg;

  SettingDataUploadResult(this.success, {this.uiMsg});
}

