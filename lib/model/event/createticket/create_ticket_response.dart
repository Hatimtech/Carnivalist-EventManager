import 'package:eventmanagement/model/event/tickets/tickets.dart';

class CreateTicketResponse {
  int code;
  String message;
  Ticket savedTicket;
  Ticket ticket;

  CreateTicketResponse({this.code, this.message});

  CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    savedTicket = json['savedTicket'] != null
        ? Ticket.fromJson(json['savedTicket'])
        : null;
    ticket = json['ticket'] != null
        ? Ticket.fromJson(json['ticket'])
        : null;
  }
}
