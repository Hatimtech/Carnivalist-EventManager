import 'package:eventmanagement/model/dashboard/payment_summary.dart';

class PaymentSummaryResponse {
  int code;
  PaymentSummary onlineTicketsSales;
  String message;

  PaymentSummaryResponse({this.code, this.onlineTicketsSales});

  PaymentSummaryResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    onlineTicketsSales = json['onlineTicketsSales'] != null
        ? PaymentSummary.fromJson(json['onlineTicketsSales'])
        : null;
    message = json['message'];
  }
}
