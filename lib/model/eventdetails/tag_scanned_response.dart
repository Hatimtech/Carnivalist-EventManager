class TagScannedResponse {
  int code;
  String message;
  String eventDetailId;

  TagScannedResponse({this.code, this.message, this.eventDetailId});

  TagScannedResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    eventDetailId = json['order'] != null ? json['order']['_id'] : null;
  }
}
