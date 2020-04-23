import 'package:eventmanagement/model/menu_custom.dart';

class SettingState {
  bool loading;
  String paymentTypeName;
  List<MenuCustom> paymentTypeList;

  SettingState({
    this.loading,
    this.paymentTypeName,
    this.paymentTypeList,
  });

  factory SettingState.initial() {
    return SettingState(
      loading: false,
      paymentTypeName: '',
      paymentTypeList: List(),
    );
  }

  SettingState copyWith(
      {bool loading,
      String paymentTypeName,
      List<MenuCustom> paymentTypeList}) {
    return SettingState(
      loading: loading ?? this.loading,
      paymentTypeName: paymentTypeName ?? this.paymentTypeName,
      paymentTypeList: paymentTypeList ?? this.paymentTypeList,
    );
  }
}
