import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'create_field_event.dart';
import 'create_field_state.dart';

class CreateFieldBloc extends Bloc<CreateFieldEvent, CreateFieldState> {
  void customFieldMenu() {
    add(CustomFieldMenu());
  }

  void selectCustomFieldName(customFieldName) {
    add(SelectCustomFieldName(customFieldName: customFieldName));
  }

  @override
  CreateFieldState get initialState => CreateFieldState.initial();

  @override
  Stream<CreateFieldState> mapEventToState(CreateFieldEvent event) async* {
    if (event is CustomFieldMenu) {
      yield state.copyWith(customFieldMeuList: getCustomField());
    }

    if (event is SelectCustomFieldName) {
      yield state.copyWith(customFieldName: event.customFieldName);

      int id = state.customFieldMeuList
          .indexWhere((item) => item.name == state.customFieldName);

      state.customFieldMeuList.forEach((element) => element.isSelected = false);
      state.customFieldMeuList[id].isSelected = true;

      yield state.copyWith(customFieldMeuList: state.customFieldMeuList);
    }
  }
}
