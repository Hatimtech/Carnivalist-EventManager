import 'dart:async';

import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/bloc/addon/addon_state.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_state.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/page/dashboard/event_filter.dart';
import 'package:eventmanagement/ui/page/dashboard/event_list.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  PageNavBloc _pageNavBloc;
  UserBloc _userBloc;
  EventBloc _eventBloc;
  CouponBloc _couponBloc;
  AddonBloc _addonBloc;

  @override
  void initState() {
    super.initState();
    _pageNavBloc = BlocProvider.of<PageNavBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _eventBloc.authTokenSave(_userBloc.state.authToken);

    _addonBloc = BlocProvider.of<AddonBloc>(context);
    _addonBloc.authTokenSave(_userBloc.state.authToken);

    _couponBloc = BlocProvider.of<CouponBloc>(context);
    _couponBloc.authTokenSave(_userBloc.state.authToken);
    initDownload();
  }

  void initDownload() {
    if (PageStorage.of(context)
        .readState(context, identifier: 'INIT_DOWNLOAD') ??
        true) {
      _eventBloc.getAllEvents();
      _addonBloc.getAllAddons();
      _couponBloc.getAllCoupons();
      PageStorage.of(context)
          .writeState(context, false, identifier: 'INIT_DOWNLOAD');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        floatingActionButton: FloatingActionButton(
            heroTag: "FAB",
            backgroundColor: bgColorFAB,
            onPressed: onCreateEventButtonPressed,
            child: Icon(
              Icons.add,
              size: 48.0,
            )),
        body: Column(children: <Widget>[
          _buildErrorReceiverEmptyBloc(),
          Container(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Wrap(spacing: 2.0, children: <Widget>[
                      _category(
                        Icons.account_balance_wallet,
                        AppLocalizations
                            .of(context)
                            .labelCoupons
                            .toUpperCase(),
                            () {
                          _pageNavBloc.currentPage(PAGE_COUPONS);
                        },
                      ),
                      _category(
                        Icons.note_add,
                        AppLocalizations
                            .of(context)
                            .labelAddons
                            .toUpperCase(),
                            () {
                          _pageNavBloc.currentPage(PAGE_ADDONS);
                        },
                      ),
                      _category(
                        Icons.note,
                        AppLocalizations
                            .of(context)
                            .labelReports
                            .toUpperCase(),
                            () {
//                          _pageNavBloc.currentPage(PAGE_REPORTS);
                        },
                      ),
                      _category(
                        Icons.people,
                        AppLocalizations
                            .of(context)
                            .labelStaff
                            .toUpperCase(),
                            () {
//                          _pageNavBloc.currentPage(PAGE_STAFF);
                        },
                      )
                    ])
                  ])),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                Completer<bool> downloadCompleter = Completer();
                _eventBloc.getAllEvents(downloadCompleter: downloadCompleter);
                return downloadCompleter.future;
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Column(children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _categoryCounter(
                                    AppLocalizations
                                        .of(context)
                                        .labelTicketsSold,
                                    '00'),
                                SizedBox(width: 10),
                                BlocBuilder<EventBloc, EventState>(
                                    bloc: _eventBloc,
                                    condition: (prevState, newState) =>
                                    prevState.eventDataList !=
                                        newState.eventDataList,
                                    builder: (_, state) {
                                      return _categoryCounter(
                                          AppLocalizations
                                              .of(context)
                                              .labelUpcomingEvent,
                                          state.upcomingEventsCount.toString());
                                    })
                              ]),
                          const SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                BlocBuilder<CouponBloc, CouponState>(
                                    bloc: _couponBloc,
                                    condition: (prevState, newState) =>
                                    prevState.couponList !=
                                        newState.couponList,
                                    builder: (_, state) {
                                      return _categoryCounter(
                                          AppLocalizations
                                              .of(context)
                                              .labelCoupons,
                                          state.couponList?.length
                                              ?.toString() ??
                                              '00');
                                    }),
                                SizedBox(width: 10),
                                BlocBuilder<AddonBloc, AddonState>(
                                    bloc: _addonBloc,
                                    condition: (prevState, newState) =>
                                    prevState.addonList !=
                                        newState.addonList,
                                    builder: (_, state) {
                                      return _categoryCounter(
                                          AppLocalizations
                                              .of(context)
                                              .labelAddons,
                                          state.addonList?.length?.toString() ??
                                              '00');
                                    })
                              ])
                        ])),
                  ),
                  EventFilter(),
                  EventList(),
                ],
              ),
            ),
          )
        ]));
  }

  _category(IconData iconData, String name, Function handler) =>
      GestureDetector(
        onTap: handler,
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4.5,
                padding: new EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(iconData, size: 18, color: colorIconSecondary),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subhead,
                      )
                    ]))),
      );

  _categoryCounter(String name, String counter) => Card(
      color: bgColorSecondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Container(
          width: MediaQuery.of(context).size.width / 2.3,
          padding: new EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(counter.length > 1 ? counter : counter.padLeft(2, '0'),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle),
                SizedBox(height: 10),
                Text(name, style: Theme
                    .of(context)
                    .textTheme
                    .subhead)
              ])));

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<EventBloc, EventState>(
        bloc: _eventBloc,
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

  Future<void> onCreateEventButtonPressed() async {
    var refresh = await Navigator.pushNamed(context, eventMenuRoute);
    if (refresh ?? false) _eventBloc.getAllEvents();
  }
}
