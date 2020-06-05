import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/model/addons/addon_response.dart';
import 'package:eventmanagement/model/event/gallery/media_upload_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'create_addon_event.dart';
import 'create_addon_state.dart';

class CreateAddonBloc extends Bloc<CreateAddonEvent, CreateAddonState> {
  final ApiProvider apiProvider = ApiProvider();
  final AddonBloc addonBloc;
  final String addonId;

  CreateAddonBloc(this.addonBloc, {this.addonId});

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void createAddonDefault() {
    add(CreateAddonDefault());
  }

  void addonPrivacyInput(privacy) {
    add(AddonPrivacyInput(privacy: privacy));
  }

  void addonNameInput(addonName) {
    add(AddonNameInput(addonName: addonName));
  }

  void startDateTimeInput(startDateTime) {
    add(AddonStartDateInput(startDateTime: startDateTime));
  }

  void endDateTimeInput(endDateTime) {
    add(AddonEndDateInput(endDateTime: endDateTime));
  }

  void totalAvailableInput(totalAvailable) {
    add(TotalAvailableInput(totalAvailable: totalAvailable));
  }

  void priceInput(addonPrice) {
    add(AddonPriceInput(addonPrice: addonPrice));
  }

  void descriptionInput(addonDescription) {
    add(AddonDescriptionInput(description: addonDescription));
  }

  void convenienceFeeTypeInput(convenienceFeeType) {
    add(AddonConvenienceFeeTypeInput(convenienceFeeType: convenienceFeeType));
  }

  void convenienceFeeInput(convenienceFee) {
    add(AddonConvenienceFeeInput(convenienceFee: convenienceFee));
  }

  void chargeConvenienceFeeInput(charge) {
    add(ChargeConvenienceFeeInput(charge: charge));
  }

  void imageInput(image) {
    add(AddonImageInput(image: image));
  }

  void activeInput(active) {
    add(AddonActiveInput(active: active));
  }

  void uploadNewAddon(callback) {
    add(UploadAddon(callback: callback));
  }

  @override
  CreateAddonState get initialState {
    if (addonId == null)
      return CreateAddonState.initial();
    else {
      final addConvFeeTypeList = getAddonConvFeeType();
      final addonPrivacyList = getAddonPrivacy();
      final addon =
          addonBloc.state.addonList.firstWhere((addon) => addon.id == addonId);
      return CreateAddonState.copyWith(
          addon, addConvFeeTypeList, addonPrivacyList);
    }
  }

  @override
  Stream<CreateAddonState> mapEventToState(CreateAddonEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is CreateAddonDefault && addonId == null) {
      final addConvFeeTypeList = getAddonConvFeeType();
      final addonPrivacyList = getAddonPrivacy();
      yield state.copyWith(
          addonConvFeeTypeList: addConvFeeTypeList,
          convinenceFeeType: addConvFeeTypeList[0].name,
          addonPrivacyList: addonPrivacyList,
          privacy: addonPrivacyList[1].name);
    }

    if (event is AddonPrivacyInput) {
      yield state.copyWith(
          privacy: event.privacy
              ? state.addonPrivacyList[1].name
              : state.addonPrivacyList[0].name);
    }

    if (event is AddonNameInput) {
      yield state.copyWith(addonName: event.addonName);
    }

    if (event is AddonActiveInput) {
      yield state.copyWith(active: event.active);
    }

    if (event is AddonStartDateInput) {
      final saleStartDate = event.startDateTime;
      yield state.copyWith(
          startDate: DateTime(
              saleStartDate.year, saleStartDate.month, saleStartDate.day));
    }

    if (event is AddonEndDateInput) {
      final saleEndDate = event.endDateTime;
      yield state.copyWith(
          endDate:
              DateTime(saleEndDate.year, saleEndDate.month, saleEndDate.day));
    }

    if (event is TotalAvailableInput) {
      yield state.copyWith(totalAvailable: event.totalAvailable);
    }

    if (event is AddonPriceInput) {
      yield state.copyWith(price: event.addonPrice);
    }

    if (event is AddonDescriptionInput) {
      yield state.copyWith(description: event.description);
    }

    if (event is AddonConvenienceFeeTypeInput) {
      yield state.copyWith(convinenceFeeType: event.convenienceFeeType);
    }

