class SettingResponse {
  int code;
  String message;
  bool isUpdating = false;

  SettingResponse({this.code, this.message});

  SettingResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
