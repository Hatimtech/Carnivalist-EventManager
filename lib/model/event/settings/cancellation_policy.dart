import 'package:eventmanagement/model/event/settings/cancellation_option.dart';

class CancellationPolicy {
  String description;
  List<CancellationOption> options;

  CancellationPolicy({
    this.description,
    this.options,
  });

  CancellationPolicy.fromJson(Map<String, dynamic> json) {
    description = json['description'];

    options = (json['options'] as List)
        ?.map((e) => CancellationOption.fromJson(e))
        ?.toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.description != null) data['description'] = this.description;

    if (this.options != null)
      data['options'] =
          this.options?.map((option) => option.toJson())?.toList();
    return data;
  }
}
