import 'package:eventmanagement/model/event/settings/cancellation_policy.dart';
import 'package:eventmanagement/model/event/settings/payment_and_taxes.dart';
import 'package:eventmanagement/model/event/settings/website_setting.dart';

class SettingData {
  String status;
  bool userContractCheck;
  bool isApprovedBySuperAdmin;
  PaymentAndTaxes paymentAndTaxes;
  CancellationPolicy cancellationPolicy;
  WebsiteSetting websiteSettings;

  SettingData({
    this.status,
    this.userContractCheck,
    this.isApprovedBySuperAdmin,
    this.paymentAndTaxes,
    this.cancellationPolicy,
    this.websiteSettings,
  });

  SettingData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userContractCheck = json['userContractCheck'];
    isApprovedBySuperAdmin = json['isApprovedBySuperAdmin'];

    paymentAndTaxes = json['paymentAndTaxes'] != null
        ? new PaymentAndTaxes.fromJson(json['paymentAndTaxes'])
        : null;

    cancellationPolicy = json['cancellationPolicy'] != null
        ? new CancellationPolicy.fromJson(json['cancellationPolicy'])
        : null;

    websiteSettings = json['websiteSettings'] != null
        ? new WebsiteSetting.fromJson(json['websiteSettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) data['status'] = this.status;
    if (this.userContractCheck != null)
      data['userContractCheck'] = this.userContractCheck;
    if (this.isApprovedBySuperAdmin != null)
      data['isApprovedBySuperAdmin'] = this.isApprovedBySuperAdmin;
    if (this.paymentAndTaxes != null)
      data['paymentAndTaxes'] = this.paymentAndTaxes.toJson();
    if (this.cancellationPolicy != null)
      data['cancellationPolicy'] = this.cancellationPolicy.toJson();
    if (this.websiteSettings != null)
      data['websiteSettings'] = this.websiteSettings.toJson();
    return data;
  }
}
