import 'package:eventmanagement/utils/vars.dart';

class CancellationOption {
  String refundType;
  DateTime cancellationEndDate;
  String refundValue;

  CancellationOption({
    this.refundType,
    this.cancellationEndDate,
    this.refundValue,
  });

  CancellationOption.fromJson(Map<String, dynamic> json) {
    refundType = json['refundType'];
    cancellationEndDate = isValid(json['cancellationEndDate'])
        ? DateTime.parse(json['cancellationEndDate'])
        : null;
    refundValue = json['refundValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.refundType != null) data['refundType'] = this.refundType;
    if (this.cancellationEndDate != null)
      data['cancellationEndDate'] = this.cancellationEndDate.toIso8601String();
    if (this.refundValue != null) data['refundValue'] = this.refundValue;
    return data;
  }
}
