import 'package:eventmanagement/service/viewmodel/mock_data.dart';

class FieldData {
  String id;
  String _id;
  String name;
  String label;
  String placeholder;
  bool required;
  String type;
  bool solid;
  List<String> configurations;

  String get idWith_ => _id;

  String get typeUI =>
      getCustomField()
          .firstWhere((menu) => menu.value == this.type, orElse: () => null)
          ?.name;

  FieldData(
    this._id, {
    this.id,
    this.name,
    this.label,
    this.placeholder,
    this.required,
    this.type,
    this.solid,
    this.configurations,
  });

  FieldData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _id = json['_id'];
    name = json['name'];
    label = json['label'];
    placeholder = json['placeholder'];
    required = json['required'];
    type = json['type'];
    solid = json['solid'];
    configurations = json['configurations']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.id != null) data['id'] = this.id;

    if (this._id != null) data['_id'] = this._id;

    if (this.name != null) data['name'] = this.name;

    if (this.label != null) data['label'] = this.label;

    if (this.placeholder != null) data['placeholder'] = this.placeholder;

    if (this.required != null) data['required'] = this.required;

    if (this.type != null) data['type'] = this.type;

    if (this.solid != null) data['solid'] = this.solid;

    if (this.configurations != null)
      data['configurations'] = this.configurations;
    return data;
  }

  static List<FieldData> get solidFields {
    return [
      FieldData(
        null,
        id: "177634226268613321",
        name: "183682113144083091",
        label: "First Name",
        required: true,
        type: "text",
        configurations: [],
        solid: true,
      ),
      FieldData(
        null,
        id: "177634226268613321",
        name: "183682113144083091",
        label: "Last Name",
        required: true,
        type: "text",
        configurations: [],
        solid: true,
      ),
      FieldData(
        null,
        id: "1115453010908661781",
        name: "131058293777007971",
        label: "Phone Number",
        required: true,
        type: "text",
        configurations: [],
        solid: true,
      ),
      FieldData(
        null,
        id: "179399914728065251",
        name: "1325924973786255731",
        label: "Email",
        required: true,
        type: "text",
        configurations: [],
        solid: true,
      ),
      FieldData(
        null,
        id: "133859500964572221",
        name: "1486445721832397651",
        label: "Message",
        required: false,
        type: "text",
        configurations: [],
        solid: true,
      ),
    ];
  }
}
