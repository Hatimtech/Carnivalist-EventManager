class StripeResponse {
  int code;
  String stripeID;

  StripeResponse({this.code, this.stripeID});

  StripeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    stripeID = json['stripeID'];
  }
}
