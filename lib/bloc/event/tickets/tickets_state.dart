import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:meta/meta.dart';

class TicketsState {
  final String authToken;
  final List<Ticket> ticketsList;
  bool loading;
  int errorCode;
  String toastMsg;

  TicketsState({
    @required this.authToken,
    @required this.ticketsList,
    this.loading,
    this.errorCode,
    this.toastMsg,
  });

  factory TicketsState.initial() {
    return TicketsState(
      authToken: "",
      ticketsList: List(),
      loading: false,
      errorCode: null,
      toastMsg: null,
    );
  }

  TicketsState copyWith({
    bool loading,
    String authToken,
    List<Ticket> ticketsList,
    int errorCode = null,
    String toastMsg = null,
  }) {
    return TicketsState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      ticketsList: ticketsList ?? this.ticketsList,
      errorCode: errorCode,
      toastMsg: toastMsg,
    );
  }
}
