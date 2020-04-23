import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  void paymentType() {
    add(PaymentType());
  }

  void selectPaymentTypeName(paymentTypeName) {
    add(SelectPaymentTypeName(paymentTypeName: paymentTypeName));
  }

  @override
  SettingState get initialState => SettingState.initial();

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is PaymentType) {
      yield state.copyWith(paymentTypeList: getPaymentType());
    }


    if (event is SelectPaymentTypeName) {
      yield state.copyWith(paymentTypeName: event.paymentTypeName);

      int id = state.paymentTypeList
          .indexWhere((item) => item.name == state.paymentTypeName);

      state.paymentTypeList.forEach((element) => element.isSelected = false);
      state.paymentTypeList[id].isSelected = true;

      yield state.copyWith(paymentTypeList: state.paymentTypeList);
    }
  }
}
