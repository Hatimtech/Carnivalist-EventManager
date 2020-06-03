import 'dart:async';

import 'package:eventmanagement/model/coupons/coupon.dart';

abstract class CouponEvent {}

class AuthTokenSave extends CouponEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class AddCoupon extends CouponEvent {
  final Coupon coupon;

  AddCoupon(this.coupon);
}

class UpdateCoupon extends CouponEvent {
  final Coupon coupon;

  UpdateCoupon(this.coupon);
}

class DeleteCoupon extends CouponEvent {
  final String id;
  final Function callback;

  DeleteCoupon(this.id, this.callback);
}

class GetAllCoupons extends CouponEvent {
  Completer<bool> downloadCompleter;

  GetAllCoupons({this.downloadCompleter});
}

class CouponListAvailable extends CouponEvent {
  final bool success;
  final dynamic error;
  final List<Coupon> couponList;

  CouponListAvailable(this.success, {this.error, this.couponList});
}

class ActiveInactiveCoupon extends CouponEvent {
  final String couponId;
  final bool active;
  final Function callback;

  ActiveInactiveCoupon(this.couponId, this.active, this.callback);
}

class ActiveInactiveCouponResult extends CouponEvent {
  final bool success;
  final String couponId;
  final bool active;
  final dynamic uiMsg;

  ActiveInactiveCouponResult(this.success,
      {this.couponId, this.active, this.uiMsg});
}


class DeleteCouponResult extends CouponEvent {
  final bool success;
  final String couponId;
  final dynamic uiMsg;

  DeleteCouponResult(this.success, {this.couponId, this.uiMsg});
}
