class SendMailResponse {
  int code;
  String message;

  SendMailResponse({this.code, this.message});

  SendMailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
