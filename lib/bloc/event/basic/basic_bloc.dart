import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/carnivals/carnival_resonse.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:intl/intl.dart';

import 'basic_event.dart';
import 'basic_state.dart';

class BasicBloc extends Bloc<BasicEvent, BasicState> {
  final ApiProvider apiProvider = ApiProvider();
  EventData mainEventData;
  String eventDataId;

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void eventNameInput(eventName) {
    add(EventNameInput(eventName: eventName));
  }

  void eventTypeInput(eventType) {
    add(EventTypeInput(eventType: eventType));
  }

  void eventTimeZoneInput(eventTimeZone) {
    add(EventTimeZoneInput(eventTimeZone: eventTimeZone));
  }

  void eventTagsInput(eventTag) {
    add(EventTagsInput(eventTag: eventTag));
  }

  void eventRemoveTag(eventTag) {
    add(EventRemoveTag(eventTag: eventTag));
  }

  void eventStartDateInput(eventStartDate) {
    add(EventStartDateInput(eventStartDate: eventStartDate));
  }

  void eventStartTimeInput(eventStartTime) {
    add(EventStartTimeInput(eventStartTime: eventStartTime));
  }

  void eventEndDateInput(eventEndDate) {
    add(EventEndDateInput(eventEndDate: eventEndDate));
  }

  void eventEndTimeInput(eventEndTime) {
    add(EventEndTimeInput(eventEndTime: eventEndTime));
  }

  void eventWeekdayInput(eventWeekday) {
    add(EventWeekdayInput(eventWeekday: eventWeekday));
  }

  void eventAddCustomDate() {
    add(EventAddCustomDate());
  }

