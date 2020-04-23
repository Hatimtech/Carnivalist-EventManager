abstract class CreateTicketEvent {}

class AuthTokenSave extends CreateTicketEvent {
  final String authToken;
  AuthTokenSave({this.authToken});
}

class TicketNameInput extends CreateTicketEvent {
  final String ticketName;
  TicketNameInput({this.ticketName});
}

class TicketPriceInput extends CreateTicketEvent {
  final String ticketPrice;
  TicketPriceInput({this.ticketPrice});
}

class SalesEndDateInput extends CreateTicketEvent {
  final String salesEndDate;
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

class CreateTicket extends CreateTicketEvent {
  Function callback;
  CreateTicket({this.callback});
}
