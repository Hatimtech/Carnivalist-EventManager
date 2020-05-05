import 'package:eventmanagement/model/event/settings/convenience_charge.dart';
import 'package:eventmanagement/model/event/settings/gst_charge.dart';

class PaymentAndTaxes {
  GSTCharge gstCharge;
  ConvenienceCharge convenienceCharge;

  PaymentAndTaxes({
    this.gstCharge,
    this.convenienceCharge,
  });

  PaymentAndTaxes.fromJson(Map<String, dynamic> json) {
    gstCharge = json['gstCharge'] != null
        ? new GSTCharge.fromJson(json['gstCharge'])
        : null;

    convenienceCharge = json['convenienceCharge'] != null
        ? new ConvenienceCharge.fromJson(json['convenienceCharge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gstCharge != null) data['gstCharge'] = this.gstCharge.toJson();
    if (this.convenienceCharge != null)
      data['convenienceCharge'] = this.convenienceCharge.toJson();
    return data;
  }
}