  void eventRemoveCustomDate(eventCustomDate) {
    add(EventRemoveCustomDate(eventCustomDate: eventCustomDate));
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
    if (event is EventTypeInput) {
      yield state.copyWith(eventCarnival: event.eventType);
    }
    if (event is EventTagsInput) {
      if (!state.eventTags.contains(event.eventTag)) {
        state.eventTags.add(event.eventTag);
        final List<String> eventTagList = [];
        eventTagList.addAll(state.eventTags);
        yield state.copyWith(eventTags: eventTagList);
      } else {
        yield state.copyWith(errorCode: ERR_DUPLICATE_TAG);
      }
    }
    if (event is EventRemoveTag) {
      state.eventTags.remove(event.eventTag);
      final List<String> eventTagList = [];
      eventTagList.addAll(state.eventTags);
      yield state.copyWith(eventTags: eventTagList);
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
    if (event is EventWeekdayInput) {
      yield state.copyWith(eventWeekday: event.eventWeekday);
    }
    if (event is EventAddCustomDate) {
      if (state.eventStartDate == null) {
        yield state.copyWith(errorCode: ERR_START_DATE);
        return;
      }

      if (state.eventStartTime == null) {
        yield state.copyWith(errorCode: ERR_START_TIME);
        return;
      }

      if (state.eventEndDate == null) {
        yield state.copyWith(errorCode: ERR_END_DATE);
        return;
      }

      if (state.eventEndTime == null) {
        yield state.copyWith(errorCode: ERR_END_TIME);
        return;
      }

      if (startDateTime.isAfter(endDateTime)) {
        yield state.copyWith(errorCode: ERR_END_TIME_LESS);
        return;
      }

      List<EventCustomDate> eventCustomDateTimeList = [];
      eventCustomDateTimeList.addAll(state.eventCustomDateTimeList);
      eventCustomDateTimeList.add(EventCustomDate(
        eventStartDateTime: startDateTime,
        eventEndDateTime: endDateTime,
      ));

      yield state.copyWith(eventCustomDateTimeList: eventCustomDateTimeList);
    }
    if (event is EventRemoveCustomDate) {
      state.eventCustomDateTimeList.remove(event.eventCustomDate);

      final List<EventCustomDate> eventCustomDateTimeList = [];
      eventCustomDateTimeList.addAll(state.eventCustomDateTimeList);

      yield state.copyWith(eventCustomDateTimeList: eventCustomDateTimeList);
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
          var carnivalResponse =
          apiProvider.apiResult.response as CarnivalResonse;
          if (carnivalResponse.code == apiCodeSuccess) {
            yield state.copyWith(
              eventTypeList: carnivalResponse.carnivalList,
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
        yield state.copyWith(loading: false);
      }
    }
    if (event is Basic) {
      int errorCode = validateBasicInfo();

      if (errorCode > 0) {
        yield state.copyWith(errorCode: errorCode);
        event.callback(null);
        return;
      }

      await apiProvider.getBasic(state.authToken, eventDataToUpload,
          eventDataId: eventDataId);

      yield state.copyWith(loading: false);

      if (apiProvider.apiResult.responseCode == ok200) {
        var basicResponse = apiProvider.apiResult.response;
        if (basicResponse.id != null) eventDataId = basicResponse.id;
        event.callback(basicResponse);
      } else {
        event.callback(apiProvider.apiResult.errorMessage);
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

  int validateBasicInfo() {
    if (!isValid(state.eventName)) return ERR_EVENT_NAME;
    if (!isValid(state.eventType)) return ERR_EVENT_TYPE;
    if (!isValid(state.eventTimeZone)) return ERR_EVENT_TIMEZONE;

    final menuList = state.eventMenuList;
    if (state.eventMenuName == menuList[0].name) {
      if (state.eventStartDate == null) return ERR_START_DATE;
      if (state.eventStartTime == null) return ERR_START_TIME;
      if (state.eventEndDate == null) return ERR_END_DATE;
      if (state.eventEndTime == null) return ERR_END_TIME;

      if (startDateTime.isAfter(endDateTime)) return ERR_END_TIME_LESS;
    } else if (state.eventMenuName == menuList[1].name) {
      if (state.eventStartDate == null) return ERR_START_DATE;
      if (state.eventStartTime == null) return ERR_START_TIME;
      if (state.eventEndDate == null) return ERR_END_DATE;
      if (state.eventEndTime == null) return ERR_END_TIME;

      if (startDateTime.isAfter(endDateTime)) return ERR_END_TIME_LESS;
    } else if (state.eventMenuName == menuList[2].name) {
      if (state.eventStartDate == null) return ERR_START_DATE;
      if (state.eventStartTime == null) return ERR_START_TIME;
      if (state.eventEndDate == null) return ERR_END_DATE;
      if (state.eventEndTime == null) return ERR_END_TIME;

      if (!isValid(state.eventWeekday))
        return ERR_WEEK_DAY;
      else {
        final startDateWeekday =
        DateFormat('EEEE').format(state.eventStartDate);

        if (startDateWeekday != state.eventWeekday)
          return ERR_START_DATE_WEEK_DAY;

        final endDateWeekday = DateFormat('EEEE').format(state.eventEndDate);
        if (endDateWeekday != state.eventWeekday) return ERR_END_DATE_WEEK_DAY;

        if (startDateTime.isAfter(endDateTime)) return ERR_END_TIME_LESS;
      }
    } else if (state.eventMenuName == menuList[3].name) {
      if (state.eventCustomDateTimeList.length < 2) return ERR_TWO_DATES_REQ;
    }

    if (!isValid(state.eventLocation)) return ERR_EVENT_ADDRESS;
    if (!isValid(state.eventState)) return ERR_EVENT_STATE;
    if (!isValid(state.eventCity)) return ERR_EVENT_CITY;
    if (!isValid(state.eventPostalCode)) return ERR_EVENT_POSTAL;

    if (!isValid(state.eventDescription))
      return ERR_EVENT_DESC;
    else
      return 0;
  }

  DateTime get startDateTime =>
      DateTime(
        state.eventStartDate.year,
        state.eventStartDate.month,
        state.eventStartDate.day,
        state.eventStartTime.hour,
        state.eventStartTime.minute,
      );

  DateTime get endDateTime =>
      DateTime(
        state.eventEndDate.year,
        state.eventEndDate.month,
        state.eventEndDate.day,
        state.eventEndTime.hour,
        state.eventEndTime.minute,
      );

  List<CustomDateTime> get customSelectedDates {
    List<CustomDateTime> customSelectedDateTime = [];
    customSelectedDateTime
        .addAll(state.eventCustomDateTimeList.map((eventCustomDateTime) {
      return CustomDateTime(
        startDateTime: eventCustomDateTime.eventStartDateTime.toIso8601String(),
        endDateTime: eventCustomDateTime.eventEndDateTime.toIso8601String(),
      );
    }));
    return customSelectedDateTime;
  }

  EventData get eventDataToUpload =>
      EventData(
          title: state.eventName,
          type: state.eventType,
          timeZone: state.eventTimeZone,
          tags: state.eventTags,
          eventFrequency: state.eventMenuName,
          eventPrivacy: state.postType?.toLowerCase(),
          startDateTime: startDateTime.toIso8601String(),
          endDateTime: endDateTime.toIso8601String(),
          description: state.eventDescription,
          place: Place(
            name: '',
            address: state.eventLocation,
            state: state.eventState,
            city: state.eventCity,
            pincode: state.eventPostalCode,
          ),
          daily: Daily(
            endDate: '',
            endTime: '',
            startDate: '',
            startTime: '',
          ),
          weekly: Weekly(
            startTime: '',
            startDate: '',
            endTime: '',
            endDate: '',
            day: state.eventWeekday,
          ),
          custom: Custom(
            endTime: '',
            startTime: '',
            selectedDays: customSelectedDates,
          ));
}
