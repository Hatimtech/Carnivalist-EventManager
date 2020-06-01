import 'package:eventmanagement/model/staff/staff.dart';

class StaffResponse {
  int code;
  List<Staff> staffs;
  String message;

  StaffResponse({this.code, this.staffs});

  StaffResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    staffs = (json['staffs'] as List)?.map((e) => Staff.fromJson(e))?.toList();
    message = json['message'];
  }
}
