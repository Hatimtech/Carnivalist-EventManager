import 'package:eventmanagement/model/staff/staff.dart';

class CreateStaffResponse {
  int code;
  Staff userStaff;
  String message;

  CreateStaffResponse({this.code, this.userStaff});

  CreateStaffResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    userStaff =
        json['userStaff'] != null ? Staff.fromJson(json['userStaff']) : null;
    message = json['message'];
  }
}
