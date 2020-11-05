import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/dashboard/dashboard_event.dart';
import 'package:eventmanagement/bloc/dashboard/dashboard_state.dart';
import 'package:eventmanagement/model/dashboard/payment_summary_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiProvider apiProvider = ApiProvider();

  DashboardBloc() : super(initialState);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void getPaymentSummary() {
    add(GetPaymentSummary());
  }

  static DashboardState get initialState => DashboardState.initial();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is GetPaymentSummary) {
      getPaymentSummaryApi(event);
    }

    if (event is PaymentSummaryAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        paymentSummary: event.paymentSummary,
      );
    }
  }

  void getPaymentSummaryApi(GetPaymentSummary event) {
    apiProvider
        .getPaymentSummary(state.authToken)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var paymentSummaryResponse =
            networkServiceResponse.response as PaymentSummaryResponse;
        if (paymentSummaryResponse.code == apiCodeSuccess)
          add(PaymentSummaryAvailable(true,
              paymentSummary: paymentSummaryResponse.onlineTicketsSales));
        else
          add(PaymentSummaryAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      } else {
        add(PaymentSummaryAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
    }).catchError((error, stack) {
      print('Error in getPaymentSummaryApi--->$error\n$stack');
      add(PaymentSummaryAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
    });
  }
}
