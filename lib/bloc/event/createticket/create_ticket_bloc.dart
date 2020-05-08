import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_bloc.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'create_ticket_event.dart';
import 'create_ticket_state.dart';

class CreateTicketBloc extends Bloc<CreateTicketEvent, CreateTicketState> {
  final ApiProvider apiProvider = ApiProvider();
  final TicketsBloc ticketBloc;
  final String eventDataId;
  final String ticketId;
  Map<String, String> mapCurrency = {
    'AED': 'AED - United Arab Emirates',
    'ALL': 'ALL - Albanian lek',
    'AMD': 'AMD - Armenian dram',
    'ARS': 'ARS - Argentine peso',
    'AUD': 'AUD - Australian dollar',
    'AWG': 'AWG - Aruban florin',
    'BBD': 'BBD - Barbadian dollar',
    'BDT': 'BDT - Bangladeshi taka',
    'BMD': 'BMD - Bermudian dollar',
    'BND': 'BND - Brunei dollar',
    'BOB': 'BOB - Bolivian boliviano',
    'BSD': 'BSD - Bahamian dollar',
    'BWP': 'BWP - Botswana pula',
    'BZD': 'BZD - Belize dollar',
    'CAD': 'CAD - Canadian dollar',
    'CHF': 'CHF - Swiss franc',
    'CNY': 'CNY - Chinese Yuan Renminbi',
    'COP': 'COP - Colombian peso',
    'CRC': 'CRC - Costa Rican colon',
    'CUP': 'CUP - Cuban peso',
    'CZK': 'CZK - Czech koruna',
    'DKK': 'DKK - Danish krone',
    'DOP': 'DOP - Dominican peso',
    'DZD': 'DZD - Algerian dinar',
    'EGP': 'EGP - Egyptian pound',
    'ETB': 'ETB - Ethiopian birr',
    'EUR': 'EUR - European euro',
    'FJD': 'FJD - Fijian dollar',
    'GBP': 'GBP - Pound sterling',
    'GIP': 'GIP - Gibraltar pound',
    'GMD': 'GMD - Gambian dalasi',
    'GTQ': 'GTQ - Guatemalan quetzal',
    'GYD': 'GYD - Guyanese dollar',
    'HKD': 'HKD - Hong Kong dollar',
    'HNL': 'HNL - Honduran lempira',
    'HRK': 'HRK - Croatian kuna',
    'HTG': 'HTG - Haitian gourde',
    'HUF': 'HUF - Hungarian forint',
    'IDR': 'IDR - Indonesian rupiah',
    'ILS': 'ILS - Israeli new shekel',
    'INR': 'INR - Indian rupee',
    'JMD': 'JMD - Jamaican dollar',
    'KES': 'KES - Kenyan shilling',
    'KGS': 'KGS - Kyrgyzstani som',
    'KHR': 'KHR - Cambodian riel',
    'KYD': 'KYD - Cayman Islands dollar',
    'KZT': 'KZT - Kazakhstani tenge',
    'LAK': 'LAK - Lao kip',
    'LBP': 'LBP - Lebanese pound',
    'LKR': 'LKR - Sri Lankan rupee',
    'LRD': 'LRD - Liberian dollar',
    'LSL': 'LSL - Lesotho loti',
    'MAD': 'MAD - Moroccan dirham',
    'MDL': 'MDL - Moldovan leu',
    'MKD': 'MKD - Macedonian denar',
    'MMK': 'MMK - Myanmar kyat',
    'MNT': 'MNT - Mongolian tugrik',
    'MOP': 'MOP - Macanese pataca',
    'MUR': 'MUR - Mauritian rupee',
    'MVR': 'MVR - Maldivian rufiyaa',
    'MWK': 'MWK - Malawian kwacha',
    'MXN': 'MXN - Mexican peso',
    'MYR': 'MYR - Malaysian ringgit',
    'NAD': 'NAD - Namibian dollar',
    'NGN': 'NGN - Nigerian naira',
    'NIO': 'NIO - Nicaraguan cordoba',
    'NOK': 'NOK - Norwegian krone',
    'NPR': 'NPR - Nepalese rupee',
    'NZD': 'NZD - New Zealand dollar',
    'PEN': 'PEN - Peruvian sol',
    'PGK': 'PGK - Papua New Guinean kina',
    'PHP': 'PHP - Philippine peso',
    'PKR': 'PKR - Pakistani rupee',
    'QAR': 'QAR - Qatari riyal',
    'RUB': 'RUB - Russian ruble',
    'SAR': 'SAR - Saudi Arabian riyal',
    'SCR': 'SCR - Seychellois rupee',
    'SEK': 'SEK - Swedish krona',
    'SGD': 'SGD - Singapore dollar',
    'SLL': 'SLL - Sierra Leonean leone',
    'SOS': 'SOS - Somali shilling',
    'SSP': 'SSP - South Sudanese pound',
    'SVC': 'SVC - Salvadoran colón',
    'SZL': 'SZL - Swazi lilangeni',
    'THB': 'THB - Thai baht',
    'TTD': 'TTD - Trinidad and Tobago dollar',
    'TZS': 'TZS - Tanzanian shilling',
    'USD': 'USD - United States dollar',
    'UYU': 'UYU - Uruguayan peso',
    'UZS': 'UZS - Uzbekistani som',
    'YER': 'YER - Yemeni rial',
    'ZAR': 'ZAR - South African rand',
  };

