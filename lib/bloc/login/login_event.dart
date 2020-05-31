import 'package:eventmanagement/model/logindetail/login_detail_response.dart';

abstract class LoginEvent {}

class MobileInput extends LoginEvent {
  final String mobile;

  MobileInput({this.mobile});
}

class PasswordInput extends LoginEvent {
  final String password;

  PasswordInput({this.password});
}

class EventStaffInput extends LoginEvent {
  final bool eventStaffLogin;

  EventStaffInput({this.eventStaffLogin});
}

class Login extends LoginEvent {
  Function callback;
  String authToken;

  Login({this.callback, this.authToken});
}

class LoginResult extends LoginEvent {
  bool success;
  dynamic uiMsg;
  LoginDetailResponse loginDetailResponse;

  LoginResult(this.success, {this.uiMsg, this.loginDetailResponse});
}
