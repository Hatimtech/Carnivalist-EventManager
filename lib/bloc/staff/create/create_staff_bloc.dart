import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/staff/create/create_staff_event.dart';
import 'package:eventmanagement/bloc/staff/create/create_staff_state.dart';
import 'package:eventmanagement/bloc/staff/staff_bloc.dart';
import 'package:eventmanagement/model/staff/create_staff_response.dart';
import 'package:eventmanagement/model/staff/staff.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class CreateStaffBloc extends Bloc<CreateStaffEvent, CreateStaffState> {
  final ApiProvider apiProvider = ApiProvider();
  final StaffBloc staffBloc;
  final String staffId;

  List<String> statesList = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'Byram',
    'California',
    'Cokato',
    'Colorado',
    'Connecticut',
    'Delaware',
    'District of Columbia',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Lowa',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Medfield',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Jersy',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Ontario',
    'Oregon',
    'Pennsylvania',
    'Ramey',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Sublimity',
    'Tennessee',
    'Texas',
    'Trimble',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ];

  CreateStaffBloc(this.staffBloc, {this.staffId});

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void nameInput(name) {
    add(NameInput(name: name));
  }

  void emailInput(email) {
    add(EmailInput(email: email));
  }

  void dobInput(dob) {
    add(DOBInput(dob: dob));
  }

  void stateInput(state) {
    add(StateInput(state: state));
  }

  void cityInput(city) {
    add(CityInput(city: city));
  }

  void usernameInput(username) {
    add(UsernameInput(username: username));
  }

  void mobileNoInput(mobileNo) {
    add(MobileNoInput(mobileNo: mobileNo));
  }

  void passwordInput(password) {
    add(PasswordInput(password: password));
  }

  void addEventInput(ticketId) {
    add(AddEventInput(eventId: ticketId));
  }

  void removeEventInput(ticketId) {
    add(RemoveEventInput(eventId: ticketId));
  }

  void uploadNewStaff(callback) {
    add(UploadStaff(callback: callback));
  }

  @override
  CreateStaffState get initialState {
    if (staffId == null)
      return CreateStaffState.initial();
    else {
      final staff =
          staffBloc.state.staffs.firstWhere((staff) => staff.id == staffId);
      return CreateStaffState.copyWith(staff);
    }
  }

  @override
  Stream<CreateStaffState> mapEventToState(CreateStaffEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is NameInput) {
      yield state.copyWith(name: event.name);
    }

    if (event is EmailInput) {
      yield state.copyWith(email: event.email);
    }

    if (event is DOBInput) {
      final start = event.dob;
      yield state.copyWith(dob: DateTime(start.year, start.month, start.day));
    }

    if (event is StateInput) {
      yield state.copyWith(state: event.state);
    }

    if (event is CityInput) {
      yield state.copyWith(city: event.city);
    }

    if (event is UsernameInput) {
      yield state.copyWith(username: event.username);
    }

    if (event is MobileNoInput) {
      yield state.copyWith(mobileNumber: event.mobileNo);
    }

    if (event is PasswordInput) {
      yield state.copyWith(password: event.password);
    }

    if (event is AddEventInput) {
      yield state.copyWith(
          selectedEvents: List.of(state.selectedEvents)..add(event.eventId));
    }

    if (event is RemoveEventInput) {
      yield state.copyWith(
          selectedEvents: List.of(state.selectedEvents)..remove(event.eventId));
    }

    if (event is UploadStaff) {
      yield* uploadStaff(event);
    }

    if (event is UploadStaffResult) {
      yield state.copyWith(
        loading: false,
        uiMsg: event.uiMsg,
      );
    }
  }

  Stream<CreateStaffState> uploadStaff(UploadStaff event) async* {
    int errorCode = validateStaffData;
    if (errorCode > 0) {
      yield state.copyWith(uiMsg: errorCode);
      event.callback(null);
      return;
    }
    yield state.copyWith(loading: true);

    final staffToUpload = staffDataToUpload;
    apiProvider
        .createUpdateStaff(state.authToken, staffToUpload, staffId: staffId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var staffResponse =
            networkServiceResponse.response as CreateStaffResponse;
        if (staffResponse.code == apiCodeSuccess) {
          if (staffId != null) {
            staffBloc.updateStaff(staffDataToUpdate);
          } else {
            staffBloc.addStaff(staffResponse.userStaff);
          }
          add(UploadStaffResult(true));
          event.callback(staffResponse);
        } else {
          add(UploadStaffResult(false,
              uiMsg: staffResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(staffResponse.message);
        }
      } else {
        add(UploadStaffResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in uploadStaff--->$error');
      add(UploadStaffResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(error);
    });
  }

  int get validateStaffData {
    if (!isValid(state.name)) return ERR_STAFF_NAME;
    if (!isValid(state.email)) return ERR_STAFF_EMAIL;
    if (!isValidEmail(state.email)) return ERR_STAFF_EMAIL_VALID;
    if (state.dob == null) return ERR_STAFF_DOB;
    if (!isValid(state.state)) return ERR_STAFF_STATE;
    if (!isValid(state.city)) return ERR_STAFF_CITY;
    if (!isValid(state.username)) return ERR_STAFF_USERNAME;
    if (!isValid(state.mobileNumber)) return ERR_STAFF_MOBILE_NO;
    if (state.mobileNumber.length < 10) return ERR_STAFF_MOBILE_NO_LENGTH;
    if (!isValid(state.password)) return ERR_STAFF_PASSWORD;
    if (state.selectedEvents == null || state.selectedEvents.length == 0)
      return ERR_STAFF_SELECT_EVENTS;
    return 0;
  }

  Map<String, dynamic> get staffDataToUpload {
    Map<String, dynamic> param = Map();
    param.putIfAbsent('name', () => state.name);
    param.putIfAbsent('email', () => state.email);
    param.putIfAbsent('dob', () => state.dob.toIso8601String());
    param.putIfAbsent('state', () => state.state);
    param.putIfAbsent('city', () => state.city);
    param.putIfAbsent('mobile', () => state.mobileNumber);
    param.putIfAbsent('username', () => state.username);
    param.putIfAbsent('password', () => state.password);
    param.putIfAbsent('selectedEvents', () => state.selectedEvents);
    return param;
  }

  Staff get staffDataToUpdate {
    final staff =
        staffBloc.state.staffs.firstWhere((staff) => staff.id == staffId);
    return Staff(
      id: staffId,
      name: state.name,
      email: state.email,
      dob: state.dob.toIso8601String(),
      state: state.state,
      city: state.city,
      mobileNumber: state.mobileNumber,
      username: state.username,
      password: state.password,
      isBlockedByAdmin: staff.isBlockedByAdmin,
      isDisabled: staff.isDisabled,
      selectedEvents: state.selectedEvents,
    );
  }
}
