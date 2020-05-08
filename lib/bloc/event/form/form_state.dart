import 'package:eventmanagement/model/event/field_data.dart';
import 'package:meta/meta.dart';

class FormState {
  final String authToken;
  final List<FieldData> fieldList;
  bool loading;
  dynamic uiMsg;
  bool uploadRequired;

  FormState({
    @required this.authToken,
    @required this.fieldList,
    this.loading,
    this.uiMsg,
    this.uploadRequired,
  });

  factory FormState.initial() {
    return FormState(
      authToken: "",
      fieldList: List(),
      loading: false,
      uiMsg: null,
      uploadRequired: false,
    );
  }

  FormState copyWith({
    bool loading,
    String authToken,
    List<FieldData> fieldList,
    dynamic uiMsg,
    bool uploadRequired,
  }) {
    return FormState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      fieldList: fieldList ?? this.fieldList,
      uiMsg: uiMsg,
      uploadRequired: uploadRequired ?? this.uploadRequired,
    );
  }
}
