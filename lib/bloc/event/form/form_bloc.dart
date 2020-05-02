import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_event.dart';
import 'package:eventmanagement/bloc/event/form/form_state.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/field_data.dart';
import 'package:eventmanagement/model/event/form/form_action_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final ApiProvider apiProvider = ApiProvider();
  final BasicBloc basicBloc;

  FormBloc(this.basicBloc);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void initSolidFields() {
    add(InitSolidFields());
  }

  void addField(FieldData fieldData) {
    add(AddField(fieldData));
  }

  void updateField(FieldData fieldData) {
    add(UpdateField(fieldData));
  }

  void deleteField(String fieldId) {
    add(DeleteField(fieldId));
  }

  void uploadFields(Function callback) {
    add(UploadFields(callback));
  }

  @override
  FormState get initialState => FormState.initial();

  @override
  Stream<FormState> mapEventToState(FormEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is InitSolidFields) {
      if ((state.fieldList?.length ?? 0) == 0) {
        final fieldList = state.fieldList;
        fieldList.addAll(FieldData.solidFields);
        yield state.copyWith(
          fieldList: fieldList,
          uploadRequired: true,
        );
      }
    }

    if (event is AddField) {
      state.fieldList.add(event.fieldData);
      yield state.copyWith(
        fieldList: List.of(state.fieldList),
        uploadRequired: true,
      );
    }

    if (event is UpdateField) {
      int removeIndex =
          state.fieldList.indexWhere((field) => field.id == event.fieldData.id);
      state.fieldList.removeAt(removeIndex);
      state.fieldList.insert(removeIndex, event.fieldData);
      yield state.copyWith(
        fieldList: List.of(state.fieldList),
        uploadRequired: true,
      );
    }

    if (event is UploadFields) {
      if (state.uploadRequired) {
        EventData eventDataToUpload = basicBloc.eventDataToUpload;

        final formFieldsToUpload = state.fieldList.map((field) {
          if (!(field.solid ?? false) && int.tryParse(field.id) != null)
            return FieldData(
              field.idWith_,
              id: null,
              name: field.name,
              label: field.label,
              placeholder: field.placeholder,
              required: field.required,
              type: field.type,
              solid: field.solid,
              configurations: field.configurations,
            );
          return field;
        }).toList();

        eventDataToUpload.formStructure = formFieldsToUpload;

        await apiProvider.createNewFormFields(
            state.authToken, eventDataToUpload,
            eventDataId: basicBloc.eventDataId);

        if (apiProvider.apiResult.responseCode == ok200) {
          var formResponse =
              apiProvider.apiResult.response as FormActionResponse;
          event.callback(formResponse);
          state.uploadRequired = false;
        } else {
          event.callback(apiProvider.apiResult.errorMessage);
        }
      } else {
        event.callback('Upload not required');
      }
    }

    if (event is DeleteField) {
      state.fieldList.removeWhere((field) => field.id == event.fieldId);
      yield state.copyWith(
        fieldList: List.of(state.fieldList),
        uploadRequired: true,
      );
    }
  }
}
