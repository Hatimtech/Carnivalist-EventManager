import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/gallery/gallery_event.dart';
import 'package:eventmanagement/bloc/event/gallery/gallery_state.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/gallery/gallery_data.dart';
import 'package:eventmanagement/model/event/gallery/gallery_response.dart';
import 'package:eventmanagement/model/event/gallery/media_upload_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final ApiProvider apiProvider = ApiProvider();
  String eventDataId;
  EventData eventDataToUpload;

  GalleryBloc() : super(initialState);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void populateExistingEvent(banner, galleryList) {
    add(PopulateExistingEvent(banner: banner, galleryList: galleryList));
  }

  void addBanner(String banner) {
    add(AddBanner(banner: banner));
  }

  void removeBanner(String banner) {
    add(RemoveBanner(banner: banner));
  }

  void addGalleryItem(GalleryData galleryData) {
    add(AddGalleryItem(galleryData: [galleryData]));
  }

  void addGalleryItems(List<GalleryData> galleryDataList) {
    add(AddGalleryItem(galleryData: List.of(galleryDataList)));
  }

  void removeGalleryItem(GalleryData galleryData) {
    add(RemoveGalleryItem(galleryData: galleryData));
  }

  void compressingVideo(bool compressing) {
    add(CompressingVideo(compressing: compressing));
  }

  void uploadGallery(Function callback) {
    add(UploadGallery(callback: callback));
  }

  static GalleryState get initialState => GalleryState.initial();

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is PopulateExistingEvent) {
      yield state.copyWith(
          banner: event.banner, galleryList: List.of(event.galleryList));
    }

    if (event is AddBanner) {
      print('event.banner ${event.banner}');
      yield state.copyWith(
        banner: event.banner,
        uploadRequired: true,
        bannerUploadRequired: true,
      );
    }

    if (event is RemoveBanner) {
      yield state.copyWith(
        banner: '',
        uploadRequired: true,
      );
    }

    if (event is AddGalleryItem) {
      final galleryList = List.of(state.galleryList);
      galleryList.addAll(event.galleryData);
      yield state.copyWith(
        galleryList: galleryList,
        uploadRequired: true,
      );
    }

    if (event is RemoveGalleryItem) {
      final galleryList = List.of(state.galleryList);
      galleryList
          .removeWhere((galleryData) => galleryData.id == event.galleryData.id);
      yield state.copyWith(
        galleryList: galleryList,
        uploadRequired: true,
      );
    }

    if (event is CompressingVideo) {
      yield state.copyWith(
        loading: event.compressing,
      );
    }

    if (event is UploadGallery) {
      if (!isValid(state.banner)) {
        yield state.copyWith(uiMsg: ERR_GALLERY_BANNER);
        event.callback(ERR_GALLERY_BANNER);
        return;
      }

      if (state.uploadRequired) {
        try {
          if (state.bannerUploadRequired) {
            final networkServiceResponse =
            await apiProvider.uploadMedia(state.authToken, state.banner);
            if (networkServiceResponse.responseCode == ok200) {
              final mediaUploadRes =
              networkServiceResponse.response as MediaUploadResponse;

              if (mediaUploadRes.code == apiCodeSuccess) {
                final newBannerLink = mediaUploadRes.fileLink;
                print('New Banner Link--->$newBannerLink');

                if (isValid(newBannerLink)) {
                  state.bannerUploadRequired = false;

                  await renameFile(state.banner,
                      newBannerLink.substring(newBannerLink.lastIndexOf('/')));

                  state.banner = newBannerLink;
                } else {
                  yield state.copyWith(uiMsg: ERR_SOMETHING_WENT_WRONG);
                  event.callback(ERR_SOMETHING_WENT_WRONG);
                  return;
                }
              } else {
                yield state.copyWith(uiMsg: ERR_SOMETHING_WENT_WRONG);
                event.callback(ERR_SOMETHING_WENT_WRONG);
                return;
              }
            } else {
              yield state.copyWith(
                  uiMsg:
                  networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG);
              event.callback(
                  networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG);
              return;
            }
          }

          for (int galleryCount = 0;
          galleryCount < state.galleryList.length;
          galleryCount++) {
            final galleryData = state.galleryList[galleryCount];
            if (galleryData.uploadRequired) {
              final networkServiceResponse = await apiProvider.uploadMedia(
                  state.authToken, galleryData.localFilePath);
              if (networkServiceResponse.responseCode == ok200) {
                final mediaUploadResponse =
                networkServiceResponse.response as MediaUploadResponse;

                if (mediaUploadResponse.code == apiCodeSuccess) {
                  final newGalleryDataLink =
                  networkServiceResponse.response.fileLink as String;
                  print('New Gallery Data Link--->$newGalleryDataLink');

                  if (isValid(newGalleryDataLink)) {
                    galleryData.uploadRequired = false;

//                if (galleryData.ownedByApp) {
//                  await renameFile(
//                      galleryData.localFilePath,
//                      newGalleryDataLink
//                          .substring(newGalleryDataLink.lastIndexOf('/')));
//                } else {
//                  final copyTo = Path.join(
//                    await getSystemDirPath(),
//                    'Pictures',
//                    newGalleryDataLink
//                        .substring(newGalleryDataLink.lastIndexOf('/')),
//                  );
//                  await copyFile(galleryData.link, copyTo);
//                }

//                if (galleryData.type == 'video') {
//                  final thumbnailFilePath = Path.join(
//                      await getSystemDirPath(),
//                      'Pictures',
//                      '${galleryData.localFilePath.substring(galleryData.localFilePath.lastIndexOf('/') + 1, galleryData.localFilePath.lastIndexOf('.'))}.jpg');
//
//                  print('thumbnailFilePath to rename--->$thumbnailFilePath');
//                  print('rename to--->${newGalleryDataLink.substring(newGalleryDataLink.lastIndexOf('/') + 1, newGalleryDataLink.lastIndexOf('.'))}.jpg');
//                  await renameFile(thumbnailFilePath,
//                      '${newGalleryDataLink.substring(newGalleryDataLink.lastIndexOf('/') + 1, newGalleryDataLink.lastIndexOf('.'))}.jpg');
//                }

                    galleryData.link = newGalleryDataLink;
                  } else {
                    yield state.copyWith(uiMsg: ERR_SOMETHING_WENT_WRONG);
                    event.callback(ERR_SOMETHING_WENT_WRONG);
                    return;
                  }
                } else {
                  yield state.copyWith(uiMsg: ERR_SOMETHING_WENT_WRONG);
                  event.callback(ERR_SOMETHING_WENT_WRONG);
                  return;
                }
              } else {
                yield state.copyWith(
                    uiMsg: networkServiceResponse.error ??
                        ERR_SOMETHING_WENT_WRONG);
                event.callback(networkServiceResponse.error);
                return;
              }
            }
          }

          eventDataToUpload.banner = state.banner;
          eventDataToUpload.gallery = state.galleryList;

          final networkServiceResponse = await apiProvider.createGalleryData(
              state.authToken, eventDataToUpload,
              eventDataId: eventDataId);

          if (networkServiceResponse.responseCode == ok200) {
            var galleryResponse =
            networkServiceResponse.response as GalleryResponse;
            if (galleryResponse.code == apiCodeSuccess) {
              yield state.copyWith(uiMsg: SUCCESS_DATA_SAVED);
              event.callback(galleryResponse);
              state.uploadRequired = false;
            } else {
              yield state.copyWith(
                  uiMsg: galleryResponse.message ?? ERR_SOMETHING_WENT_WRONG);
              event.callback(
                  galleryResponse.message ?? ERR_SOMETHING_WENT_WRONG);
            }
          } else {
            yield state.copyWith(
                uiMsg:
                networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG);
            event.callback(networkServiceResponse.error);
          }
        } catch (error, stack) {
          print('Exception Occured--->$error\n$stack');
          yield state.copyWith(uiMsg: ERR_SOMETHING_WENT_WRONG);
          event.callback(null);
        }
      } else {
        event.callback('Upload not required');
      }
    }
  }
}

Future<String> renameFile(String filePath, String newName) async {
  final existingFile = File(filePath);
  bool exist = await existingFile.exists();
  if (exist) {
    final renameTo = filePath.replaceFirst(
        filePath.substring(filePath.lastIndexOf('/') + 1), newName);
    print('Renaming $filePath to $renameTo');
    existingFile.rename(renameTo);
    return renameTo;
  }
  print('$filePath does not exisit');
  return null;
}

Future<String> copyFile(String filePath, String newPath) async {
  final existingFile = File(filePath);
  bool exist = await existingFile.exists();
  if (exist) {
    print('Copying $filePath to $newPath');
    existingFile.copySync(newPath);
    return newPath;
  }
  print('$filePath does not exisit');
  return null;
}
