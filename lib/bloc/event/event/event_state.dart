import 'package:eventmanagement/model/event/event_data.dart';

class EventState {
  final String authToken;
  final List<EventData> eventDataList;
  final bool loading;
  int errorCode;

  EventState({
    this.authToken,
    this.eventDataList,
    this.loading,
    this.errorCode,
  });

  factory EventState.initial() {
    return EventState(
      authToken: '',
      eventDataList: [],
      loading: false,
      errorCode: null,
    );
  }

  EventState copyWith({
    String authToken,
    List<EventData> eventDataList,
    bool loading,
    int errorCode,
  }) {
    return EventState(
      authToken: authToken ?? this.authToken,
      eventDataList: eventDataList ?? this.eventDataList,
      loading: loading ?? this.loading,
      errorCode: errorCode,
    );
  }
}
