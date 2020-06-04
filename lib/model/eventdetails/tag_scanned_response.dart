class TagScannedResponse {
  int code;
  String message;
  String eventDetailId;

  TagScannedResponse({this.code, this.message, this.eventDetailId});

  TagScannedResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    eventDetailId =
    json['orderData'] != null ? json['orderData']['_id'] : null;
  }
}
