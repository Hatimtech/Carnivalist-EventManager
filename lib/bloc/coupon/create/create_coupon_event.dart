import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';

abstract class CreateCouponEvent {}

class AuthTokenSave extends CreateCouponEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class CreateCouponDefault extends CreateCouponEvent {
  CreateCouponDefault();
}

class CouponTypeInput extends CreateCouponEvent {
  final String couponType;

  CouponTypeInput({this.couponType});
}

class CodeTypeInput extends CreateCouponEvent {
  final String codeType;

  CodeTypeInput({this.codeType});
}

class DiscountNameInput extends CreateCouponEvent {
  final String discountName;

  DiscountNameInput({this.discountName});
}

class CodeInput extends CreateCouponEvent {
  final String code;

  CodeInput({this.code});
}

class DiscountValueInput extends CreateCouponEvent {
  final String discountValue;

  DiscountValueInput({this.discountValue});
}

class NoOfDiscountInput extends CreateCouponEvent {
  final String noOfDiscount;

  NoOfDiscountInput({this.noOfDiscount});
}

class DiscountTypeInput extends CreateCouponEvent {
  final MenuCustom discountType;

  DiscountTypeInput({this.discountType});
}

class StartDateTimeInput extends CreateCouponEvent {
  final DateTime startDateTime;

  StartDateTimeInput({this.startDateTime});
}

class EndDateTimeInput extends CreateCouponEvent {
  final DateTime endDateTime;

  EndDateTimeInput({this.endDateTime});
}

class MinQuantityInput extends CreateCouponEvent {
  final String minQuantity;

  MinQuantityInput({this.minQuantity});
}

class MaxQuantityInput extends CreateCouponEvent {
  final String maxQuantity;

  MaxQuantityInput({this.maxQuantity});
}

class AffiliateEmailInput extends CreateCouponEvent {
  final String email;

  AffiliateEmailInput({this.email});
}

class SelectEventInput extends CreateCouponEvent {
  final EventData eventData;

  SelectEventInput({this.eventData});
}

class SelectPastEventInput extends CreateCouponEvent {
  final EventData eventData;

  SelectPastEventInput({this.eventData});
}

class AddEventTicketInput extends CreateCouponEvent {
  final String ticketId;

  AddEventTicketInput({this.ticketId});
}

class RemoveEventTicketInput extends CreateCouponEvent {
  final String ticketId;

  RemoveEventTicketInput({this.ticketId});
}

class UploadCoupon extends CreateCouponEvent {
  Function callback;

  UploadCoupon({this.callback});
}

class UploadCouponResult extends CreateCouponEvent {
  final bool success;
  final dynamic uiMsg;

  UploadCouponResult(this.success, {this.uiMsg});
}
