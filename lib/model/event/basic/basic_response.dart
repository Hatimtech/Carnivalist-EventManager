class BasicResponse {
  int code;
  String message;

  BasicResponse({this.code, this.message});

  BasicResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
