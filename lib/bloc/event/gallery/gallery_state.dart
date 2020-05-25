import 'package:eventmanagement/model/event/gallery/gallery_data.dart';
import 'package:meta/meta.dart';

class GalleryState {
  final String authToken;
  String banner;
  List<GalleryData> galleryList;
  bool loading;
  dynamic uiMsg;
  bool uploadRequired;
  bool bannerUploadRequired;

  GalleryState({
    @required this.authToken,
    this.banner,
    this.galleryList,
    this.loading,
    this.uiMsg,
    this.uploadRequired,
    this.bannerUploadRequired,
  });

  factory GalleryState.initial() {
    return GalleryState(
      authToken: "",
      banner: "",
      galleryList: List(),
      loading: false,
      uiMsg: null,
      uploadRequired: false,
      bannerUploadRequired: false,
    );
  }

  GalleryState copyWith({
    bool loading,
    String authToken,
    String banner,
    List<GalleryData> galleryList,
    dynamic uiMsg,
    bool uploadRequired,
    bool bannerUploadRequired,
  }) {
    return GalleryState(
      authToken: authToken ?? this.authToken,
      banner: banner ?? this.banner,
      loading: loading ?? this.loading,
      galleryList: galleryList ?? this.galleryList,
      uiMsg: uiMsg,
      uploadRequired: uploadRequired ?? this.uploadRequired,
      bannerUploadRequired: bannerUploadRequired ?? this.bannerUploadRequired,
    );
  }

  bool isGalleryItemExist(String path) {
    bool exist = false;
    for (GalleryData value in galleryList) {
      if (value.localFilePath == path) {
        exist = true;
        break;
      }
    }
    return exist;
  }
}
