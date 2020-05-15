import 'dart:async';

import 'package:eventmanagement/bloc/coupon/coupon_bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_state.dart';
import 'package:eventmanagement/bloc/coupon/create/create_coupon_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/ui/page/coupons/create_coupon_dialog.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key key}) : super(key: key);

  @override
  createState() => _CouponState();
}

class _CouponState extends State<CouponPage> {
  CouponBloc _couponBloc;

  @override
  void initState() {
    super.initState();
    _couponBloc = BlocProvider.of<CouponBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "FAB",
        backgroundColor: bgColorFAB,
        onPressed: showCouponCreateActions,
        child: Icon(
          Icons.add,
          size: 48.0,
        ),
      ),
      body: Column(children: <Widget>[
        _buildErrorReceiverEmptyBloc(),
        Expanded(
            child: BlocBuilder<CouponBloc, CouponState>(
                bloc: _couponBloc,
                condition: (prevState, newState) {
                  return (prevState.loading != newState.loading) ||
                      (prevState.couponList != newState.couponList ||
                          prevState.couponList.length !=
                              newState.couponList.length);
                },
                builder: (context, CouponState state) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      couponList(state.couponList),
                      if (state.loading) const PlatformProgressIndicator(),
                    ],
                  );
                })),
      ]),
    );
  }

  Widget _buildErrorReceiverEmptyBloc() => BlocBuilder<CouponBloc, CouponState>(
        bloc: _couponBloc,
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

  couponList(List<Coupon> couponList) => PlatformScrollbar(
        child: RefreshIndicator(
          onRefresh: () async {
            Completer<bool> downloadCompleter = Completer();
            _couponBloc.getAllCoupons(downloadCompleter: downloadCompleter);
            return downloadCompleter.future;
          },
          child: _buildCouponList(couponList),
        ),
      );

  Widget _buildCouponList(List<Coupon> couponList) {
    return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemCount: couponList.length,
        itemBuilder: (context, position) {
          Coupon currentCoupon = couponList[position];
          return GestureDetector(
            onTap: () {
              showCouponActions(currentCoupon);
            },
            child: _buildCouponListItem(couponList[position]),
          );
        });
  }

  Widget _buildCouponListItem(Coupon coupon) {
    final couponParams = coupon.couponParameters;
    return couponParams != null
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _buildNameAndQuantityView(
                      couponParams.discountName ?? '--',
                      coupon.couponType ?? '--',
                      couponParams.noOfDiscount ?? 0,
                    ),
                  ),
                  _buildPriceAndDateView(
                    couponParams.discountType == 'amount'
                        ? couponParams.discountValue != null
                            ? '\$${couponParams.discountValue}'
                            : '--'
                        : couponParams.discountValue != null
                            ? '${couponParams.discountValue}%'
                            : '--',
                    couponParams.endDateTime,
                  ),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildNameAndQuantityView(
      String couponName, String couponType, int left) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            couponName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              Text(
                couponType,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontSize: 12.0,
                    ),
              ),
              SizedBox(width: 12.0),
              Text(
                '${AppLocalizations.of(context).labelCouponQuantityLeft} ${left ?? 0}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1.copyWith(
                      fontSize: 12.0,
                    ),
              ),
            ],
          )
        ]);
  }

  Widget _buildPriceAndDateView(String price, DateTime saleEnd) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 2),
          Text(
            '$price ${AppLocalizations.of(context).labelCouponOff}',
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: colorTextBody1),
          ),
          Text(AppLocalizations.of(context).labelCouponValidTill,
              style: Theme.of(context).textTheme.body2),
          Text(saleEnd != null ? DateFormat.yMMMd().format(saleEnd) : '--',
              style: Theme.of(context).textTheme.body2)
        ]);
  }

  Future<void> showCouponActions(Coupon coupon) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _buildMaterialCouponActionSheet(coupon);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoCouponActionSheet(coupon),
      );
    }
  }

  Widget _buildMaterialCouponActionSheet(Coupon coupon) => ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildMaterialFieldAction(
            AppLocalizations.of(context).labelEditCoupon,
            () => _onCreateCouponTypeSelected(coupon.couponType,
                couponId: coupon.id),
            showDivider: true,
          ),
          _buildMaterialFieldAction(
            coupon.active
                ? AppLocalizations.of(context).labelInActiveCoupon
                : AppLocalizations.of(context).labelActiveCoupon,
            () => activeInactiveCoupon(coupon),
            showDivider: false,
          ),
        ],
      );

  Widget _buildMaterialFieldAction(String name, Function handler,
      {bool showDivider = true}) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler();
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

  Widget _buildCupertinoCouponActionSheet(Coupon coupon) {
    return CupertinoActionSheet(
      actions: [
        _buildCupertinoCouponAction(
          AppLocalizations.of(context).labelEditCoupon,
          () => _onCreateCouponTypeSelected(coupon.couponType,
              couponId: coupon.id),
        ),
        _buildCupertinoCouponAction(
            coupon.active
                ? AppLocalizations.of(context).labelInActiveCoupon
                : AppLocalizations.of(context).labelActiveCoupon,
            () => activeInactiveCoupon(coupon)),
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

  Widget _buildCupertinoCouponAction(String name, Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler();
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

  void activeInactiveCoupon(Coupon coupon) {
    context.showProgress(context);
    _couponBloc.activeInactiveCoupon(coupon.id, !coupon.active, (response) {
      context.hideProgress(context);
    });
  }

  Future<void> showCouponCreateActions() async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _buildMaterialCouponCreateActionSheet();
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoCouponCreateActionSheet(),
      );
    }
  }

  Widget _buildMaterialCouponCreateActionSheet() {
    final couponTypes = getCouponType(context: context) as List<MenuCustom>;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: couponTypes.length,
      itemBuilder: (_, pos) {
        final menu = couponTypes[pos];
        return _buildMaterialFieldAction(
          menu.name,
          () => _onCreateCouponTypeSelected(menu.value),
          showDivider: pos == couponTypes.length - 1 ? false : true,
        );
      },
    );
  }

  Widget _buildCupertinoCouponCreateActionSheet() {
    return CupertinoActionSheet(
      actions:
          (getCouponType(context: context) as List<MenuCustom>).map((menu) {
        return _buildCupertinoCouponAction(
            menu.name, () => _onCreateCouponTypeSelected(menu.value));
      }).toList(),
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

  void _onCreateCouponTypeSelected(String type, {String couponId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => BlocProvider(
        create: (context) => CreateCouponBloc(
          _couponBloc,
          type,
          couponId: couponId,
        ),
        child: CreateCouponDialog(),
      ),
    );
  }
}
