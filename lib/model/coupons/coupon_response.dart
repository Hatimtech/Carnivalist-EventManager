import 'package:eventmanagement/model/coupons/coupon.dart';

class CouponResponse {
  int code;
  List<Coupon> coupons;
  String message;

  CouponResponse({this.code, this.coupons});

  CouponResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    coupons =
        (json['coupons'] as List)?.map((e) => Coupon.fromJson(e))?.toList();
    message = json['message'];
  }
}
