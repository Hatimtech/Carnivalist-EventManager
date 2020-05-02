import 'package:eventmanagement/model/event/field_data.dart';
import 'package:meta/meta.dart';

class FormState {
  final String authToken;
  final List<FieldData> fieldList;
  bool loading;
  int errorCode;
  String toastMsg;
  bool uploadRequired;

  FormState({
    @required this.authToken,
    @required this.fieldList,
    this.loading,
    this.errorCode,
    this.toastMsg,
    this.uploadRequired,
  });

  factory FormState.initial() {
    return FormState(
      authToken: "",
      fieldList: List(),
      loading: false,
      errorCode: null,
      toastMsg: null,
      uploadRequired: false,
    );
  }

  FormState copyWith({
    bool loading,
    String authToken,
    List<FieldData> fieldList,
    int errorCode = null,
    String toastMsg = null,
    bool uploadRequired,
  }) {
    return FormState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      fieldList: fieldList ?? this.fieldList,
      errorCode: errorCode,
      toastMsg: toastMsg,
      uploadRequired: uploadRequired ?? this.uploadRequired,
    );
  }
}
