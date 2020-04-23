import 'package:meta/meta.dart';

class ForgotPasswordState  {
  final String mobile;
  bool loading;

  ForgotPasswordState({
    @required this.mobile,
    bool loading,
  });

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(
      mobile: "",
    );
  }

  ForgotPasswordState copyWith(
      {bool loading,
      String mobile,}) {

    return ForgotPasswordState(
      mobile: mobile ?? this.mobile
    );
  }
}
