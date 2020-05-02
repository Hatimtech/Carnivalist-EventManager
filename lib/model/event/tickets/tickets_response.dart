import 'tickets.dart';

class TicketsResponse {
  int code;
  List<Ticket> ticketsList;

  TicketsResponse({this.code, this.ticketsList});

  TicketsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['tickets'] != null) {
      ticketsList = new List<Ticket>();
      json['tickets'].forEach((v) {
        ticketsList.add(new Ticket.fromJson(v));
      });
    }
  }
}

