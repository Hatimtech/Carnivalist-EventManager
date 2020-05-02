class BasicResponse {

  String id;
  int code;
  String message;

  BasicResponse({this.code, this.message});

  BasicResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    message = json['message'];
  }
}
