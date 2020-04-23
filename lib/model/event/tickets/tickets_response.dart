import 'tickets.dart';

class TicketsResponse {
  int code;
  List<Tickets> ticketsList;

  TicketsResponse({this.code, this.ticketsList});

  TicketsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['tickets'] != null) {
      ticketsList = new List<Tickets>();
      json['tickets'].forEach((v) {
        ticketsList.add(new Tickets.fromJson(v));
      });
    }
  }
}

