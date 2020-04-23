abstract class LoginEvent {}

class MobileInput extends LoginEvent {
  final String mobile;
  MobileInput({this.mobile});
}

class PasswordInput extends LoginEvent {
  final String password;
  PasswordInput({this.password});
}

class Login extends LoginEvent {
  Function callback;
  String authToken;
  Login({this.callback, this.authToken});
}
