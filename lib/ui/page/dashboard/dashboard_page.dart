import 'dart:async';

import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/bloc/addon/addon_state.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_state.dart';
import 'package:eventmanagement/bloc/dashboard/dashboard_bloc.dart';
import 'package:eventmanagement/bloc/dashboard/dashboard_state.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/bloc/staff/staff_bloc.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/carnivalist_icons_icons.dart';
import 'package:eventmanagement/ui/page/dashboard/event_filter.dart';
import 'package:eventmanagement/ui/page/dashboard/event_list.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage>
    with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;

  PageNavBloc _pageNavBloc;
  UserBloc _userBloc;
  DashboardBloc _dashboardBloc;
  EventBloc _eventBloc;
  CouponBloc _couponBloc;
  AddonBloc _addonBloc;
  StaffBloc _staffBloc;

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

    _pageNavBloc = BlocProvider.of<PageNavBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _eventBloc.userIdSave(_userBloc.state.userId);
    _eventBloc.authTokenSave(_userBloc.state.authToken);

    _dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    _dashboardBloc.authTokenSave(_userBloc.state.authToken);

    _addonBloc = BlocProvider.of<AddonBloc>(context);
    _addonBloc.authTokenSave(_userBloc.state.authToken);

    _couponBloc = BlocProvider.of<CouponBloc>(context);
    _couponBloc.authTokenSave(_userBloc.state.authToken);

    _staffBloc = BlocProvider.of<StaffBloc>(context);
    _staffBloc.authTokenSave(_userBloc.state.authToken);

    initDownload();
  }

  void initDownload() {
    if (PageStorage.of(context)
        .readState(context, identifier: 'INIT_DOWNLOAD') ??
        true) {
      _dashboardBloc.getPaymentSummary();
      _eventBloc.getAllEvents();
      _addonBloc.getAllAddons();
      _couponBloc.getAllCoupons();
      _staffBloc.getAllStaffs();
      PageStorage.of(context)
          .writeState(context, false, identifier: 'INIT_DOWNLOAD');
    }
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
        backgroundColor: bgColor,
        floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation,
          child: FloatingActionButton(
              heroTag: "FAB",
              backgroundColor: bgColorFAB,
              onPressed: onCreateEventButtonPressed,
              child: Icon(
                Icons.add,
                size: 48.0,
              )),
        ),
        body: Column(children: <Widget>[
          IgnorePointer(child: _buildErrorReceiverEmptyBloc()),
          Container(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
//                      String downloadPath =
//                          "${await getSystemDirPath()}/downloads/";
//                      Directory downloadDir = Directory(downloadPath);
//                      if (!downloadDir.existsSync())
//                        downloadDir.createSync(recursive: true);
//                      await FlutterDownloader.enqueue(
//                        url:
//                            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
//                        savedDir: downloadPath,
//                        showNotification: true,
//                        // show download progress in status bar (for Android)
//                        openFileFromNotification:
//                            true, // click on notification to open downloaded file (for Android)
//                      );
//                        await Logger.log('Dashboard Coupon Clicked');
                        _pageNavBloc.currentPage(PAGE_COUPONS);
                      },
                      child: _category(
                        CarnivalistIcons.discount,
                        AppLocalizations
                            .of(context)
                            .labelCoupons
                            .toUpperCase(),
                        size: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
//                        await Logger.log('Dashboard Addon Clicked');
                        _pageNavBloc.currentPage(PAGE_ADDONS);
                      },
                      child: _category(
                        CarnivalistIcons.addon_filled,
                        AppLocalizations
                            .of(context)
                            .labelAddons
                            .toUpperCase(),
                        size: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
//                        await Logger.log('Dashboard Reports Clicked');
                        _pageNavBloc.currentPage(PAGE_REPORTS);
                      },
                      child: _category(
                        Icons.poll,
                        AppLocalizations
                            .of(context)
                            .labelReports
                            .toUpperCase(),
                        size: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
//                        await Logger.log('Dashboard Staff Clicked');
                        _pageNavBloc.currentPage(PAGE_STAFF);
                      },
                      child: _category(
                        Icons.people,
                        AppLocalizations
                            .of(context)
                            .labelStaff
                            .toUpperCase(),
                        size: 16.0,
                      ),
                    ),
                  ),
                ])),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                Completer<bool> downloadCompleter = Completer();
                _eventBloc.getAllEvents(downloadCompleter: downloadCompleter);
                _dashboardBloc.getPaymentSummary();
                return downloadCompleter.future;
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: IgnorePointer(
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    BlocBuilder<DashboardBloc, DashboardState>(
                                        cubit: _dashboardBloc,
                                        buildWhen: (prevState, newState) =>
                                        prevState.paymentSummary !=
                                            newState.paymentSummary,
                                        builder: (_, state) {
                                          return _categoryCounter(
                                              AppLocalizations
                                                  .of(context)
                                                  .labelTicketsSold,
                                              state.paymentSummary?.quantity
                                                  ?.toString() ??
                                                  '00');
                                        }),
                                    SizedBox(width: 10),
                                    BlocBuilder<EventBloc, EventState>(
                                        cubit: _eventBloc,
                                        buildWhen: (prevState, newState) =>
                                        prevState.eventDataList !=
                                            newState.eventDataList,
                                        builder: (_, state) {
                                          return _categoryCounter(
                                              AppLocalizations
                                                  .of(context)
                                                  .labelUpcomingEvent,
                                              state.upcomingEventsCount
                                                  .toString());
                                        })
                                  ]),
                              const SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    BlocBuilder<CouponBloc, CouponState>(
                                        cubit: _couponBloc,
                                        buildWhen: (prevState, newState) =>
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
                                        cubit: _addonBloc,
                                        buildWhen: (prevState, newState) =>
                                        prevState.addonList !=
                                            newState.addonList,
                                        builder: (_, state) {
                                          return _categoryCounter(
                                              AppLocalizations
                                                  .of(context)
                                                  .labelAddons,
                                              state.addonList?.length
                                                  ?.toString() ??
                                                  '00');
                                        })
                                  ])
                            ])),
                      ),
                    ),
                    EventFilter(),
                    EventList(),
                  ],
                ),
              ),
            ),
          )
        ]));
  }

  _category(IconData iconData, String name, {double size = 18}) =>
      Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
              padding: new EdgeInsets.all(10.0),
              child: IgnorePointer(
                child: Container(
                  child: IgnorePointer(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IgnorePointer(
                            child: Container(
                              width: 18,
                              height: 18,
                              child:
                              Icon(iconData, size: size,
                                  color: colorIconSecondary),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subhead,
                          )
                        ]),
                  ),
                ),
              )));

  _category1(IconData iconData, String name, Color color, Function handler,
      {double size = 18}) =>
      GestureDetector(
        onTap: handler,
        child: Card(
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: IgnorePointer(
                ignoring: true,
                child: Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 18,
                              height: 18,
                              child: Icon(iconData,
                                  size: size, color: colorIconSecondary),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              name,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subhead,
                            )
                          ]),
                    )))),
      );

  _category2(IconData iconData, String name, Function handler,
      {double size = 18}) =>
      GestureDetector(
        onTap: handler,
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
                padding: new EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          child: Icon(iconData,
                              size: size, color: colorIconSecondary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subhead,
                        )
                      ]),
                ))),
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
        cubit: _eventBloc,
        buildWhen: (prevState, newState) => newState.uiMsg != null,
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
