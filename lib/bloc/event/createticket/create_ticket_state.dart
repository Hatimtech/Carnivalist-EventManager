import 'package:meta/meta.dart';

class CreateTicketState {
  final String authToken,
      ticketName,
      ticketPrice,
      salesEndDate,
      totalAvailable,
      minBooking,
      maxBooking,
      description;
  bool loading;

  CreateTicketState({
    this.authToken,
    this.ticketName,
    this.ticketPrice,
    this.salesEndDate,
    this.totalAvailable,
    this.minBooking,
    this.maxBooking,
    this.description,
    bool loading,
  });

  factory CreateTicketState.initial() {
    return CreateTicketState(
        authToken: '',
        ticketName: '',
        ticketPrice: '',
        salesEndDate: '',
        totalAvailable: '',
        minBooking: '',
        maxBooking: '',
        description: '');
  }

  CreateTicketState copyWith({
    bool loading,
    String authToken,
    String ticketName,
    String ticketPrice,
    String salesEndDate,
    String totalAvailable,
    String minBooking,
    String maxBooking,
    String description,
  }) {
    return CreateTicketState(
        authToken: authToken ?? this.authToken,
        ticketName: ticketName ?? this.ticketName,
        ticketPrice: ticketPrice ?? this.ticketPrice,
        salesEndDate: salesEndDate ?? this.salesEndDate,
        totalAvailable: totalAvailable ?? this.totalAvailable,
        minBooking: minBooking ?? this.minBooking,
        maxBooking: maxBooking ?? this.maxBooking,
        description: description ?? this.description);
  }
}
