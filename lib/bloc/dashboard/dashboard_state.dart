import 'package:eventmanagement/model/dashboard/payment_summary.dart';

class DashboardState {
  final String authToken;
  final PaymentSummary paymentSummary;
  bool loading;
  dynamic uiMsg;

  DashboardState({
    this.authToken,
    this.paymentSummary,
    this.loading,
    this.uiMsg,
  });

  factory DashboardState.initial() {
    return DashboardState(
      authToken: "",
      paymentSummary: PaymentSummary(quantity: 0, amount: 0),
      loading: false,
      uiMsg: null,
    );
  }

  DashboardState copyWith({
    bool loading,
    String authToken,
    PaymentSummary paymentSummary,
    dynamic uiMsg,
  }) {
    return DashboardState(
      authToken: authToken ?? this.authToken,
      paymentSummary: paymentSummary ?? this.paymentSummary,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
    );
  }
}
