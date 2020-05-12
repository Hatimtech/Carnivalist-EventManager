abstract class CreateAddonEvent {}

class AuthTokenSave extends CreateAddonEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class CreateAddonDefault extends CreateAddonEvent {
  CreateAddonDefault();
}

class AddonPrivacyInput extends CreateAddonEvent {
  final bool privacy;

  AddonPrivacyInput({this.privacy});
}

class AddonNameInput extends CreateAddonEvent {
  final String addonName;

  AddonNameInput({this.addonName});
}

class AddonActiveInput extends CreateAddonEvent {
  final bool active;

  AddonActiveInput({this.active});
}

class AddonStartDateInput extends CreateAddonEvent {
  final DateTime startDateTime;

  AddonStartDateInput({this.startDateTime});
}

class AddonEndDateInput extends CreateAddonEvent {
  final DateTime endDateTime;

  AddonEndDateInput({this.endDateTime});
}

class TotalAvailableInput extends CreateAddonEvent {
  final String totalAvailable;

  TotalAvailableInput({this.totalAvailable});
}

class AddonPriceInput extends CreateAddonEvent {
  final String addonPrice;

  AddonPriceInput({this.addonPrice});
}

class AddonDescriptionInput extends CreateAddonEvent {
  final String description;

  AddonDescriptionInput({this.description});
}

class AddonConvenienceFeeTypeInput extends CreateAddonEvent {
  final String convenienceFeeType;

  AddonConvenienceFeeTypeInput({this.convenienceFeeType});
}

class AddonConvenienceFeeInput extends CreateAddonEvent {
  final String convenienceFee;

  AddonConvenienceFeeInput({this.convenienceFee});
}

class ChargeConvenienceFeeInput extends CreateAddonEvent {
  final bool charge;

  ChargeConvenienceFeeInput({this.charge});
}

class AddonImageInput extends CreateAddonEvent {
  final String image;

  AddonImageInput({this.image});
}

class UploadAddon extends CreateAddonEvent {
  Function callback;

  UploadAddon({this.callback});
}

class UploadAddonResult extends CreateAddonEvent {
  final bool success;
  final dynamic uiMsg;

  UploadAddonResult(this.success, {this.uiMsg});
}
