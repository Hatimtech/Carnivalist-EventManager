import 'package:eventmanagement/model/event/tickets/tickets.dart';

abstract class TicketsEvent {}

class AuthTokenSave extends TicketsEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class Tickets extends TicketsEvent {}

class AddTicket extends TicketsEvent {
  final Ticket ticket;

  AddTicket(this.ticket);
}

class UpdateTicket extends TicketsEvent {
  final Ticket ticket;

  UpdateTicket(this.ticket);
}

class ActiveInactiveTicket extends TicketsEvent {
  final String ticketId;
  final bool active;
  final Function callback;

  ActiveInactiveTicket(this.ticketId, this.active, this.callback);
}

class DeleteTicket extends TicketsEvent {
  final String ticketId;
  final Function callback;

  DeleteTicket(this.ticketId, this.callback);
}
