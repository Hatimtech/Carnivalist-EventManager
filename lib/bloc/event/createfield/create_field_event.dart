abstract class CreateFieldEvent {}

class CustomFieldMenu extends CreateFieldEvent {
}

class SelectCustomFieldName extends CreateFieldEvent {
  final String customFieldName;
  SelectCustomFieldName({this.customFieldName});
}

