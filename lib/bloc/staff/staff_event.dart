import 'dart:async';

import 'package:eventmanagement/model/staff/staff.dart';

abstract class StaffEvent {}

class AuthTokenSave extends StaffEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class AddStaff extends StaffEvent {
  final Staff staff;

  AddStaff(this.staff);
}

class UpdateStaff extends StaffEvent {
  final Staff staff;

  UpdateStaff(this.staff);
}

class DeleteStaff extends StaffEvent {
  final String id;

  DeleteStaff(this.id);
}

class GetAllStaff extends StaffEvent {
  Completer<bool> downloadCompleter;

  GetAllStaff({this.downloadCompleter});
}

class StaffListAvailable extends StaffEvent {
  final bool success;
  final dynamic error;
  final List<Staff> staffs;

  StaffListAvailable(this.success, {this.error, this.staffs});
}

class ActiveInactiveStaff extends StaffEvent {
  final String id;
  final bool active;
  final Function callback;

  ActiveInactiveStaff(this.id, this.active, this.callback);
}

class ActiveInactiveStaffResult extends StaffEvent {
  final bool success;
  final String id;
  final bool active;
  final dynamic uiMsg;

  ActiveInactiveStaffResult(this.success, {this.id, this.active, this.uiMsg});
}
