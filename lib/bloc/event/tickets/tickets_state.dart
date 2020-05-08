import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:meta/meta.dart';

class TicketsState {
  final String authToken;
  final List<Ticket> ticketsList;
  bool loading;
  dynamic uiMsg;

  TicketsState({
    @required this.authToken,
    @required this.ticketsList,
    this.loading,
    this.uiMsg,
  });

  factory TicketsState.initial() {
    return TicketsState(
      authToken: "",
      ticketsList: List(),
      loading: false,
      uiMsg: null,
    );
  }

  TicketsState copyWith({
    bool loading,
    String authToken,
    List<Ticket> ticketsList,
    String uiMsg,
  }) {
    return TicketsState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      ticketsList: ticketsList ?? this.ticketsList,
      uiMsg: uiMsg,
    );
  }
}