  CreateTicketBloc(this.eventDataId, this.ticketBloc, {this.ticketId});

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void ticketNameInput(ticketName) {
    add(TicketNameInput(ticketName: ticketName));
  }

  void ticketCurrencyInput(ticketCurrency, ticketCurrencyUI) {
    add(TicketCurrencyInput(
        ticketCurrency: ticketCurrency, ticketCurrencyUI: ticketCurrencyUI));
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
  CreateTicketState get initialState {
    if (ticketId == null)
      return CreateTicketState.initial();
    else {
      final ticket = ticketBloc.state.ticketsList
          .firstWhere((ticket) => ticket.sId == ticketId);
      print('Existing Ticket toString--->${ticket.toString()}');
      return CreateTicketState.copyWith(ticket, mapCurrency[ticket.currency]);
    }
  }

  @override
  Stream<CreateTicketState> mapEventToState(CreateTicketEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is TicketNameInput) {
      yield state.copyWith(ticketName: event.ticketName);
    }

    if (event is TicketCurrencyInput) {
      yield state.copyWith(
          ticketCurrency: event.ticketCurrency,
          ticketCurrencyUI: event.ticketCurrencyUI);
    }

    if (event is TicketPriceInput) {
      yield state.copyWith(ticketPrice: event.ticketPrice);
    }

    if (event is SalesEndDateInput) {
      final saleEndDate = event.salesEndDate;
      yield state.copyWith(
          salesEndDate:
          DateTime(saleEndDate.year, saleEndDate.month, saleEndDate.day));
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
      try {
        int errorCode = validateCreateTicketData();
        if (errorCode > 0) {
          yield state.copyWith(errorCode: errorCode);
          event.callback(null);
          return;
        }
        yield state.copyWith(loading: true);

        Map<String, dynamic> param = Map();
        param.putIfAbsent('name', () => state.ticketName);
        param.putIfAbsent(
            'price',
                () =>
            state.ticketPrice != null
                ? double.parse(state.ticketPrice)
                : 0);
        param.putIfAbsent(
            'sellingEndDate', () => state.salesEndDate.toIso8601String());
        param.putIfAbsent('quantity', () => int.parse(state.totalAvailable));
        param.putIfAbsent(
            'minOrderQuantity', () => int.parse(state.minBooking));
        param.putIfAbsent(
            'maxOrderQuantity', () => int.parse(state.maxBooking));
        param.putIfAbsent('description', () => state.description);
        param.putIfAbsent('currency', () => state.ticketCurrency);
        param.putIfAbsent('event', () => eventDataId);

        await apiProvider.getCreateTickets(state.authToken, param,
            ticketId: ticketId);

        if (apiProvider.apiResult.responseCode == ok200) {
          var createTicketResponse =
          apiProvider.apiResult.response as CreateTicketResponse;

          if (ticketId != null) {
            if (createTicketResponse.ticket != null)
              ticketBloc.updateTicket(createTicketResponse.ticket);
          } else {
            if (createTicketResponse.savedTicket != null)
              ticketBloc.addTicket(createTicketResponse.savedTicket);
          }

          event.callback(createTicketResponse);
        } else {
          event.callback(apiProvider.apiResult.error);
        }
      } catch (error) {
        print('Exception Occured--->$error');
        yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
        event.callback(null);
      }
    }
  }

  int validateCreateTicketData() {
    if (!isValid(state.ticketName)) return ERR_TICKET_NAME;
    if (!isValid(state.ticketCurrency)) return ERR_TICKET_CURRENCY;
    if (state.salesEndDate == null) return ERR_TICKET_SALE_END;
    if (!isValid(state.totalAvailable)) return ERR_TICKET_AVAILABLE_QUA;
    if (!isValid(state.minBooking)) return ERR_TICKET_MIN_QUA;
    if (!isValid(state.maxBooking)) return ERR_TICKET_MAX_QUA;
    if (int.parse(state.minBooking) > int.parse(state.maxBooking))
      return ERR_TICKET_MIN_QUA_LESS;
    if (int.parse(state.minBooking) > int.parse(state.totalAvailable) ||
        int.parse(state.maxBooking) > int.parse(state.totalAvailable))
      return ERR_TICKET_MIN_MAX_BET;

    return 0;
  }
}
