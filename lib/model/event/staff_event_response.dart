import 'package:eventmanagement/model/event/event_data.dart';

class StaffEventResponse {
  int code;
  List<EventData> events;

  StaffEventResponse({this.code, this.events});

  StaffEventResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    events = json['events'] != null
        ? (json['events']['selectedEvents'] as List)
            ?.map((e) => EventData.fromJson(e))
            ?.toList()
        : null;
  }
}
