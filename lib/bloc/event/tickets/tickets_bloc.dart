import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/tickets/tickets_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'tickets_event.dart';
import 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final ApiProvider apiProvider = ApiProvider();

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void tickets() {
    add(Tickets());
  }

  @override
  TicketsState get initialState => TicketsState.initial();

  @override
  Stream<TicketsState> mapEventToState(TicketsEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is Tickets) {
      yield state.copyWith(loading: true);

      await apiProvider.getTickets(state.authToken);

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var ticketsResponse = apiProvider.apiResult.response;
          if (ticketsResponse.code == apiCodeSuccess) {
            yield state.copyWith(
              ticketsList: ticketsResponse.ticketsList,
            );
          }
          yield state.copyWith(
            loading: false,
          );
        } else {
          yield state.copyWith(
            loading: false,
          );
        }
      } catch (e) {
        yield state.copyWith(
          loading: false
        );
      }
    }
  }
}
