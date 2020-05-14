class CouponActionResponse {
  int code;
  String message;

  CouponActionResponse({this.code, this.message});

  CouponActionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
