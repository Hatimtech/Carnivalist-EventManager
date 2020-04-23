abstract class ForgotPasswordEvent {}

class MobileInput extends ForgotPasswordEvent {
  final String mobile;
  MobileInput({this.mobile});
}

class ForgotPassword extends ForgotPasswordEvent {
  Function callback;
  ForgotPassword({this.callback});
}
