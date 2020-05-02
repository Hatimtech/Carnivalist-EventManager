class GalleryData {
  String link;
  String type;

  GalleryData.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.link != null) data['link'] = this.link;
    if (this.type != null) data['type'] = this.type;
    return data;
  }
}
