import 'package:eventmanagement/model/staff/staff.dart';

class CreateStaffState {
  final String authToken;
  final String name;
  final String username;
  final String mobileNumber;
  final String email;
  final String city;
  final String state;
  final DateTime dob;
  final String password;
  final List<String> selectedEvents;

  bool loading;
  dynamic uiMsg;

  CreateStaffState({
    this.authToken,
    this.name,
    this.username,
    this.mobileNumber,
    this.email,
    this.city,
    this.state,
    this.dob,
    this.password,
    this.selectedEvents,
    bool loading,
    this.uiMsg,
  });

  factory CreateStaffState.initial() {
    return CreateStaffState(
      authToken: '',
      name: '',
      username: '',
      mobileNumber: '',
      email: '',
      city: '',
      state: '',
      dob: null,
      selectedEvents: [],
      password: '',
      loading: false,
      uiMsg: null,
    );
  }

  factory CreateStaffState.copyWith(
    Staff staff,
  ) {
    return CreateStaffState(
      authToken: '',
      name: staff.name ?? '',
      username: staff.username ?? '',
      mobileNumber: staff.mobileNumber ?? '',
      email: staff.email ?? '',
      city: staff.city?.toString() ?? '',
      state: staff.state?.toString() ?? '',
      dob: staff.dob != null ? DateTime.parse(staff.dob) : null,
      password: '',
      selectedEvents: staff.selectedEvents ?? [],
      loading: false,
      uiMsg: null,
    );
  }

  CreateStaffState copyWith({
    String authToken,
    String name,
    String username,
    String mobileNumber,
    String email,
    String city,
    String state,
    DateTime dob,
    String password,
    List<String> selectedEvents,
    bool loading,
    dynamic uiMsg,
  }) {
    return CreateStaffState(
      authToken: authToken ?? this.authToken,
      name: name ?? this.name,
      username: username ?? this.username,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      city: city ?? this.city,
      state: state ?? this.state,
      dob: dob ?? this.dob,
      password: password ?? this.password,
      selectedEvents: selectedEvents ?? this.selectedEvents,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
    );
  }
}
