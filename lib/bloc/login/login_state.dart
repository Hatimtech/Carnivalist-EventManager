import 'package:meta/meta.dart';

class LoginState  {
  final String mobile;
  final String password;
  bool loading;

  LoginState({
    @required this.mobile,
    @required this.password,
    bool loading,
  });

  factory LoginState.initial() {
    return LoginState(
      mobile: "",
      password: "",
    );
  }

  LoginState copyWith(
      {bool loading,
      String mobile,
      String password}) {

    return LoginState(
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
    );
  }
}
