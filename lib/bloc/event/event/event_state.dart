import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';

class EventState {
  String authToken;
  String userId;
  final List<EventData> eventDataList;
  final List<MenuCustom> eventFilterItemList;
  final String eventCurrentFilter;
  final bool loading;
  dynamic uiMsg;

  EventState({
    this.authToken,
    this.userId,
    this.eventDataList,
    this.eventFilterItemList,
    this.eventCurrentFilter,
    this.loading,
    this.uiMsg,
  });

  factory EventState.initial() {
    return EventState(
      authToken: '',
      userId: '',
      eventDataList: [],
      eventFilterItemList: getEventFilterStatus(),
      loading: false,
      uiMsg: null,
    );
  }

  EventState copyWith({
    String authToken,
    String userId,
    List<EventData> eventDataList,
    List<MenuCustom> eventFilterItemList,
    String eventCurrentFilter,
    bool loading,
    dynamic uiMsg,
  }) {
    return EventState(
      authToken: authToken ?? this.authToken,
      userId: userId ?? this.userId,
      eventDataList: eventDataList ?? this.eventDataList,
      eventFilterItemList: eventFilterItemList ?? this.eventFilterItemList,
      eventCurrentFilter: eventCurrentFilter ?? this.eventCurrentFilter,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
    );
  }

  List<EventData> get data {
    if (eventCurrentFilter == eventFilterItemList[0].name) {
      return upcomingEvents;
    } else if (eventCurrentFilter == eventFilterItemList[1].name) {
      return draftEvents;
    } else if (eventCurrentFilter == eventFilterItemList[2].name) {
      return pastEvents;
    }
  }

  int get upcomingEventsCount {
    final dateTimeNow = DateTime.now();
    return eventDataList.where((event) {
      try {
        return isValid(event.endDateTime) &&
            DateTime.parse(event.endDateTime).isAfter(dateTimeNow) &&
            (event.status == 'ACTIVE');
      } catch (error) {
        return false;
      }
    }).length;
  }

  List<EventData> get upcomingEvents {
    final dateTimeNow = DateTime.now();
    return eventDataList.reversed.where((event) {
      try {
        return isValid(event.endDateTime) &&
            DateTime.parse(event.endDateTime).isAfter(dateTimeNow) &&
            (event.status == 'ACTIVE' || event.status == 'INACTIVE');
      } catch (error) {
        return false;
      }
    }).toList();
  }

  List<EventData> get draftEvents {
    return eventDataList.reversed.where((event) {
      return event.status == eventFilterItemList[1].name;
    }).toList();
  }

  List<EventData> get pastEvents {
    final dateTimeNow = DateTime.now();
    return eventDataList.reversed.where((event) {
      try {
        return isValid(event.endDateTime) &&
            DateTime.parse(event.endDateTime).isBefore(dateTimeNow);
      } catch (error) {
        return false;
      }
    }).toList();
  }

  List<EventData> get activeAndRunningEvents {
    final dateTimeNow = DateTime.now();
    return eventDataList.where((event) {
      try {
        return isValid(event.endDateTime) &&
            DateTime.parse(event.endDateTime).isAfter(dateTimeNow) &&
            event.status == 'ACTIVE';
      } catch (error) {
        return false;
      }
    }).toList();
  }

  List<EventData> get activeEventsWithTicket {
    final dateTimeNow = DateTime.now();
    return eventDataList.where((event) {
      try {
        return isValid(event.endDateTime) &&
            DateTime.parse(event.endDateTime).isAfter(dateTimeNow) &&
            event.status == 'ACTIVE' &&
            event.tickets.firstWhere((element) => (element.price ?? 0) > 0,
                    orElse: null) !=
                null;
      } catch (error) {
        return false;
      }
    }).toList();
  }

  List<EventData> get pastEventsWithTicket {
    final dateTimeNow = DateTime.now();
    return eventDataList.reversed.where((event) {
      try {
        return isValid(event.endDateTime) &&
            DateTime.parse(event.endDateTime).isBefore(dateTimeNow) &&
            event.tickets.firstWhere((element) => (element.price ?? 0) > 0,
                orElse: null) !=
                null;
      } catch (error) {
        return false;
      }
    }).toList();
  }

  EventData findById(String eventId) {
    return eventDataList.firstWhere(
          (eventData) => eventData.id == eventId,
      orElse: () => null,
    );
  }

  bool isAnyApprovedBySuperAdmin() {
    return eventDataList.firstWhere(
          (eventData) =>
      (eventData.status != 'DRAFT' &&
          eventData.isApprovedBySuperAdmin ??
          false),
      orElse: () => null,
    ) !=
        null;
  }
}
