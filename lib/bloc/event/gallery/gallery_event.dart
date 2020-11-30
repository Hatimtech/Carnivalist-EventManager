import 'package:eventmanagement/model/event/gallery/gallery_data.dart';

abstract class GalleryEvent {}

class AuthTokenSave extends GalleryEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class PopulateExistingEvent extends GalleryEvent {
  String banner;
  final List<GalleryData> galleryList;

  PopulateExistingEvent({this.banner, this.galleryList});
}

class AddBanner extends GalleryEvent {
  final String banner;

  AddBanner({this.banner});
}

class RemoveBanner extends GalleryEvent {
  final String banner;

  RemoveBanner({this.banner});
}

class AddGalleryItem extends GalleryEvent {
  final List<GalleryData> galleryData;

  AddGalleryItem({this.galleryData});
}

class RemoveGalleryItem extends GalleryEvent {
  final GalleryData galleryData;

  RemoveGalleryItem({this.galleryData});
}

class CompressingVideo extends GalleryEvent {
  final bool compressing;

  CompressingVideo({this.compressing});
}

class UploadGallery extends GalleryEvent {
  final Function callback;

  UploadGallery({this.callback});
}
