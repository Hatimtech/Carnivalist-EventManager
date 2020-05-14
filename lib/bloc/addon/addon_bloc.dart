import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/addon/addon_event.dart';
import 'package:eventmanagement/bloc/addon/addon_state.dart';
import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class AddonBloc extends Bloc<AddonEvent, AddonState> {
  final ApiProvider apiProvider = ApiProvider();
  final bool assigning;
  final List<String> addonIds = [];

  AddonBloc({this.assigning = false});

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void previousAddonSelection(addonIds) {
    this.addonIds.clear();
    this.addonIds.addAll(addonIds);
  }

  void addonTypeInput(bool showPublic) {
    add(AddonTypeInput(showPublic: showPublic));
  }

  void getAllAddons({Completer<bool> downloadCompleter}) {
    add(GetAllAddons(downloadCompleter: downloadCompleter));
  }

  void addAddon(Addon addon) {
    add(AddAddon(addon));
  }

  void updateAddon(Addon addon) {
    add(UpdateAddon(addon));
  }

  void deleteAddon(String id) {
    add(DeleteAddon(id));
  }

  void addonSelectionChange(String addonId) {
    add(AddonSelectionChange(addonId: addonId));
  }

  @override
  AddonState get initialState => AddonState.initial();

  @override
  Stream<AddonState> mapEventToState(AddonEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is AddonTypeInput) {
      yield state.copyWith(showPublic: event.showPublic);
    }

    if (event is GetAllAddons) {
      if (event.downloadCompleter == null) yield state.copyWith(loading: true);
      getAllAddonsApi(event);
    }

    if (event is AddonListAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        addonList: event.success ? event.addonList : null,
      );
    }

    if (event is AddAddon) {
      state.addonList.add(event.addon);
      yield state.copyWith(
        addonList: List.of(state.addonList),
      );
    }

    if (event is UpdateAddon) {
      int removeIndex =
          state.addonList.indexWhere((addon) => addon.id == event.addon.id);
      state.addonList.removeAt(removeIndex);
      state.addonList.insert(removeIndex, event.addon);
      yield state.copyWith(
        addonList: List.of(state.addonList),
      );
    }

    if (event is AddonSelectionChange) {
      final currentAddonIndex = state.addonList.indexWhere((addon) {
        return addon.id == event.addonId;
      });
      final newAddon =
          Addon.fromJson(state.addonList[currentAddonIndex].toJson());
      newAddon.isSelected = !(newAddon.isSelected ?? false);

      if (newAddon.isSelected) {
        addonIds.add(newAddon.id);
      } else {
        addonIds.remove(newAddon.id);
      }
      yield state.copyWith(
        addonList: state.addonList
          ..removeAt(currentAddonIndex)
          ..insert(currentAddonIndex, newAddon),
      );
    }
  }

  void getAllAddonsApi(GetAllAddons event) {
    apiProvider
        .getAllAddons(state.authToken, assigning)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var addonList = networkServiceResponse.response as List<Addon>;
        if (addonList != null) {
          if (assigning)
            addonList.forEach((addon) {
              if (addonIds.contains(addon.id)) addon.isSelected = true;
            });
          add(AddonListAvailable(true, addonList: addonList));
        }
      } else {
        add(AddonListAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
      if (event.downloadCompleter != null)
        event.downloadCompleter.complete(true);
    }).catchError((error) {
      print('Error in getAllAddonsApi--->$error');
      add(AddonListAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      if (event.downloadCompleter != null)
        event.downloadCompleter.complete(false);
    });
  }
}
