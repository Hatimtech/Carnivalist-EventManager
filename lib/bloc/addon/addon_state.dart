import 'package:eventmanagement/model/addons/addon.dart';

class AddonState {
  final String authToken;
  final bool showPublic;
  final List<Addon> addonList;
  bool loading;
  dynamic uiMsg;

  AddonState({
    this.authToken,
    this.showPublic,
    this.addonList,
    this.loading,
    this.uiMsg,
  });

  factory AddonState.initial() {
    return AddonState(
      authToken: "",
      showPublic: true,
      addonList: List(),
      loading: false,
      uiMsg: null,
    );
  }

  AddonState copyWith({
    bool loading,
    String authToken,
    bool showPublic,
    List<Addon> addonList,
    dynamic uiMsg,
  }) {
    return AddonState(
      authToken: authToken ?? this.authToken,
      showPublic: showPublic ?? this.showPublic,
      loading: loading ?? this.loading,
      addonList: addonList ?? this.addonList,
      uiMsg: uiMsg,
    );
  }

  List<Addon> get addonListByType {
    String privacy = showPublic ? 'PUBLIC' : 'PRIVATE';
    return addonList.where((addon) => addon.privacy == privacy).toList();
  }
}
