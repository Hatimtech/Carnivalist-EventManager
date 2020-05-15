abstract class SendMailEvent {}

class AuthTokenSave extends SendMailEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class SubjectInput extends SendMailEvent {
  final String input;

  SubjectInput(this.input);
}

class FromNameInput extends SendMailEvent {
  final String input;

  FromNameInput(this.input);
}

class ReplyToInput extends SendMailEvent {
  final String input;

  ReplyToInput(this.input);
}

class MessageInput extends SendMailEvent {
  final String input;

  MessageInput(this.input);
}

class SendMail extends SendMailEvent {
  final Function callback;

  SendMail({this.callback});
}

class SendMailEventResult extends SendMailEvent {
  final bool success;
  final dynamic uiMsg;

  SendMailEventResult(this.success, {this.uiMsg});
}
