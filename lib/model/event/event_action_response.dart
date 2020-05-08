class EventActionResponse {
  int code;
  String message;

  EventActionResponse({this.code, this.message});

  EventActionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
