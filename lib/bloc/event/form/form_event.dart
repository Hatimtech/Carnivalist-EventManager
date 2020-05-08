import 'package:eventmanagement/model/event/field_data.dart';

abstract class FormEvent {}

class AuthTokenSave extends FormEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class InitSolidFields extends FormEvent {
  InitSolidFields();
}

class PopulateExistingEvent extends FormEvent {
  final List<FieldData> fieldList;

  PopulateExistingEvent({this.fieldList});
}

class AddField extends FormEvent {
  final FieldData fieldData;

  AddField(this.fieldData);
}

class UpdateField extends FormEvent {
  final FieldData fieldData;

  UpdateField(this.fieldData);
}

class DeleteField extends FormEvent {
  final String fieldId;

  DeleteField(this.fieldId);
}

class UploadFields extends FormEvent {
  final Function callback;

  UploadFields(this.callback);
}

class FormDataUploadResult extends FormEvent {
  final bool success;
  final dynamic uiMsg;

  FormDataUploadResult(this.success, {this.uiMsg});
}
