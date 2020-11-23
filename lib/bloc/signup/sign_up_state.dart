import 'package:meta/meta.dart';

class SignUpState {
  final String name;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final String domain;
  bool loading;
  dynamic uiMsg;

  SignUpState({
    @required this.name,
    @required this.lastName,
    @required this.email,
    @required this.mobile,
    @required this.password,
    @required this.confirmPassword,
    this.domain,
    this.loading,
    this.uiMsg,
  });

  factory SignUpState.initial() {
    return SignUpState(
      loading: false,
      name: null,
      lastName: null,
      email: null,
      mobile: null,
      password: null,
      confirmPassword: null,
      domain: null,
      uiMsg: null,
    );
  }

  SignUpState copyWith({
    bool loading,
    String name,
    String lastName,
    String email,
    String mobile,
    String password,
    String confirmPassword,
    String domain,
    dynamic uiMsg,
  }) {
    return SignUpState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      domain: domain ?? this.domain,
      uiMsg: uiMsg,
    );
  }
}
