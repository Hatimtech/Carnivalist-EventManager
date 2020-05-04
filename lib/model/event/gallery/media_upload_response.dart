class MediaUploadResponse {
  int code;
  String fileLink;

  MediaUploadResponse({this.code, this.fileLink});

  MediaUploadResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    fileLink = json['fileLink'];
  }
}
