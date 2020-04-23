class CreateTicketResponse {
  int code;
  String message;

  CreateTicketResponse({this.code, this.message});

  CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
