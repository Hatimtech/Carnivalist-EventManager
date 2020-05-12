import 'package:eventmanagement/model/addons/addon.dart';

class AddonResponse {
  int code;
  Addon addons;
  String message;

  AddonResponse({this.code, this.addons});

  AddonResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    addons = json['addons'] != null ? new Addon.fromJson(json['addons']) : null;
    message = json['message'];
  }
}
