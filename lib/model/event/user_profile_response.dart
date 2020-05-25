class UserProfileResponse {
  int code;
  String message;

  UserProfileResponse({this.code, this.message});

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
