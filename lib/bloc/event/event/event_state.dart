import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';

class EventState {
  String authToken;
  final List<EventData> eventDataList;
  final List<MenuCustom> eventFilterItemList;
  final String eventCurrentFilter;
  final bool loading;
  int errorCode;
  String toastMsg;

  EventState({
    this.authToken,
    this.eventDataList,
    this.eventFilterItemList,
    this.eventCurrentFilter,
    this.loading,
    this.errorCode,
    this.toastMsg,
  });

  factory EventState.initial() {
    return EventState(
      authToken: '',
      eventDataList: [],
      eventFilterItemList: getEventFilterStatus(),
      loading: false,
      errorCode: null,
      toastMsg: null,
    );
  }

  EventState copyWith({
    String authToken,
    List<EventData> eventDataList,
    List<MenuCustom> eventFilterItemList,
    String eventCurrentFilter,
    bool loading,
    int errorCode,
    String toastMsg,
  }) {
    return EventState(
      authToken: authToken ?? this.authToken,
      eventDataList: eventDataList ?? this.eventDataList,
      eventFilterItemList: eventFilterItemList ?? this.eventFilterItemList,
      eventCurrentFilter: eventCurrentFilter ?? this.eventCurrentFilter,
      loading: loading ?? this.loading,
      errorCode: errorCode,
      toastMsg: toastMsg,
    );
  }

  List<EventData> get data {
    if (eventCurrentFilter == eventFilterItemList[0].name) {
      final dateTimeNow = DateTime.now();
      return eventDataList.where((event) {
        try {
          return isValid(event.startDateTime) &&
              DateTime.parse(event.startDateTime).isAfter(dateTimeNow) &&
              (event.status == 'ACTIVE' || event.status == 'INACTIVE');
        } catch (error) {
          return false;
        }
      }).toList();
    } else if (eventCurrentFilter == eventFilterItemList[1].name) {
      return eventDataList.where((event) {
        return event.status == eventFilterItemList[1].name;
      }).toList();
    } else if (eventCurrentFilter == eventFilterItemList[2].name) {
      final dateTimeNow = DateTime.now();
      return eventDataList.where((event) {
        try {
          return isValid(event.startDateTime) &&
              DateTime.parse(event.startDateTime).isBefore(dateTimeNow);
        } catch (error) {
          return false;
        }
      }).toList();
    }
  }

  int get upcomingEventsCount {
    final dateTimeNow = DateTime.now();
    return eventDataList.where((event) {
      try {
        return isValid(event.startDateTime) &&
            DateTime.parse(event.startDateTime).isAfter(dateTimeNow) &&
            (event.status == 'ACTIVE' || event.status == 'INACTIVE');
      } catch (error) {
        return false;
      }
    }).length;
  }

  EventData findById(String eventId) {
    return eventDataList.firstWhere(
          (eventData) => eventData.id == eventId,
      orElse: () => null,
    );
  }
}