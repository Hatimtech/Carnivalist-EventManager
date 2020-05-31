import 'package:meta/meta.dart';

class LoginState {
  final String mobile;
  final String password;
  final bool eventStaffLogin;
  bool loading;
  dynamic uiMsg;

  LoginState({
    @required this.mobile,
    @required this.password,
    @required this.eventStaffLogin,
    this.loading,
    this.uiMsg,
  });

  factory LoginState.initial() {
    return LoginState(
      mobile: "",
      password: "",
      eventStaffLogin: false,
    );
  }

  LoginState copyWith({
    bool loading,
    String mobile,
    String password,
    bool eventStaffLogin,
    dynamic uiMsg,
  }) {
    return LoginState(
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      eventStaffLogin: eventStaffLogin ?? this.eventStaffLogin,
      loading: loading ?? loading,
      uiMsg: uiMsg,
    );
  }
}
