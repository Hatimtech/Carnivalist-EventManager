abstract class TicketsEvent {}

class AuthTokenSave extends TicketsEvent {
  final String authToken;
  AuthTokenSave({this.authToken});
}

class Tickets extends TicketsEvent {
}
