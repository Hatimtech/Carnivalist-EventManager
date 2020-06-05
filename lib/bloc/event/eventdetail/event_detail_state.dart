import 'package:eventmanagement/model/eventdetails/event_detail.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';

class EventDetailState {
  final String authToken;
  final List<EventDetail> eventDetailList;
  final List<MenuCustom> attendeesFilterType;
  final MenuCustom currentFilter;
  bool loading;
  dynamic uiMsg;

  EventDetailState({
    this.authToken,
    this.eventDetailList,
    this.attendeesFilterType,
    this.currentFilter,
    this.loading,
    this.uiMsg,
  });

  factory EventDetailState.initial() {
    final attendeesFilterType = getAttendeesFilterType();
    return EventDetailState(
      authToken: "",
      eventDetailList: List(),
      attendeesFilterType: attendeesFilterType,
      currentFilter: attendeesFilterType[0],
      loading: false,
      uiMsg: null,
    );
  }

  EventDetailState copyWith({
    bool loading,
    String authToken,
    List<EventDetail> eventDetailList,
    List<MenuCustom> attendeesFilterType,
    MenuCustom currentFilter,
    dynamic uiMsg,
  }) {
    return EventDetailState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      eventDetailList: eventDetailList ?? this.eventDetailList,
      attendeesFilterType: attendeesFilterType ?? this.attendeesFilterType,
      currentFilter: currentFilter ?? this.currentFilter,
      uiMsg: uiMsg,
    );
  }

  List<EventDetail> get eventDetailListByFilter {
    if (currentFilter.value == attendeesFilterType[0].value) {
      return eventDetailList;
    } else if (currentFilter.value == attendeesFilterType[1].value) {
      return eventDetailList
          .where((element) => (element.isEventAttended ?? false))
          .toList();
    } else {
      return eventDetailList
          .where((element) =>
      element.isEventAttended != null ? !element.isEventAttended : true)
          .toList();
    }
  }
}
