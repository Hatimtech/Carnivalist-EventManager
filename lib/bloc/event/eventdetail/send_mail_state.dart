class SendMailState {
  final String authToken;
  String subject;
  String fromName;
  String replyTo;
  String message;
  bool loading;
  dynamic uiMsg;

  SendMailState({
    this.authToken,
    this.subject,
    this.fromName,
    this.replyTo,
    this.message,
    this.loading,
    this.uiMsg,
  });

  factory SendMailState.initial({
    String subject,
    String fromName,
    String replyTo,
  }) {
    return SendMailState(
      authToken: "",
      subject: subject ?? '',
      fromName: fromName ?? '',
      replyTo: replyTo ?? '',
      message: '',
      loading: false,
      uiMsg: null,
    );
  }

  SendMailState copyWith({
    bool loading,
    String authToken,
    String subject,
    String fromName,
    String replyTo,
    String message,
    dynamic uiMsg,
  }) {
    return SendMailState(
      authToken: authToken ?? this.authToken,
      subject: subject ?? this.subject,
      fromName: subject ?? this.fromName,
      replyTo: subject ?? this.replyTo,
      message: message ?? this.message,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
    );
  }
}
