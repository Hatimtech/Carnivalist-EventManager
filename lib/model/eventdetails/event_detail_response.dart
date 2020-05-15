import 'package:eventmanagement/model/eventdetails/event_detail.dart';

class EventDetailResponse {
  int code;
  List<EventDetail> reports;
  String message;

  EventDetailResponse({this.code, this.reports});

  EventDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    reports = (json['reports'] as List)
        ?.map((e) => EventDetail.fromJson(e))
        ?.toList();
    message = json['message'];
  }
}
