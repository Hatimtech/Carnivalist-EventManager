import 'login_detail.dart';

class LoginDetailResponse {
  final int code;
  final String message;
  final LoginDetail loginDetail;

  LoginDetailResponse({this.code, this.message, this.loginDetail});

  factory LoginDetailResponse.fromJson(Map<String, dynamic> json) {
    return LoginDetailResponse(
        code: json['code'],
        message: json['message'],
        loginDetail: LoginDetail.fromJson(json['user']));
  }
}
