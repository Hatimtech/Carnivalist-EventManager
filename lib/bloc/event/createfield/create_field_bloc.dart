import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_bloc.dart';
import 'package:eventmanagement/model/event/field_data.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'create_field_event.dart';
import 'create_field_state.dart';

class CreateFieldBloc extends Bloc<CreateFieldEvent, CreateFieldState> {
  final ApiProvider apiProvider = ApiProvider();
  final FormBloc formBloc;
  final String fieldId;

  CreateFieldBloc(this.formBloc, this.fieldId);

  void customFieldMenu() {
    add(CustomFieldMenu());
  }

  void selectCustomFieldName(customFieldName) {
    add(SelectCustomFieldName(customFieldName: customFieldName));
  }

  void createFormField(callback) {
    add(CreateFormField(callback: callback));
  }

  void fieldLabelInput(label) {
    add(FieldLabelInput(label: label));
  }

  void fieldPlaceholderInput(placeholder) {
    add(FieldPlaceholderInput(placeholder: placeholder));
  }

  void mandatoryInput(mandatory) {
    add(FieldMandatoryInput(mandatory: mandatory));
  }

  void addDropdownConfiguration(configuration) {
    add(AddDropdownConfiguration(configuration: configuration));
  }

  void removeDropdownConfiguration(configuration) {
    add(RemoveDropdownConfiguration(configuration: configuration));
  }

  @override
  CreateFieldState get initialState {
    if (fieldId != null) {
      return CreateFieldState.copyWith(
          formBloc.state.fieldList.firstWhere((field) => field.id == fieldId));
    } else {
      CreateFieldState createFieldState = CreateFieldState.initial();
      createFieldState.type = getCustomField()[0].value;
      return createFieldState;
    }
  }

  @override
  Stream<CreateFieldState> mapEventToState(CreateFieldEvent event) async* {
    if (event is CustomFieldMenu) {
      yield state.copyWith(customFieldMeuList: getCustomField());
    }

    if (event is FieldLabelInput) {
      yield state.copyWith(label: event.label);
    }

    if (event is FieldPlaceholderInput) {
      yield state.copyWith(placeholder: event.placeholder);
    }

    if (event is FieldMandatoryInput) {
      yield state.copyWith(required: event.mandatory);
    }

    if (event is AddDropdownConfiguration) {
      if (!state.configurations.contains(event.configuration)) {
        state.configurations.add(event.configuration);
        yield state.copyWith(configurations: List.of(state.configurations));
      } else {
        yield state.copyWith(errorCode: ERR_DUPLICATE_LIST_ITEM);
      }
    }

    if (event is RemoveDropdownConfiguration) {
      state.configurations.remove(event.configuration);
      yield state.copyWith(configurations: List.of(state.configurations));
    }

    if (event is SelectCustomFieldName) {
      yield state.copyWith(type: event.customFieldName.value);

      int id = state.customFieldMeuList
          .indexWhere((item) => item.value == state.type);

      state.customFieldMeuList.forEach((element) => element.isSelected = false);
      state.customFieldMeuList[id].isSelected = true;

      yield state.copyWith(
          customFieldMeuList: List.of(state.customFieldMeuList));
    }

    if (event is CreateFormField) {
      int errorCode = validateFormFieldData();
      if (errorCode > 0) {
        yield state.copyWith(errorCode: errorCode);
        event.callback(false);
        return;
      }

      final newFieldData = FieldData(
        null,
        id: fieldId ?? DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        label: state.label,
        placeholder: state.placeholder,
        required: state.required,
        type: state.type,
        configurations: state.configurations,
      );

      if (fieldId != null) {
        formBloc.updateField(newFieldData);
      } else {
        formBloc.addField(newFieldData);
      }

      event.callback(true);
    }
  }

  int validateFormFieldData() {
    if (!isValid(state.label)) return ERR_FIELD_LABEL;
    if (!isValid(state.placeholder)) return ERR_FIELD_PLACEHOLDER;

    final menuList = state.customFieldMeuList;
    if (state.type == menuList[2].value || state.type == menuList[3].value) {
      if (state.configurations.length == 0) return ERR_NO_LIST_ITEM;
    }

    return 0;
  }
}
