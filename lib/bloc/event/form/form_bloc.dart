import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_event.dart';
import 'package:eventmanagement/bloc/event/form/form_state.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/field_data.dart';
import 'package:eventmanagement/model/event/form/form_action_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final ApiProvider apiProvider = ApiProvider();
  String eventDataId;
  EventData eventDataToUpload;

  FormBloc() : super(initialState);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void initSolidFields() {
    add(InitSolidFields());
  }

  void populateExistingEvent(fieldList) {
    add(PopulateExistingEvent(fieldList: fieldList));
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

  static FormState get initialState => FormState.initial();

  @override
  Stream<FormState> mapEventToState(FormEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is PopulateExistingEvent) {
      if (event.fieldList.isNotEmpty)
        yield state.copyWith(fieldList: List.of(event.fieldList));
    }

    if (event is InitSolidFields) {
      if ((state.fieldList?.length ?? 0) == 0) {
        final fieldList = List.of(state.fieldList);
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

        /*await apiProvider.createNewFormFields(
              state.authToken, eventDataToUpload,
              eventDataId: eventDataId);

          if (apiProvider.apiResult.responseCode == ok200) {
            var formResponse =
                apiProvider.apiResult.response as FormActionResponse;
            event.callback(formResponse);
            state.uploadRequired = false;
          } else {
            event.callback(apiProvider.apiResult.error);
          }*/
        uploadFormData(event);
      } else {
        event.callback('Upload not required');
      }
    }

    if (event is FormDataUploadResult) {
      yield state.copyWith(
        loading: false,
        uiMsg: event.uiMsg,
      );
    }

    if (event is DeleteField) {
      state.fieldList.removeWhere((field) => field.id == event.fieldId);
      yield state.copyWith(
        fieldList: List.of(state.fieldList),
        uploadRequired: true,
      );
    }
  }

  void uploadFormData(UploadFields event) {
    apiProvider
        .createNewFormFields(state.authToken, eventDataToUpload,
        eventDataId: eventDataId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final formActionResponse =
        networkServiceResponse.response as FormActionResponse;
        if (formActionResponse.code == apiCodeSuccess) {
          state.uploadRequired = false;
          add(FormDataUploadResult(true, uiMsg: SUCCESS_DATA_SAVED));
          event.callback(formActionResponse);
        } else {
          add(FormDataUploadResult(false,
              uiMsg: formActionResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(formActionResponse.message);
        }
      } else {
        add(FormDataUploadResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in uploadFormData--->$error');
      add(FormDataUploadResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
