import 'package:meta/meta.dart';

class LoginState {
  final String mobile;
  final String password;
  bool loading;
  dynamic uiMsg;

  LoginState({
    @required this.mobile,
    @required this.password,
    this.loading,
    this.uiMsg,
  });

  factory LoginState.initial() {
    return LoginState(
      mobile: "",
      password: "",
    );
  }

  LoginState copyWith({
    bool loading,
    String mobile,
    String password,
    dynamic uiMsg,
  }) {
    return LoginState(
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      loading: loading ?? loading,
      uiMsg: uiMsg,
    );
  }
}
