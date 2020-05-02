import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/model/event/tickets/ticket_action_response.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'tickets_event.dart';
import 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final ApiProvider apiProvider = ApiProvider();
  final BasicBloc basicBloc;

  TicketsBloc(this.basicBloc);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void tickets() {
    add(Tickets());
  }

  void addTicket(Ticket ticket) {
    add(AddTicket(ticket));
  }

  void updateTicket(Ticket ticket) {
    add(UpdateTicket(ticket));
  }

  void deleteTicket(String ticketId, Function callback) {
    add(DeleteTicket(ticketId, callback));
  }

  void activeInactiveTicket(String ticketId, bool active, Function callback) {
    add(ActiveInactiveTicket(ticketId, active, callback));
  }

  @override
  TicketsState get initialState => TicketsState.initial();

  @override
  Stream<TicketsState> mapEventToState(TicketsEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is AddTicket) {
      state.ticketsList.add(event.ticket);
      yield state.copyWith(ticketsList: List.of(state.ticketsList));
    }

    if (event is UpdateTicket) {
      int removeIndex = state.ticketsList
          .indexWhere((ticket) => ticket.sId == event.ticket.sId);
      state.ticketsList.removeAt(removeIndex);
      state.ticketsList.insert(removeIndex, event.ticket);
      yield state.copyWith(ticketsList: List.of(state.ticketsList));
    }

    if (event is DeleteTicket) {
      await apiProvider.deleteTicket(state.authToken, event.ticketId);

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var ticketsResponse =
          apiProvider.apiResult.response as TicketActionResponse;
          if (ticketsResponse.code == apiCodeSuccess) {
            state.ticketsList
                .removeWhere((ticket) => ticket.sId == event.ticketId);

            yield state.copyWith(
                ticketsList: List.of(state.ticketsList),
                loading: false,
                toastMsg: ticketsResponse.message);

            event.callback(ticketsResponse);
          } else {
            yield state.copyWith(toastMsg: ticketsResponse.message);
            event.callback(null);
          }
        } else {
          yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
          event.callback(null);
        }
      } catch (e) {
        yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
        event.callback(null);
      }
    }

    if (event is ActiveInactiveTicket) {
      await apiProvider.activeInactiveTickets(
          state.authToken, event.active, event.ticketId);

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var ticketsResponse =
          apiProvider.apiResult.response as TicketActionResponse;
          if (ticketsResponse.code == apiCodeSuccess) {
            final ticket = state.ticketsList
                .firstWhere((ticket) => ticket.sId == event.ticketId);
            ticket.active = event.active;

            yield state.copyWith(
                ticketsList: List.of(state.ticketsList),
                loading: false,
                toastMsg: ticketsResponse.message);

            event.callback(ticketsResponse);
          } else {
            yield state.copyWith(toastMsg: ticketsResponse.message);
            event.callback(null);
          }
        } else {
          yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
          event.callback(null);
        }
      } catch (e) {
        yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
        event.callback(null);
      }
    }

    if (event is Tickets) {
      yield state.copyWith(loading: true);

      yield state.copyWith(
        ticketsList: state.ticketsList ?? [],
        loading: false,
      );

//      await apiProvider.getTickets(state.authToken);
//      try {
//        if (apiProvider.apiResult.responseCode == ok200) {
//          var ticketsResponse = apiProvider.apiResult.response;
//          if (ticketsResponse.code == apiCodeSuccess) {
//            yield state.copyWith(
//              ticketsList: ticketsResponse.ticketsList,
//            );
//          }
//          yield state.copyWith(
//            loading: false,
//          );
//        } else {
//          yield state.copyWith(
//            loading: false,
//          );
//        }
//      } catch (e) {
//        yield state.copyWith(
//          loading: false
//        );
//      }
    }
  }
}
