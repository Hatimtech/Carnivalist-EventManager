class StaffActionResponse {
  int code;
  String message;

  StaffActionResponse({this.code, this.message});

  StaffActionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
