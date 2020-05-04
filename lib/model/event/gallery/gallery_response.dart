class GalleryResponse {
  int code;
  String message;

  GalleryResponse({this.code, this.message});

  GalleryResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
