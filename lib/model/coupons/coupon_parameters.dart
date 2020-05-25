import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/utils/vars.dart';

class CouponParameters {
  String codeType;
  String discountName;
  String code;
  int discountValue;
  String currency;
  String prefix;
  List<String> checkedTicket;
  DateTime startDateTime;
  DateTime endDateTime;
  int noOfDiscount;
  String discountType;
  int minQuantity;
  int maxQuantity;
  String affiliateEmailId;
  EventData selectedPastEvent;
  String user;
  EventData selectedEvent;
  DateTime createdAt;
  DateTime updatedAt;

  CouponParameters({
    this.codeType,
    this.discountName,
    this.code,
    this.checkedTicket,
    this.startDateTime,
    this.endDateTime,
    this.discountValue,
    this.currency,
    this.noOfDiscount,
    this.discountType,
    this.minQuantity,
    this.maxQuantity,
    this.affiliateEmailId,
    this.selectedEvent,
    this.selectedPastEvent,
    this.prefix,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  CouponParameters.fromJson(Map<String, dynamic> json) {
    codeType = json['codeType'];
    discountName = json['discountName'];
    code = json['code'];
    startDateTime = isValid(json['startDateTime'])
        ? DateTime.parse(json['startDateTime'])
        : null;
    endDateTime = isValid(json['endDateTime'])
        ? DateTime.parse(json['endDateTime'])
        : null;
    discountValue = json['discountValue'];
    currency = json['currency'];
    prefix = json['prefix'];
    noOfDiscount = json['noOfDiscount'];
    discountType = json['discountType'];
    minQuantity = json['minQuantity'];
    maxQuantity = json['maxQuantity'];
    checkedTicket = json['checkedTicket']?.cast<String>() ?? [];
    affiliateEmailId = json['affiliateEmailId'];
    selectedEvent = json['selectedEvent'] != null
        ? EventData.fromJson(json['selectedEvent'])
        : null;
    selectedPastEvent = json['selectedPastEvent'] != null
        ? EventData.fromJson(json['selectedPastEvent'])
        : null;
    user = json['user'];
    createdAt =
        isValid(json['createdAt']) ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        isValid(json['updatedAt']) ? DateTime.parse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.codeType != null) data['codeType'] = this.codeType;
    if (this.discountName != null) data['discountName'] = this.discountName;
    if (this.code != null) data['code'] = this.code;
    if (this.startDateTime != null)
      data['startDateTime'] = this.startDateTime.toIso8601String();
    if (this.endDateTime != null)
      data['endDateTime'] = this.endDateTime.toIso8601String();
    if (this.discountValue != null) data['discountValue'] = this.discountValue;
    if (this.currency != null) data['currency'] = this.currency;
    if (this.prefix != null) data['prefix'] = this.prefix;
    if (this.noOfDiscount != null) data['noOfDiscount'] = this.noOfDiscount;

    if (this.discountType != null) data['discountType'] = this.discountType;
    if (this.checkedTicket != null) data['checkedTicket'] = this.checkedTicket;
    if (this.minQuantity != null) data['minQuantity'] = this.minQuantity;
    if (this.maxQuantity != null) data['maxQuantity'] = this.maxQuantity;
    if (this.affiliateEmailId != null)
      data['affiliateEmailId'] = this.affiliateEmailId;

    if (this.selectedEvent != null)
      data['selectedEvent'] = this.selectedEvent.toJson();
    if (this.selectedPastEvent != null)
      data['selectedPastEvent'] = this.selectedPastEvent.toJson();

    if (this.user != null) data['user'] = this.user;

    if (this.createdAt != null)
      data['createdAt'] = this.createdAt.toIso8601String();
    if (this.updatedAt != null)
      data['updatedAt'] = this.updatedAt.toIso8601String();
    return data;
  }
}
