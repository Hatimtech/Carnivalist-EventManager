abstract class CreateStaffEvent {}

class AuthTokenSave extends CreateStaffEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class NameInput extends CreateStaffEvent {
  final String name;

  NameInput({this.name});
}

class EmailInput extends CreateStaffEvent {
  final String email;

  EmailInput({this.email});
}

class StateInput extends CreateStaffEvent {
  final String state;

  StateInput({this.state});
}

class CityInput extends CreateStaffEvent {
  final String city;

  CityInput({this.city});
}

class DOBInput extends CreateStaffEvent {
  final DateTime dob;

  DOBInput({this.dob});
}

class UsernameInput extends CreateStaffEvent {
  final String username;

  UsernameInput({this.username});
}

class MobileNoInput extends CreateStaffEvent {
  final String mobileNo;

  MobileNoInput({this.mobileNo});
}

class PasswordInput extends CreateStaffEvent {
  final String password;

  PasswordInput({this.password});
}

class AddEventInput extends CreateStaffEvent {
  final String eventId;

  AddEventInput({this.eventId});
}

class RemoveEventInput extends CreateStaffEvent {
  final String eventId;

  RemoveEventInput({this.eventId});
}

class UploadStaff extends CreateStaffEvent {
  Function callback;

  UploadStaff({this.callback});
}

class UploadStaffResult extends CreateStaffEvent {
  final bool success;
  final dynamic uiMsg;

  UploadStaffResult(this.success, {this.uiMsg});
}
