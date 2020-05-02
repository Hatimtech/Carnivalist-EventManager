import 'package:eventmanagement/model/event/field_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';

class CreateFieldState {
  bool loading;
  String type;
  String label;
  String placeholder;
  bool required;
  List<String> configurations;
  List<MenuCustom> customFieldMeuList;

  String authToken;
  int errorCode;

  CreateFieldState({
    this.loading,
    this.type,
    this.label,
    this.placeholder,
    this.required,
    this.configurations,
    this.customFieldMeuList,
    this.authToken,
    this.errorCode,
  });

  factory CreateFieldState.initial() {
    return CreateFieldState(
      loading: false,
      type: '',
      label: '',
      placeholder: '',
      required: true,
      configurations: List(),
      customFieldMeuList: List(),
      authToken: '',
      errorCode: null,
    );
  }

  CreateFieldState copyWith({
    bool loading,
    String type,
    String label,
    String placeholder,
    bool required,
    List<String> configurations,
    List<MenuCustom> customFieldMeuList,
    String authToken,
    int errorCode = null,
  }) {
    return CreateFieldState(
      loading: loading ?? this.loading,
      type: type ?? this.type,
      label: label ?? this.label,
      placeholder: placeholder ?? this.placeholder,
      required: required ?? this.required,
      configurations: configurations ?? this.configurations,
      customFieldMeuList: customFieldMeuList ?? this.customFieldMeuList,
      authToken: authToken ?? this.authToken,
      errorCode: errorCode,
    );
  }

  factory CreateFieldState.copyWith(FieldData fieldData) {
    return CreateFieldState(
      loading: false,
      type: fieldData.type ?? '',
      label: fieldData.label ?? '',
      placeholder: fieldData.placeholder ?? '',
      required: fieldData.required ?? true,
      configurations: fieldData.configurations ?? List(),
      customFieldMeuList: List(),
      authToken: '',
      errorCode: null,
    );
  }
}
