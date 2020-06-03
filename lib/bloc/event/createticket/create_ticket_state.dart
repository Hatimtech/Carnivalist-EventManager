import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/utils/vars.dart';

class CreateTicketState {
  final String authToken,
      ticketName,
      ticketCurrency,
      ticketCurrencyUI,
      ticketPrice,
      totalAvailable,
      minBooking,
      maxBooking,
      description;
  DateTime salesEndDate;
  bool loading;
  dynamic uiMsg;

  CreateTicketState({
    this.authToken,
    this.ticketName,
    this.ticketCurrency,
    this.ticketCurrencyUI,
    this.ticketPrice,
    this.salesEndDate,
    this.totalAvailable,
    this.minBooking,
    this.maxBooking,
    this.description,
    bool loading,
    this.uiMsg,
  });

  factory CreateTicketState.initial() {
    return CreateTicketState(
      authToken: '',
      ticketName: '',
      ticketCurrency: '',
      ticketCurrencyUI: '',
      ticketPrice: '',
      salesEndDate: null,
      totalAvailable: '',
      minBooking: '',
      maxBooking: '',
      description: '',
      uiMsg: null,
    );
  }

  /*factory CreateTicketState.initial() {
    return CreateTicketState(
      authToken: '',
      ticketName: 'Mobile Ticket',
      ticketCurrency: 'USD',
      ticketCurrencyUI: 'USD - United States dollar',
      ticketPrice: '19.99',
      salesEndDate: DateTime(2020, 5, 30),
      totalAvailable: '199',
      minBooking: '1',
      maxBooking: '2',
      description: 'My Mobile Ticket Desc',
    );
  }*/

  factory CreateTicketState.copyWith(Ticket ticket, String currencyUI) {
    return CreateTicketState(
      authToken: '',
      ticketName: ticket.name ?? '',
      ticketCurrency: ticket.currency ?? '',
      ticketCurrencyUI: currencyUI ?? '',
      ticketPrice: ticket.price?.toString() ?? '',
      salesEndDate: isValid(ticket.sellingEndDate) ? DateTime.parse(
          ticket.sellingEndDate).toLocal() : null,
      totalAvailable: ticket.quantity?.toString() ?? '',
      minBooking: ticket.minOrderQuantity?.toString() ?? '',
      maxBooking: ticket.maxOrderQuantity?.toString() ?? '',
      description: ticket.description?.toString() ?? '',
      uiMsg: null,
    );
  }

  static DateTime sellingEndDate(String endDate) {
    if (isValid(endDate)) {
      return DateTime.parse(endDate);
    }
  }

  CreateTicketState copyWith({
    bool loading,
    String authToken,
    String ticketName,
    String ticketCurrency,
    String ticketCurrencyUI,
    String ticketPrice,
    DateTime salesEndDate,
    String totalAvailable,
    String minBooking,
    String maxBooking,
    String description,
    dynamic uiMsg,
  }) {
    return CreateTicketState(
      authToken: authToken ?? this.authToken,
      ticketName: ticketName ?? this.ticketName,
      ticketCurrency: ticketCurrency ?? this.ticketCurrency,
      ticketCurrencyUI: ticketCurrencyUI ?? this.ticketCurrencyUI,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      salesEndDate: salesEndDate ?? this.salesEndDate,
      totalAvailable: totalAvailable ?? this.totalAvailable,
      minBooking: minBooking ?? this.minBooking,
      maxBooking: maxBooking ?? this.maxBooking,
      description: description ?? this.description,
      uiMsg: uiMsg,
    );
  }
}
