class GalleryData {
  String id;
  String link;
  String localFilePath;
  String type;
  bool uploadRequired;
  bool ownedByApp;

  GalleryData(
      {this.id, this.link, this.localFilePath = '', this.type, this.uploadRequired, this.ownedByApp});

  GalleryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    localFilePath = json['localFilePath'];
    type = json['type'];
    uploadRequired = json['uploadRequired'] ?? false;
    ownedByApp = json['ownedByApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.link != null) data['link'] = this.link;
    if (this.type != null) data['type'] = this.type;
    return data;
  }
}
