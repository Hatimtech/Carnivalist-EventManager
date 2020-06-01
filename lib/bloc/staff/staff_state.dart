import 'package:eventmanagement/model/staff/staff.dart';

class StaffState {
  final String authToken;
  final List<Staff> staffs;
  bool loading;
  dynamic uiMsg;

  StaffState({
    this.authToken,
    this.staffs,
    this.loading,
    this.uiMsg,
  });

  factory StaffState.initial() {
    return StaffState(
      authToken: "",
      staffs: List(),
      loading: false,
      uiMsg: null,
    );
  }

  StaffState copyWith({
    bool loading,
    String authToken,
    List<Staff> staffs,
    dynamic uiMsg,
  }) {
    return StaffState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      staffs: staffs ?? this.staffs,
      uiMsg: uiMsg,
    );
  }
}
