abstract class SignUpEvent {}

class NameInput extends SignUpEvent {
  final String name;
  NameInput({this.name});
}

class MobileInput extends SignUpEvent {
  final String mobile;
  MobileInput({this.mobile});
}

class EmailInput extends SignUpEvent {
  final String email;
  EmailInput({this.email});
}

class PasswordInput extends SignUpEvent {
  final String password;
  PasswordInput({this.password});
}

class ConfirmPasswordInput extends SignUpEvent {
  final String confirmPasswordInput;
  ConfirmPasswordInput({this.confirmPasswordInput});
}

class SignUp extends SignUpEvent {
  Function callback;
  SignUp({this.callback});
}
