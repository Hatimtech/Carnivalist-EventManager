import 'package:eventmanagement/model/menu_custom.dart';

abstract class CreateFieldEvent {}

class CustomFieldMenu extends CreateFieldEvent {
}

class SelectCustomFieldName extends CreateFieldEvent {
  final MenuCustom customFieldName;

  SelectCustomFieldName({this.customFieldName});
}

class FieldLabelInput extends CreateFieldEvent {
  final String label;

  FieldLabelInput({this.label});
}

class FieldPlaceholderInput extends CreateFieldEvent {
  final String placeholder;

  FieldPlaceholderInput({this.placeholder});
}

class FieldMandatoryInput extends CreateFieldEvent {
  final bool mandatory;

  FieldMandatoryInput({this.mandatory});
}

class CreateFormField extends CreateFieldEvent {
  final Function callback;

  CreateFormField({this.callback});
}

class AddDropdownConfiguration extends CreateFieldEvent {
  final String configuration;

  AddDropdownConfiguration({this.configuration});
}

class RemoveDropdownConfiguration extends CreateFieldEvent {
  final String configuration;

  RemoveDropdownConfiguration({this.configuration});
}

