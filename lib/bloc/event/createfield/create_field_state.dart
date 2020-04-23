import 'package:eventmanagement/model/menu_custom.dart';

class CreateFieldState {
  bool loading;
  String customFieldName;
  List<MenuCustom> customFieldMeuList;

  CreateFieldState({
    this.loading,
    this.customFieldName,
    this.customFieldMeuList,
  });

  factory CreateFieldState.initial() {
    return CreateFieldState(
      loading: false,
      customFieldName: '',
      customFieldMeuList: List(),
    );
  }

  CreateFieldState copyWith(
      {bool loading,
      String customFieldName,
      List<MenuCustom> customFieldMeuList}) {
    return CreateFieldState(
      loading: loading ?? this.loading,
      customFieldName: customFieldName ?? this.customFieldName,
      customFieldMeuList: customFieldMeuList ?? this.customFieldMeuList,
    );
  }
}
