import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'create_ticket_event.dart';
import 'create_ticket_state.dart';

class CreateTicketBloc extends Bloc<CreateTicketEvent, CreateTicketState> {
  final ApiProvider apiProvider = ApiProvider();

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void ticketNameInput(ticketName) {
    add(TicketNameInput(ticketName: ticketName));
  }

  void ticketPriceInput(ticketPrice) {
    add(TicketPriceInput(ticketPrice: ticketPrice));
  }

  void salesEndDateInput(salesEndDate) {
    add(SalesEndDateInput(salesEndDate: salesEndDate));
  }

  void totalAvailableInput(totalAvailable) {
    add(TotalAvailableInput(totalAvailable: totalAvailable));
  }

  void minBookingInput(minBooking) {
    add(MinBookingInput(minBooking: minBooking));
  }

  void maxBookingInput(maxBooking) {
    add(MaxBookingInput(maxBooking: maxBooking));
  }

  void descriptionInput(description) {
    add(DescriptionInput(description: description));
  }

  void createTicket(callback) {
    add(CreateTicket(callback: callback));
  }

  @override
  CreateTicketState get initialState => CreateTicketState.initial();

  @override
  Stream<CreateTicketState> mapEventToState(CreateTicketEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is TicketNameInput) {
      yield state.copyWith(ticketName: event.ticketName);
    }

    if (event is TicketPriceInput) {
      yield state.copyWith(ticketPrice: event.ticketPrice);
    }

    if (event is SalesEndDateInput) {
      yield state.copyWith(salesEndDate: event.salesEndDate);
    }

    if (event is TotalAvailableInput) {
      yield state.copyWith(totalAvailable: event.totalAvailable);
    }

    if (event is MinBookingInput) {
      yield state.copyWith(minBooking: event.minBooking);
    }

    if (event is MaxBookingInput) {
      yield state.copyWith(maxBooking: event.maxBooking);
    }

    if (event is DescriptionInput) {
      yield state.copyWith(description: event.description);
    }

    if (event is CreateTicket) {
      yield state.copyWith(loading: true);

      Map<String, dynamic> param = Map();
      param.putIfAbsent('name', () => state.ticketName);
      param.putIfAbsent('price', () => int.parse(state.ticketPrice));
      param.putIfAbsent('sellingEndDate', () => state.salesEndDate);
      param.putIfAbsent('quantity', () => state.totalAvailable);
      param.putIfAbsent('minOrderQuantity', () => state.minBooking);
      param.putIfAbsent('maxOrderQuantity', () => state.maxBooking);
      param.putIfAbsent('description', () => state.description);
      param.putIfAbsent('currency', () => 'USD');

      await apiProvider.getCreateTickets(state.authToken, param);

      if (apiProvider.apiResult.responseCode == ok200) {
        var createTicketResponse = apiProvider.apiResult.response;
        event.callback(createTicketResponse);
      }
    }
  }
}
