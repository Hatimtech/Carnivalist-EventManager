import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/gallery/gallery_event.dart';
import 'package:eventmanagement/bloc/event/gallery/gallery_state.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/gallery/gallery_data.dart';
import 'package:eventmanagement/model/event/gallery/gallery_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final ApiProvider apiProvider = ApiProvider();
  final BasicBloc basicBloc;

  GalleryBloc(this.basicBloc);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void addBanner(String banner) {
    add(AddBanner(banner: banner));
  }

  void removeBanner(String banner) {
    add(RemoveBanner(banner: banner));
  }

  void addGalleryItem(GalleryData galleryData) {
    add(AddGalleryItem(galleryData: galleryData));
  }

  void removeGalleryItem(GalleryData galleryData) {
    add(RemoveGalleryItem(galleryData: galleryData));
  }

  void uploadGallery(Function callback) {
    add(UploadGallery(callback: callback));
  }

  @override
  GalleryState get initialState => GalleryState.initial();

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
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
      galleryList.add(event.galleryData);
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

    if (event is UploadGallery) {
      if (state.uploadRequired) {
        try {
          if (state.bannerUploadRequired) {
            await apiProvider.uploadMedia(state.authToken, state.banner);
            if (apiProvider.apiResult.responseCode == ok200) {
              final newBannerLink =
              apiProvider.apiResult.response.fileLink as String;
              print('New Banner Link--->$newBannerLink');

              if (isValid(newBannerLink)) {
                state.bannerUploadRequired = false;

                await renameFile(state.banner,
                    newBannerLink.substring(newBannerLink.lastIndexOf('/')));

                state.banner = newBannerLink;
              }
            } else {
              event.callback(apiProvider.apiResult.errorMessage);
            }
          }

          for (int galleryCount = 0;
          galleryCount < state.galleryList.length;
          galleryCount++) {
            final galleryData = state.galleryList[galleryCount];
            if (galleryData.uploadRequired) {
              await apiProvider.uploadMedia(
                  state.authToken, galleryData.localFilePath);
              if (apiProvider.apiResult.responseCode == ok200) {
                final newGalleryDataLink =
                apiProvider.apiResult.response.fileLink as String;
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
                }
              } else {
                event.callback(apiProvider.apiResult.errorMessage);
              }
            }
          }

          EventData eventDataToUpload = basicBloc.eventDataToUpload;
          eventDataToUpload.banner = state.banner;
          eventDataToUpload.gallery = state.galleryList;

          await apiProvider.createGalleryData(
              state.authToken, eventDataToUpload,
              eventDataId: basicBloc.eventDataId);

          if (apiProvider.apiResult.responseCode == ok200) {
            var galleryResponse =
            apiProvider.apiResult.response as GalleryResponse;
            event.callback(galleryResponse);
            state.uploadRequired = false;
          } else {
            event.callback(apiProvider.apiResult.errorMessage);
          }
        } catch (error) {
          print('Exception Occured--->$error');
          yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
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
