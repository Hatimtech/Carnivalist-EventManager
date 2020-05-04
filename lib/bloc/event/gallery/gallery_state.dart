import 'package:eventmanagement/model/event/gallery/gallery_data.dart';
import 'package:meta/meta.dart';

class GalleryState {
  final String authToken;
  String banner;
  List<GalleryData> galleryList;
  bool loading;
  int errorCode;
  String toastMsg;
  bool uploadRequired;
  bool bannerUploadRequired;

  GalleryState({
    @required this.authToken,
    this.banner,
    this.galleryList,
    this.loading,
    this.errorCode,
    this.toastMsg,
    this.uploadRequired,
    this.bannerUploadRequired,
  });

  factory GalleryState.initial() {
    return GalleryState(
      authToken: "",
      banner: "",
      galleryList: List(),
      loading: false,
      errorCode: null,
      toastMsg: null,
      uploadRequired: false,
      bannerUploadRequired: false,
    );
  }

  GalleryState copyWith({
    bool loading,
    String authToken,
    String banner,
    List<GalleryData> galleryList,
    int errorCode = null,
    String toastMsg = null,
    bool uploadRequired,
    bool bannerUploadRequired,
  }) {
    return GalleryState(
      authToken: authToken ?? this.authToken,
      banner: banner ?? this.banner,
      loading: loading ?? this.loading,
      galleryList: galleryList ?? this.galleryList,
      errorCode: errorCode,
      toastMsg: toastMsg,
      uploadRequired: uploadRequired ?? this.uploadRequired,
      bannerUploadRequired: bannerUploadRequired ?? this.bannerUploadRequired,
    );
  }
}
