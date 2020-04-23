import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/basic/basic_json.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'basic_event.dart';
import 'basic_state.dart';

class BasicBloc extends Bloc<BasicEvent, BasicState> {
  final ApiProvider apiProvider = ApiProvider();

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void eventNameInput(eventName) {
    add(EventNameInput(eventName: eventName));
  }

  void eventEndDateInput(eventEndDate) {
    add(EventEndDateInput(eventEndDate: eventEndDate));
  }
  void eventEndTimeInput(eventEndTime) {
    add(EventEndTimeInput(eventEndTime: eventEndTime));
  }
  void eventCarnivalInput(eventCarnival) {
    add(EventCarnivalInput(eventCarnival: eventCarnival));
  }
  void eventTimeZoneInput(eventTimeZone) {
    add(EventTimeZoneInput(eventTimeZone: eventTimeZone));
  }

  void eventTagsInput(eventtags) {
    add(EventTagsInput(eventtags: eventtags));
  }

  void eventStartDateInput(eventStartDate) {
    add(EventStartDateInput(eventStartDate: eventStartDate));
  }

  void eventStartTimeInput(eventStartTime) {
    add(EventStartTimeInput(eventStartTime: eventStartTime));
  }

  void eventLocationInput(eventLocation) {
    add(EventLocationInput(eventLocation: eventLocation));
  }

  void eventStateInput(eventState) {
    add(EventStateInput(eventState: eventState));
  }

  void eventCityInput(eventCity) {
    add(EventCityInput(eventCity: eventCity));
  }

  void eventPostalCodeInput(eventPostalCode) {
    add(EventPostalCodeInput(eventPostalCode: eventPostalCode));
  }

  void eventDescriptionInput(eventDescription) {
    add(EventDescriptionInput(eventDescription: eventDescription));
  }

  void basic(callback) {
    add(Basic(callback: callback));
  }

  void eventMenu() {
    add(EventMenu());
  }

  void selectEventMenu(eventMenuName) {
    add(SelectEventMenu(eventMenuName: eventMenuName));
  }

  void postType() {
    add(PostType());
  }

  void selectPostType(postType) {
    add(SelectPostType(postType: postType));
  }
  void carnival() {
    add(Carnival());
  }
  @override
  BasicState get initialState => BasicState.initial();

  @override
  Stream<BasicState> mapEventToState(BasicEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }
    if (event is EventNameInput) {
      yield state.copyWith(eventName: event.eventName);
    }

    if (event is EventTimeZoneInput) {

      yield state.copyWith(eventTimeZone: event.eventTimeZone);
    }
    if (event is EventCarnivalInput) {

      yield state.copyWith(eventCarnival: event.eventCarnival);
    }
    if (event is EventTagsInput) {

      yield state.copyWith(eventTags: event.eventtags);
    }
    if (event is EventStartDateInput) {
      yield state.copyWith(eventStartDate: event.eventStartDate);
    }
    if (event is EventStartTimeInput) {
      yield state.copyWith(eventStartTime: event.eventStartTime);
    }
    if (event is EventEndDateInput) {
      yield state.copyWith(eventEndDate: event.eventEndDate);
      print('${event.eventEndDate}');
    }
    if (event is EventEndTimeInput) {
      yield state.copyWith(eventEndTime: event.eventEndTime);
      print('${event.eventEndTime}');

    }
    if (event is EventLocationInput) {
      yield state.copyWith(eventLocation: event.eventLocation);
    }
    if (event is EventStateInput) {
      yield state.copyWith(eventState: event.eventState);
    }
    if (event is EventCityInput) {
      yield state.copyWith(eventCity: event.eventCity);
    }
    if (event is EventPostalCodeInput) {
      yield state.copyWith(eventPostalCode: event.eventPostalCode);
    }
    if (event is EventDescriptionInput) {
      yield state.copyWith(eventDescription: event.eventDescription);
    }
    if (event is Carnival) {
      yield state.copyWith(loading: true);

      await apiProvider.getCarnival();

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var carnivalResponse = apiProvider.apiResult.response;
          if (carnivalResponse.code == apiCodeSuccess) {

            yield state.copyWith(
              carnivalList: carnivalResponse.carnivalList,
            );
            print(carnivalResponse.carnivalList);

          }
          yield state.copyWith(
            loading: false,
          );
        } else {
          yield state.copyWith(
            loading: false,
          );
        }
      } catch (e) {
        yield state.copyWith(
            loading: false
        );
      }
    }
    if (event is Basic) {
      print('timezone: ${state.eventTimeZone}');
      await apiProvider.getBasic(
          state.authToken,
          BasicJson(
              title: state.eventName,
              type: state.eventCarnival,
              timeZone: state.eventTimeZone,
              tags: [],
              startDateTime: state.eventStartDate + '-' + state.eventStartTime,
              description: state.eventDescription,
              place: Place(
                  name: '',
                  address: state.eventLocation,
                  state: state.eventState,
                  city: state.eventCity,
                  pincode: state.eventPostalCode),
              eventPrivacy: 'public',
              endDateTime: '',
              daily:
              Daily(endDate: '', endTime: '', startDate: '', startTime: ''),
              weekly: Weekly(
                  startTime: '',
                  startDate: '',
                  endTime: '',
                  endDate: '',
                  day: ''),
              custom: Custom(endTime: '', startTime: '', selectedDays: [])));

      if (apiProvider.apiResult.responseCode == ok200) {
        var basicResponse = apiProvider.apiResult.response;
        event.callback(basicResponse);
      }
    }

    if (event is EventMenu) {
      yield state.copyWith(eventMenuList: getBasicEventMenu());
    }

    if (event is PostType) {
      yield state.copyWith(postTypeList: getBasicEventPostType());
    }

    if (event is SelectPostType) {
      yield state.copyWith(postType: event.postType);

      int id =
          state.postTypeList.indexWhere((item) => item.name == state.postType);

      state.postTypeList.forEach((element) => element.isSelected = false);
      state.postTypeList[id].isSelected = true;

      yield state.copyWith(postTypeList: state.postTypeList);
    }

    if (event is SelectEventMenu) {
      yield state.copyWith(eventMenuName: event.eventMenuName);

      int id = state.eventMenuList
          .indexWhere((item) => item.name == state.eventMenuName);

      state.eventMenuList.forEach((element) => element.isSelected = false);
      state.eventMenuList[id].isSelected = true;

      yield state.copyWith(eventMenuList: state.eventMenuList);
    }
  }
}
