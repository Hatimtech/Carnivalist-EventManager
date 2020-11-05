import 'package:eventmanagement/model/dashboard/payment_summary.dart';

abstract class DashboardEvent {}

class AuthTokenSave extends DashboardEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class GetPaymentSummary extends DashboardEvent {
  GetPaymentSummary();
}

class PaymentSummaryAvailable extends DashboardEvent {
  final bool success;
  final dynamic error;
  final PaymentSummary paymentSummary;

  PaymentSummaryAvailable(this.success, {this.error, this.paymentSummary});
}
