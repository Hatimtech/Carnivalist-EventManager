import 'package:eventmanagement/model/event/event_data.dart';

class EventResponse {
  int code;
  List<EventData> events;

  EventResponse({this.code, this.events});

  EventResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    events =
        (json['events'] as List)?.map((e) => EventData.fromJson(e))?.toList();
  }
}
