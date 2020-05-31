import 'package:eventmanagement/model/eventdetails/event_detail.dart';

class EventDetailState {
  final String authToken;
  final List<EventDetail> eventDetailList;
  bool loading;
  dynamic uiMsg;

  EventDetailState({
    this.authToken,
    this.eventDetailList,
    this.loading,
    this.uiMsg,
  });

  factory EventDetailState.initial() {
    return EventDetailState(
      authToken: "",
      eventDetailList: List(),
      loading: false,
      uiMsg: null,
    );
  }

  EventDetailState copyWith({
    bool loading,
    String authToken,
    List<EventDetail> eventDetailList,
    dynamic uiMsg,
  }) {
    return EventDetailState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      eventDetailList: eventDetailList ?? this.eventDetailList,
      uiMsg: uiMsg,
    );
  }
}
