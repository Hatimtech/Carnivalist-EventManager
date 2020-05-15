class EventDetailActionResponse {
  int code;
  String message;

  EventDetailActionResponse({this.code, this.message});

  EventDetailActionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
