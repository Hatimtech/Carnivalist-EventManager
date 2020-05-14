import 'package:eventmanagement/model/coupons/coupon.dart';

class CouponState {
  final String authToken;
  final List<Coupon> couponList;
  bool loading;
  dynamic uiMsg;

  CouponState({
    this.authToken,
    this.couponList,
    this.loading,
    this.uiMsg,
  });

  factory CouponState.initial() {
    return CouponState(
      authToken: "",
      couponList: List(),
      loading: false,
      uiMsg: null,
    );
  }

  CouponState copyWith({
    bool loading,
    String authToken,
    List<Coupon> couponList,
    dynamic uiMsg,
  }) {
    return CouponState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      couponList: couponList ?? this.couponList,
      uiMsg: uiMsg,
    );
  }
}
