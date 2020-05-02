class FormActionResponse {
  int code;
  String message;

  FormActionResponse({this.code, this.message});

  FormActionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
