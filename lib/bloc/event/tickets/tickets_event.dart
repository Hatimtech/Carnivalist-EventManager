import 'package:eventmanagement/model/event/tickets/tickets.dart';

abstract class TicketsEvent {}

class AuthTokenSave extends TicketsEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class PopulateExistingEvent extends TicketsEvent {
  final List<Ticket> ticketList;

  PopulateExistingEvent({this.ticketList});
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

class ActiveInactiveTicketResult extends TicketsEvent {
  final bool success;
  final String ticketId;
  final bool active;
  final dynamic uiMsg;

  ActiveInactiveTicketResult(this.success,
      {this.ticketId, this.active, this.uiMsg});
}

class DeleteTicket extends TicketsEvent {
  final String ticketId;
  final Function callback;

  DeleteTicket(this.ticketId, this.callback);
}

class DeleteTicketResult extends TicketsEvent {
  final bool success;
  final String ticketId;
  final dynamic uiMsg;

  DeleteTicketResult(this.success, {this.ticketId, this.uiMsg});
}

class AssignAddon extends TicketsEvent {
  final String ticketId;
  final List<String> addonIds;
  final Function callback;

  AssignAddon(this.ticketId, this.addonIds, this.callback);
}

class AssignAddonResult extends TicketsEvent {
  final bool success;
  final Ticket ticket;
  final dynamic uiMsg;

  AssignAddonResult(this.success, {this.ticket, this.uiMsg});
}
