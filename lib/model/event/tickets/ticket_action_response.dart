class TicketActionResponse {
  int code;
  String message;

  TicketActionResponse({this.code, this.message});

  TicketActionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
