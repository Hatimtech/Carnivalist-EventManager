import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/model/event/tickets/tickets_response.dart';
import 'package:meta/meta.dart';

class TicketsState {
  final String authToken;
  final List<Tickets> ticketsList;
  bool loading;

  TicketsState({
    @required this.authToken,
    @required this.ticketsList,
   this.loading
  });

  factory TicketsState.initial() {
    return TicketsState(authToken: "", ticketsList: List(), loading: false);
  }

  TicketsState copyWith(
      {bool loading, String authToken, List<Tickets> ticketsList}) {
    return TicketsState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      ticketsList: ticketsList ?? this.ticketsList,
    );
  }
}
