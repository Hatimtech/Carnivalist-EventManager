class LoginResponse {
  final int code;
  final String token, message;

  LoginResponse({this.code, this.token, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      token: json['token'],
      message: json['message']
    );
  }
}
