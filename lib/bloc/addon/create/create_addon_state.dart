import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/model/menu_custom.dart';

class CreateAddonState {
  final String authToken,
      addonName,
      totalAvailable,
      price,
      description,
      convenienceFee,
      convenienceFeeType,
      privacy;

  String image;
  final DateTime startDate, endDate;
  final bool active, chargeConvenienceFee;
  final List<MenuCustom> addonPrivacyList;
  final List<MenuCustom> addonConvFeeTypeList;

  bool loading;
  bool imageUploadRequired;
  dynamic uiMsg;

  CreateAddonState({
    this.authToken,
    this.addonName,
    this.startDate,
    this.endDate,
    this.totalAvailable,
    this.price,
    this.description,
    this.convenienceFeeType,
    this.convenienceFee,
    this.chargeConvenienceFee,
    this.image,
    this.privacy,
    this.active,
    this.addonConvFeeTypeList,
    this.addonPrivacyList,
    bool loading,
    this.uiMsg,
    this.imageUploadRequired,
  });

  factory CreateAddonState.initial() {
    return CreateAddonState(
      authToken: '',
      addonName: '',
      startDate: null,
      endDate: null,
      totalAvailable: '',
      price: '',
      description: '',
      convenienceFeeType: '',
      convenienceFee: '',
      chargeConvenienceFee: false,
      image: '',
      privacy: '',
      active: true,
      addonConvFeeTypeList: [],
      addonPrivacyList: [],
      loading: false,
      uiMsg: null,
      imageUploadRequired: false,
    );
  }

  factory CreateAddonState.copyWith(
    Addon addon,
    List<MenuCustom> addonConvFeeTypeList,
    List<MenuCustom> addonPrivacyList,
  ) {
    return CreateAddonState(
      authToken: '',
      addonName: addon.name ?? '',
      startDate: addon.startDateTime,
      endDate: addon.endDateTime,
      totalAvailable: addon.quantity?.toString() ?? '',
      price: addon.price?.toString() ?? '',
      description: addon.description ?? '',
      convenienceFeeType: addon.convinenceFeeType ?? '',
      convenienceFee: addon.convenienceFee?.toString() ?? '',
      chargeConvenienceFee: addon.chargeConvinenceFee ?? false,
      image: addon.image ?? '',
      privacy: addon.privacy ?? '',
      active: addon.active ?? true,
      addonConvFeeTypeList: addonConvFeeTypeList,
      addonPrivacyList: addonPrivacyList,
      loading: false,
      uiMsg: null,
      imageUploadRequired: false,
    );
  }

  CreateAddonState copyWith({
    String authToken,
    String addonName,
    String totalAvailable,
    String price,
    String description,
    String convinenceFeeType,
    String convenienceFee,
    String image,
    String privacy,
    List<MenuCustom> addonPrivacyList,
    DateTime startDate,
    DateTime endDate,
    bool active,
    bool chargeConvinenceFee,
    List<MenuCustom> addonConvFeeTypeList,
    bool loading,
    dynamic uiMsg,
    bool imageUploadRequired,
  }) {
    return CreateAddonState(
      authToken: authToken ?? this.authToken,
      addonName: addonName ?? this.addonName,
      totalAvailable: totalAvailable ?? this.totalAvailable,
      price: price ?? this.price,
      description: description ?? this.description,
      convenienceFeeType: convinenceFeeType ?? this.convenienceFeeType,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      image: image ?? this.image,
      privacy: privacy ?? this.privacy,
      addonPrivacyList: addonPrivacyList ?? this.addonPrivacyList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active,
      chargeConvenienceFee: chargeConvinenceFee ?? this.chargeConvenienceFee,
      addonConvFeeTypeList: addonConvFeeTypeList ?? this.addonConvFeeTypeList,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
      imageUploadRequired: imageUploadRequired ?? this.imageUploadRequired,
    );
  }
}
