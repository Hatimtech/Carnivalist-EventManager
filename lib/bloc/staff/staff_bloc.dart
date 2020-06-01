import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/staff/staff_event.dart';
import 'package:eventmanagement/bloc/staff/staff_state.dart';
import 'package:eventmanagement/model/staff/staff.dart';
import 'package:eventmanagement/model/staff/staff_action_response.dart';
import 'package:eventmanagement/model/staff/staff_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final ApiProvider apiProvider = ApiProvider();

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void getAllStaffs({Completer<bool> downloadCompleter}) {
    add(GetAllStaff(downloadCompleter: downloadCompleter));
  }

  void addStaff(Staff staff) {
    add(AddStaff(staff));
  }

  void updateStaff(Staff staff) {
    add(UpdateStaff(staff));
  }

  void deleteStaff(String id) {
    add(DeleteStaff(id));
  }

  void activeInactiveStaff(String staffId, bool active, Function callback) {
    add(ActiveInactiveStaff(staffId, active, callback));
  }

  @override
  StaffState get initialState => StaffState.initial();

  @override
  Stream<StaffState> mapEventToState(StaffEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is GetAllStaff) {
      if (event.downloadCompleter == null) yield state.copyWith(loading: true);
      getAllStaffApi(event);
    }

    if (event is StaffListAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        staffs: event.success ? event.staffs : null,
      );
    }

    if (event is AddStaff) {
      state.staffs.add(event.staff);
      yield state.copyWith(
        staffs: List.of(state.staffs),
      );
//      yield state.copyWith(loading: true);
//      getAllStaffApi(event);
    }

    if (event is UpdateStaff) {
      int removeIndex =
          state.staffs.indexWhere((coupon) => coupon.id == event.staff.id);
      state.staffs.removeAt(removeIndex);
      state.staffs.insert(removeIndex, event.staff);
      yield state.copyWith(
        staffs: List.of(state.staffs),
      );
//      yield state.copyWith(loading: true);
//      getAllStaffApi(event);
    }

    if (event is ActiveInactiveStaff) {
      activeInactiveStaffApi(event);
    }

    if (event is ActiveInactiveStaffResult) {
      if (event.success) {
        final coupon = state.staffs.firstWhere((staff) => staff.id == event.id);
        coupon.isDisabled = event.active;

        yield state.copyWith(
            staffs: List.of(state.staffs), loading: false, uiMsg: event.uiMsg);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }
  }

  void getAllStaffApi(StaffEvent event) {
    apiProvider.getAllStaffs(state.authToken).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var staffResponse = networkServiceResponse.response as StaffResponse;
        if (staffResponse != null && staffResponse.code == apiCodeSuccess) {
          final staffsList = staffResponse.staffs;
          add(StaffListAvailable(true, staffs: staffsList));
        }
      } else {
        add(StaffListAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
      if (event is GetAllStaff && event.downloadCompleter != null)
        event.downloadCompleter.complete(true);
    }).catchError((error, stack) {
      print('Error in getAllStaffApi--->$error\n$stack');
      add(StaffListAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      if (event is GetAllStaff && event.downloadCompleter != null)
        event.downloadCompleter.complete(false);
    });
  }

  void activeInactiveStaffApi(ActiveInactiveStaff event) {
    apiProvider
        .activeInactiveStaff(state.authToken, event.id, event.active)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
            networkServiceResponse.response as StaffActionResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(ActiveInactiveStaffResult(
            true,
            id: event.id,
            active: event.active,
            uiMsg: eventActionResponse.message,
          ));
          event.callback(eventActionResponse);
        } else {
          add(ActiveInactiveStaffResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse.message);
        }
      } else {
        add(ActiveInactiveStaffResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in activeInactiveStaffApi--->$error');
      add(ActiveInactiveStaffResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
