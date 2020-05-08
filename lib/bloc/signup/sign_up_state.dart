import 'package:meta/meta.dart';

class SignUpState {
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  bool loading;
  dynamic uiMsg;

  SignUpState({
    @required this.name,
    @required this.email,
    @required this.mobile,
    @required this.password,
    @required this.confirmPassword,
    this.loading,
    this.uiMsg,
  });

  factory SignUpState.initial() {
    return SignUpState(
      loading: false,
      name: null,
      email: null,
      mobile: null,
      password: null,
      confirmPassword: null,
      uiMsg: null,
    );
  }

  SignUpState copyWith({
    bool loading,
    String name,
    String email,
    String mobile,
    String password,
    String confirmPassword,
    dynamic uiMsg,
  }) {
    return SignUpState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      uiMsg: uiMsg,
    );
  }
}
