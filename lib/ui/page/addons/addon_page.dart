import 'dart:async';
import 'dart:io';

import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/bloc/addon/addon_state.dart';
import 'package:eventmanagement/bloc/addon/create/create_addon_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/ui/page/addons/create_addon_dialog.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as Path;

class AddonPage extends StatefulWidget {
  final bool allowRefresh, allowCreate, allowAction, enableSelection;

  const AddonPage({
    Key key,
    this.allowRefresh = true,
    this.allowCreate = true,
    this.allowAction = true,
    this.enableSelection = false,
  }) : super(key: key);

  @override
  createState() => _AddonState();
}

class _AddonState extends State<AddonPage> with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;
  AddonBloc _addonBloc;
  Future _futureSystemPath;

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hideFabAnimation = AnimationController(
        vsync: this, duration: kThemeAnimationDuration, value: 1.0);
    _addonBloc = BlocProvider.of<AddonBloc>(context);
    _futureSystemPath = getSystemDirPath();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (_hideFabAnimation.value == 0.0) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (_hideFabAnimation.value == 1.0) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.allowCreate
          ? ScaleTransition(
        scale: _hideFabAnimation,
        child: FloatingActionButton(
          heroTag: "FAB",
          backgroundColor: bgColorFAB,
          onPressed: _onCreateAddonButtonPressed,
          child: Icon(
            Icons.add,
            size: 48.0,
          ),
              ),
            )
          : null,
      body: NotificationListener(
        onNotification: _handleScrollNotification,
        child: Column(children: <Widget>[
          _buildErrorReceiverEmptyBloc(),
          _buildAddonTypeRadioButton(),
          Expanded(
              child: BlocBuilder<AddonBloc, AddonState>(
                  bloc: _addonBloc,
                  condition: (prevState, newState) {
                    return (prevState.loading != newState.loading) ||
                        (prevState.showPublic != newState.showPublic) ||
                        (prevState.addonList != newState.addonList ||
                            prevState.addonList.length !=
                                newState.addonList.length);
                  },
                  builder: (context, AddonState state) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        addonList(state.addonListByType),
                        if (state.loading) const PlatformProgressIndicator(),
                      ],
                    );
                  })),
        ]),
      ),
    );
  }

  Widget _buildErrorReceiverEmptyBloc() => BlocBuilder<AddonBloc, AddonState>(
        bloc: _addonBloc,
        condition: (prevState, newState) => newState.uiMsg != null,
        builder: (context, state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            context.toast(errorMsg);

            state.uiMsg = null;
          }

          return SizedBox.shrink();
        },
      );

  Widget _buildAddonTypeRadioButton() => Container(
        decoration: BoxDecoration(
          color: bgColorButton,
          border: Border.all(
            color: bgColorButton,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        constraints: BoxConstraints(maxWidth: 208.0),
        margin: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: BlocBuilder<AddonBloc, AddonState>(
            bloc: _addonBloc,
            condition: (prevState, newState) =>
                prevState.showPublic != newState.showPublic,
            builder: (_, state) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _addonBloc.addonTypeInput(true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            AppLocalizations.of(context).labelAddonTypePublic,
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: state.showPublic
                                ? colorTextButton
                                : bgColorButton,
                            borderRadius: BorderRadius.all(
                                Radius.circular(state.showPublic ? 8.0 : 0.0))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _addonBloc.addonTypeInput(false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            AppLocalizations.of(context).labelAddonTypePrivate,
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: state.showPublic
                                ? bgColorButton
                                : colorTextButton,
                            borderRadius: BorderRadius.all(
                                Radius.circular(state.showPublic ? 0.0 : 4.0))),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

  addonList(List<Addon> addonList) => FutureBuilder(
        future: _futureSystemPath,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const SizedBox.shrink()
              : PlatformScrollbar(
                  child: widget.allowRefresh
                      ? RefreshIndicator(
                          onRefresh: () async {
                            Completer<bool> downloadCompleter = Completer();
                            _addonBloc.getAllAddons(
                                downloadCompleter: downloadCompleter);
                            return downloadCompleter.future;
                          },
                          child: _buildAddonList(addonList, snapshot.data),
                        )
                      : _buildAddonList(addonList, snapshot.data),
                );
        },
      );

  Widget _buildAddonList(List<Addon> addonList, String systemPath) {
    return ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: addonList.length,
        itemBuilder: (context, position) {
          Addon currentAddon = addonList[position];
          return GestureDetector(
            onTap: () {
              if (widget.allowAction) {
                showAddonActions(currentAddon);
              } else if (widget.enableSelection) {
                _addonBloc.addonSelectionChange(currentAddon.id);
              }
            },
            child: widget.enableSelection
                ? BlocBuilder<AddonBloc, AddonState>(
              bloc: _addonBloc,
              condition: (prevState, newState) {
                final newStateAddon = newState.addonList
                    .firstWhere((addon) => addon.id == currentAddon.id);
                final isChanged =
                    currentAddon.isSelected != newStateAddon.isSelected;
                if (isChanged) currentAddon = newStateAddon;
                return isChanged;
              },
              builder: (_, state) {
                final addon = state.addonList
                    .firstWhere((addon) => addon.id == currentAddon.id);
                return _buildAddonListItem(addon, systemPath);
              },
            )
                : _buildAddonListItem(addonList[position], systemPath),
          );
        });
  }

  Widget _buildAddonListItem(Addon addon, String systemPath) {
    return Container(
      color: (addon.isSelected ?? false) ? bgColorSelection : null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 72.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VerticalDivider(
                thickness: 6,
                width: 6,
                color: addon.active && addon.endDateTime.isAfter(DateTime.now())
                    ? colorActive
                    : colorInactive,
              ),
              const SizedBox(width: 8.0),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildAddonImage(addon.image, systemPath),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildNameAndQuantityView(
                      addon.name, addon.quantity, addon.convenienceFee),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: _buildPriceAndDateView(
                    addon.currency, addon.price, addon.endDateTime),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddonImage(String url, String systemPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: FadeInImage(
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        placeholder: AssetImage(placeholderImage),
        image: NetworkToFileImage(
          url: url,
          file: File(Path.join(
              systemPath, 'Pictures', url.substring(url.lastIndexOf('/') + 1))),
          debug: true,
        ),
      ),
    );
  }

  Widget _buildNameAndQuantityView(
      String addonName, int quantity, double convenienceFee) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            addonName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            '${AppLocalizations.of(context).labelAddonQuanity} ${quantity ?? 0}   ${AppLocalizations.of(context).labelAddonConvFeeView} ${convenienceFee ?? 0}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontSize: 12.0,
                ),
          )
        ]);
  }

  Widget _buildPriceAndDateView(String currency, double price,
      DateTime saleEnd) {
    final currencyFormat = price != null
        ? NumberFormat.simpleCurrency(
        name: isValid(currency) ? currency : 'USD',
        decimalDigits: (price?.isInt ?? false) ? 0 : null)
        : null;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 2),
          Text(
            price != null ? '${currencyFormat.format(price)}' : '--',
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: colorTextBody1),
          ),
          Text(AppLocalizations.of(context).labelAddonSaleEnd,
              style: Theme.of(context).textTheme.body2),
          Text(saleEnd != null ? DateFormat.yMMMd().format(saleEnd) : '--',
              style: Theme.of(context).textTheme.body2)
        ]);
  }

  Future<void> showAddonActions(Addon addon) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _buildMaterialAddonActionSheet(addon);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoAddonActionSheet(addon),
      );
    }
  }

  Widget _buildMaterialAddonActionSheet(Addon addon) => ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildMaterialFieldAction(
              AppLocalizations.of(context).labelEditAddon, addon, editAddon,
              showDivider: false),
        ],
      );

  Widget _buildMaterialFieldAction(String name, Addon addon, Function handler,
      {bool showDivider = true}) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler(addon);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              child: Text(
                name,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: colorTextAction,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (showDivider) const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoAddonActionSheet(Addon addon) {
    return CupertinoActionSheet(
      actions: [
        _buildCupertinoAddonAction(
            AppLocalizations.of(context).labelEditAddon, addon, editAddon),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          AppLocalizations.of(context).btnCancel,
          style: Theme.of(context).textTheme.title.copyWith(
                color: colorTextAction,
                fontWeight: FontWeight.bold,
              ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildCupertinoAddonAction(
      String name, Addon addon, Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler(addon);
      },
      child: Text(
        name,
        style: Theme.of(context).textTheme.subtitle.copyWith(
              color: colorTextAction,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void editAddon(Addon addon) {
    _onCreateAddonButtonPressed(addonId: addon.id);
  }

  Future<void> _onCreateAddonButtonPressed({String addonId}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => BlocProvider(
        create: (context) => CreateAddonBloc(
          _addonBloc,
          addonId: addonId,
        ),
        child: CreateAddonDialog(),
      ),
    );
  }
}
