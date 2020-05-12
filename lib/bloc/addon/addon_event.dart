import 'dart:async';

import 'package:eventmanagement/model/addons/addon.dart';

abstract class AddonEvent {}

class AuthTokenSave extends AddonEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class PreviousAddonSelection extends AddonEvent {
  final List<String> addonIds;

  PreviousAddonSelection({this.addonIds});
}

class AddonTypeInput extends AddonEvent {
  final bool showPublic;

  AddonTypeInput({this.showPublic});
}

class AddAddon extends AddonEvent {
  final Addon addon;

  AddAddon(this.addon);
}

class UpdateAddon extends AddonEvent {
  final Addon addon;

  UpdateAddon(this.addon);
}

class DeleteAddon extends AddonEvent {
  final String id;

  DeleteAddon(this.id);
}

class GetAllAddons extends AddonEvent {
  Completer<bool> downloadCompleter;

  GetAllAddons({this.downloadCompleter});
}

class AddonSelectionChange extends AddonEvent {
  final String addonId;

  AddonSelectionChange({this.addonId});
}

class AddonListAvailable extends AddonEvent {
  final bool success;
  final dynamic error;
  final List<Addon> addonList;

  AddonListAvailable(this.success, {this.error, this.addonList});
}
