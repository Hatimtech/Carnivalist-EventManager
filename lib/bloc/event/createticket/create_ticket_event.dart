abstract class CreateTicketEvent {}

class AuthTokenSave extends CreateTicketEvent {
  final String authToken;
  AuthTokenSave({this.authToken});
}

class TicketNameInput extends CreateTicketEvent {
  final String ticketName;
  TicketNameInput({this.ticketName});
}

class TicketCurrencyInput extends CreateTicketEvent {
  final String ticketCurrency, ticketCurrencyUI;

  TicketCurrencyInput({this.ticketCurrency, this.ticketCurrencyUI});
}

class TicketPriceInput extends CreateTicketEvent {
  final String ticketPrice;
  TicketPriceInput({this.ticketPrice});
}

class SalesEndDateInput extends CreateTicketEvent {
  final DateTime salesEndDate;
  SalesEndDateInput({this.salesEndDate});
}

class TotalAvailableInput extends CreateTicketEvent {
  final String totalAvailable;
  TotalAvailableInput({this.totalAvailable});
}

class MinBookingInput extends CreateTicketEvent {
  final String minBooking;
  MinBookingInput({this.minBooking});
}

class MaxBookingInput extends CreateTicketEvent {
  final String maxBooking;
  MaxBookingInput({this.maxBooking});
}

class DescriptionInput extends CreateTicketEvent {
  final String description;
  DescriptionInput({this.description});
}

class CreateUpdateTicket extends CreateTicketEvent {
  Function callback;

  CreateUpdateTicket({this.callback});
}

class CreateUpdateTicketResult extends CreateTicketEvent {
  final bool success;
  final dynamic uiMsg;

  CreateUpdateTicketResult(this.success, {this.uiMsg});
}
