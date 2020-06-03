import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';

class CreateCouponState {
  final String authToken;
  final String couponType;
  final String codeType;
  final String discountName;
  final String code;
  final String discountValue;
  final String noOfDiscount;
  final List<MenuCustom> discountTypeList;
  final String minQuantity;
  final String maxQuantity;
  final String affiliateEmailId;

  final DateTime startDateTime, endDateTime;

  final List<String> checkedTicket;
  final EventData selectedEvent;
  final EventData selectedPastEvent;

  bool loading;
  dynamic uiMsg;

  CreateCouponState({
    this.authToken,
    this.codeType,
    this.discountName,
    this.startDateTime,
    this.endDateTime,
    this.code,
    this.discountValue,
    this.noOfDiscount,
    this.discountTypeList,
    this.couponType,
    this.minQuantity,
    this.maxQuantity,
    this.affiliateEmailId,
    this.checkedTicket,
    this.selectedEvent,
    this.selectedPastEvent,
    bool loading,
    this.uiMsg,
  });

  factory CreateCouponState.initial({String couponType}) {
    return CreateCouponState(
      authToken: '',
      codeType: '',
      discountName: '',
      startDateTime: null,
      endDateTime: null,
      code: '',
      discountValue: '',
      noOfDiscount: '',
      discountTypeList: [],
      couponType: couponType ?? '',
      minQuantity: '',
      maxQuantity: '',
      affiliateEmailId: '',
      checkedTicket: [],
      selectedEvent: null,
      selectedPastEvent: null,
      loading: false,
      uiMsg: null,
    );
  }

  factory CreateCouponState.copyWith(
    Coupon coupon,
    List<MenuCustom> discountTypeList,
  ) {
    final couponParams = coupon.couponParameters;
    return CreateCouponState(
      authToken: '',
      codeType: couponParams.codeType ?? '',
      discountName: couponParams.discountName ?? '',
      startDateTime: couponParams.startDateTime?.toLocal(),
      endDateTime: couponParams.endDateTime?.toLocal(),
      code: couponParams.code ?? '',
      discountValue: couponParams.discountValue?.toString() ?? '',
      noOfDiscount: couponParams.noOfDiscount?.toString() ?? '',
      discountTypeList: discountTypeList,
      couponType: coupon.couponType ?? '',
      minQuantity: couponParams.minQuantity?.toString() ?? '',
      maxQuantity: couponParams.maxQuantity?.toString() ?? '',
      affiliateEmailId: couponParams.affiliateEmailId ?? '',
      checkedTicket: couponParams.checkedTicket ?? [],
      selectedEvent: couponParams.selectedEvent,
      selectedPastEvent: couponParams.selectedPastEvent,
      loading: false,
      uiMsg: null,
    );
  }

  CreateCouponState copyWith({
    String authToken,
    String codeType,
    String discountName,
    DateTime startDateTime,
    DateTime endDateTime,
    String code,
    String discountValue,
    String noOfDiscount,
    List<MenuCustom> discountTypeList,
    String couponType,
    String minQuantity,
    String maxQuantity,
    String affiliateEmailId,
    List<String> checkedTicket,
    EventData selectedEvent,
    EventData selectedPastEvent,
    bool loading,
    dynamic uiMsg,
  }) {
    return CreateCouponState(
      authToken: authToken ?? this.authToken,
      codeType: codeType ?? this.codeType,
      discountName: discountName ?? this.discountName,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      code: code ?? this.code,
      discountValue: discountValue ?? this.discountValue,
      noOfDiscount: noOfDiscount ?? this.noOfDiscount,
      discountTypeList: discountTypeList ?? this.discountTypeList,
      couponType: couponType ?? this.couponType,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      affiliateEmailId: affiliateEmailId ?? this.affiliateEmailId,
      checkedTicket: checkedTicket ?? this.checkedTicket,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      selectedPastEvent: selectedPastEvent ?? this.selectedPastEvent,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
    );
  }
}
