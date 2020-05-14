import 'package:eventmanagement/model/coupons/coupon_parameters.dart';
import 'package:eventmanagement/utils/vars.dart';

class Coupon {
  String id;
  String couponType;
  bool active;
  CouponParameters couponParameters;
  String couponId;
  String user;
  DateTime createdAt;
  DateTime updatedAt;

  Coupon({
    this.id,
    this.couponType,
    this.active,
    this.couponParameters,
    this.couponId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    couponType = json['couponType'];
    active = json['active'];
    couponParameters = json['couponParameters'] != null
        ? CouponParameters.fromJson(json['couponParameters'])
        : null;
    couponId = json['couponId'];
    user = json['user'];
    createdAt =
        isValid(json['createdAt']) ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        isValid(json['updatedAt']) ? DateTime.parse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.couponType != null) data['couponType'] = this.couponType;
    if (this.active != null) data['active'] = this.active;
    if (this.couponParameters != null)
      data['couponParameters'] = this.couponParameters.toJson();
    if (this.couponId != null) data['couponId'] = this.couponId;
    if (this.user != null) data['user'] = this.user;
    if (this.createdAt != null)
      data['createdAt'] = this.createdAt.toIso8601String();
    if (this.updatedAt != null)
      data['updatedAt'] = this.updatedAt.toIso8601String();

    return data;
  }
}