    if (event is AddonConvenienceFeeInput) {
      yield state.copyWith(convenienceFee: event.convenienceFee);
    }

    if (event is AddonImageInput) {
      yield state.copyWith(
        image: event.image,
        imageUploadRequired: true,
      );
    }

    if (event is ChargeConvenienceFeeInput) {
      yield state.copyWith(chargeConvinenceFee: event.charge);
    }

    if (event is UploadAddon) {
      yield* uploadAddon(event);
    }

    if (event is UploadAddonResult) {
      yield state.copyWith(
        loading: false,
        uiMsg: event.uiMsg,
      );
    }
  }

  Stream<CreateAddonState> uploadAddon(UploadAddon event) async* {
    int errorCode = validateAddonData();
    if (errorCode > 0) {
      yield state.copyWith(uiMsg: errorCode);
      event.callback(null);
      return;
    }
    yield state.copyWith(loading: true);

    if (state.imageUploadRequired) {
      apiProvider
          .uploadMedia(state.authToken, state.image)
          .then((networkServiceResponse) async {
        if (networkServiceResponse.responseCode == ok200) {
          final mediaUploadRes =
              networkServiceResponse.response as MediaUploadResponse;

          if (mediaUploadRes.code == apiCodeSuccess) {
            final serverImageLink = mediaUploadRes.fileLink;
            print('Uploaded Image Link--->$serverImageLink');

            if (isValid(serverImageLink)) {
              state.imageUploadRequired = false;
              await renameFile(state.image,
                  serverImageLink.substring(serverImageLink.lastIndexOf('/')));
              state.image = serverImageLink;
              uploadAddonJson(event);
            }
          } else {
            add(UploadAddonResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
            event.callback(ERR_SOMETHING_WENT_WRONG);
          }
        } else {
          add(UploadAddonResult(false,
              uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(
              networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG);
        }
      });
    } else {
      uploadAddonJson(event);
    }
  }

  void uploadAddonJson(UploadAddon event) {
    final addon = Addon(
      id: addonId,
      name: state.addonName,
      active: state.active,
      startDateTime: state.startDate?.toUtc(),
      endDateTime: state.endDate?.toUtc(),
      quantity: int.tryParse(state.totalAvailable) ?? 0,
      price: double.tryParse(state.price) ?? 0.0,
      currency: 'USD',
      gst: '',
      chargeConvinenceFee: state.chargeConvenienceFee,
      convinenceFeeType: state.convenienceFeeType,
      convenienceFee: double.tryParse(state.convenienceFee) ?? 0,
      description: state.description,
      image: state.image,
      privacy: state.privacy,
    );

    apiProvider
        .uploadAddon(state.authToken, addon)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var addonResponse = networkServiceResponse.response as AddonResponse;
        if (addonResponse.code == apiCodeSuccess) {
          if (addonId != null) {
            addonBloc.updateAddon(addon);
          } else {
            if (addonResponse.addons != null)
              addonBloc.addAddon(addonResponse.addons);
          }
          add(UploadAddonResult(true));
          event.callback(addonResponse);
        } else {
          add(UploadAddonResult(false,
              uiMsg: addonResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(addonResponse.message);
        }
      } else {
        add(UploadAddonResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in uploadAddon--->$error');
      add(UploadAddonResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(error);
    });
  }

  int validateAddonData() {
    if (!isValid(state.addonName)) return ERR_ADDON_NAME;
    if (state.startDate == null) return ERR_ADDON_START_DATE;
    if (state.endDate == null) return ERR_ADDON_END_DATE;
    if (state.startDate.isAfter(state.endDate))
      return ERR_ADDON_START_DATE_AFTER;
    if (!isValid(state.totalAvailable)) return ERR_ADDON_TOTAL_AVA;
    if (!isValid(state.price)) return ERR_ADDON_PRICE;
    if (!isValid(state.description)) return ERR_ADDON_DESCRIPTION;

//    if (state.chargeConvenienceFee ?? false) {
//      if (!isValid(state.convenienceFeeType)) return ERR_ADDON_CONV_FEE_TYPE;
//      if (!isValid(state.convenienceFee)) return ERR_ADDON_CONV_FEE;
//    }
    if (!isValid(state.image)) return ERR_ADDON_IMAGE;

    return 0;
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
}
