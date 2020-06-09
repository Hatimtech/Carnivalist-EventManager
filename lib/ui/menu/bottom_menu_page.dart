import 'dart:io';

import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_bloc.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_state.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/carnivalist_icons_icons.dart';
import 'package:eventmanagement/ui/cliper/circular_notched_rectangle_custom.dart';
import 'package:eventmanagement/ui/page/addons/addon_page.dart';
import 'package:eventmanagement/ui/page/coupons/coupons_page.dart';
import 'package:eventmanagement/ui/page/dashboard/dashboard_page.dart';
import 'package:eventmanagement/ui/page/staff/staff_page.dart';
import 'package:eventmanagement/utils/logger.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomMenuPage extends StatefulWidget {
  @override
  createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenuPage> {
  final PageStorageBucket bucket = PageStorageBucket();

  final List<Widget> _pages = [
    DashboardPage(key: PageStorageKey(PAGE_STORAGE_KEY_DASHBOARD)),
    AddonPage(key: PageStorageKey(PAGE_STORAGE_KEY_ADDON)),
    CouponPage(key: PageStorageKey(PAGE_STORAGE_KEY_COUPONS)),
    StaffPage(key: PageStorageKey(PAGE_STORAGE_KEY_STAFF)),
  ];

  final List<String> _title = [];

  PageNavBloc _pageNavBloc;
  UserBloc _userBloc;
  DateTime _prevBackPressTime;

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _pageNavBloc = BlocProvider.of<PageNavBloc>(context);
    /*_pages.insert(
        0,
        WebViewPage(
            'https://manager.carnivalist.tk/redirect-to-reports/${_userBloc
                .state.authToken}'));
    _pages.insert(
        1,
        WebViewPage(
            'https://manager.carnivalist.tk/redirect-to-accounts/${_userBloc
                .state.authToken}'));*/
    _pages.insert(
        0,
        Center(child: Text('Reports'),));
    _pages.insert(
        1,
        Center(child: Text('Account'),));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      final appLoc = AppLocalizations.of(context);
      _title.add(appLoc.labelReports);
      _title.add(appLoc.labelAccount);
      _title.add(appLoc.titleDashboard);
      _title.add(appLoc.labelAddons);
      _title.add(appLoc.labelCoupons);
      _title.add(appLoc.labelStaff);
      loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: _buildHomeFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: isPlatformAndroid ? CircularNotchedRectangleCustom() : null,
          //notchMargin: 4.0,
          child: Container(
              color: colorBottomBarMenu,
              height: 56.0,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: BlocBuilder<PageNavBloc, PageNavState>(
                  bloc: _pageNavBloc,
                  condition: (prevState, newState) =>
                  prevState.page != newState.page,
                  builder: (_, state) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _bottomMenuItem(
                            Icons.poll,
                            AppLocalizations
                                .of(context)
                                .labelReports
                                .toUpperCase(),
                                () {
                              _pageNavBloc.currentPage(PAGE_REPORTS);
                            },
                            size: 16.0,
                            selected: PAGE_REPORTS == _pageNavBloc.state.page,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: _bottomMenuItem(
                              Icons.monetization_on,
                              AppLocalizations
                                  .of(context)
                                  .labelAccount
                                  .toUpperCase(),
                                  () {
                                _pageNavBloc.currentPage(PAGE_ACCOUNTS);
                              },
                              size: 16.0,
                              selected:
                              PAGE_ACCOUNTS == _pageNavBloc.state.page,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: _bottomMenuItem(
                              CarnivalistIcons.addon_filled,
                              AppLocalizations
                                  .of(context)
                                  .labelAddons
                                  .toUpperCase(),
                                  () {
                                _pageNavBloc.currentPage(PAGE_ADDONS);
                              },
                              size: 14.0,
                              selected: PAGE_ADDONS == _pageNavBloc.state.page,
                            ),
                          ),
                          _bottomMenuItem(
                            Icons.account_circle,
                            AppLocalizations
                                .of(context)
                                .labelProfile
                                .toUpperCase(),
                                () {
                              Navigator.of(context).pushNamed(userInfoRoute);
                            },
                            size: 16.0,
                          ),
                        ]);
                  },
                ),
              ))),
      body: WillPopScope(
        onWillPop: doubleBackPressToExit,
        child: Column(
          children: <Widget>[
            _buildTopBgContainer(),
            Expanded(
              child: BlocBuilder<PageNavBloc, PageNavState>(
                bloc: _pageNavBloc,
                condition: (prevState, newState) {
                  Logger.log(
                      'condition prevState.page--->${prevState
                          .page}, newState.page--->${newState.page}');
                  return prevState.page != newState.page;
                },
                builder: (_, state) {
                  Logger.log('builder state.page--->${state.page}');
                  return PageStorage(
                    child: _pages[state.page],
                    bucket: bucket,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBgContainer() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: BlocBuilder<PageNavBloc, PageNavState>(
              bloc: _pageNavBloc,
              condition: (prevState, newState) =>
              prevState.page != newState.page,
              builder: (_, state) {
                return Text(
                  _title[state.page],
                  style: Theme
                      .of(context)
                      .appBarTheme
                      .textTheme
                      .title,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(
                  Icons.power_settings_new,
                  color: Theme
                      .of(context)
                      .appBarTheme
                      .iconTheme
                      .color,
                ),
                onPressed: () {
                  showLogs();
//                  showLogoutConfirmationDialog();
                }),
          ),
        ],
      ),
      height: 124,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(colorHeaderBgFilter, BlendMode.srcATop),
          image: AssetImage(headerBackgroundImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _bottomMenuItem(IconData iconData, String name, Function handler,
      {double size = 18, bool selected = false}) =>
      GestureDetector(
        onTap: handler,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(6.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  width: 18 + (selected ? 4.0 : 0.0),
                  height: 18 + (selected ? 4.0 : 0.0),
                  duration: const Duration(milliseconds: 500),
                  child: Icon(iconData,
                      size: size + (selected ? 4.0 : 0.0),
                      color:
                      selected ? colorIcon : colorUnselectedIconBottomBar),
                ),
                const SizedBox(height: 4.0),
                Text(
                  name,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(
                    color: selected ? null : colorUnselectedTextBottomBar,
                    fontSize: selected
                        ? Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .fontSize + 2
                        : null,
                  ),
                )
              ]),
        ),
      );

  Widget _buildHomeFAB() {
    return _buildFABDecorationByPlatform(
      child: FloatingActionButton(
        mini: true,
        elevation: isPlatformAndroid ? 4.0 : 0.0,
        backgroundColor: bgColorFABHome,
        onPressed: () {
          _pageNavBloc.currentPage(PAGE_DASHBOARD);
        },
        child: Icon(
          Icons.home,
        ),
      ),
    );
  }

  Widget _buildFABDecorationByPlatform({Widget child}) {
    if (isPlatformAndroid)
      return child;
    else
      return Container(
        width: 48.0,
        height: 48.0,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: bgColorSecondary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 8.0,
            ),
          ],
        ),
        child: child,
      );
  }

  Future<bool> doubleBackPressToExit() async {
    DateTime now = DateTime.now();
    if (_prevBackPressTime == null ||
        now.difference(_prevBackPressTime) >= Duration(seconds: 3)) {
      _prevBackPressTime = now;
      Fluttertoast.showToast(
        msg: AppLocalizations
            .of(context)
            .exitWarning,
      );
      return false;
    }
    return true;
  }

  void showLogoutConfirmationDialog() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        AppLocalizations
            .of(context)
            .logoutTitle,
        style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(fontSize: 16.0),
      ),
      content: Text(
        AppLocalizations
            .of(context)
            .logoutMsg,
        style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations
                .of(context)
                .btnCancel)),
        FlatButton(
            onPressed: () {
              BlocProvider.of<EventBloc>(context).clearState();
              _userBloc.clearLoginDetails();
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, (Route<dynamic> route) => false);
            },
            child: Text(AppLocalizations
                .of(context)
                .btnLogout)),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  void showLogs() async {
    var docsDir = await getSystemDirPath();
    String canonFilename = '$docsDir/back_to_now.txt';
    String content = File(canonFilename).readAsStringSync();
    AlertDialog alertDialog = AlertDialog(
      content: SelectableText(
        content,
        style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
      ),
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }
}
