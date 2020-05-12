import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_bloc.dart';
import 'package:eventmanagement/bloc/bottom_nav_bloc/page_nav_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/cliper/circular_notched_rectangle_custom.dart';
import 'package:eventmanagement/ui/page/addons/addon_page.dart';
import 'package:eventmanagement/ui/page/dashboard/dashboard_page.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomMenuPage extends StatefulWidget {
  @override
  createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenuPage> {
  final PageStorageBucket bucket = PageStorageBucket();

  final List<Widget> _pages = [
    DashboardPage(key: PageStorageKey(PAGE_STORAGE_KEY_DASHBOARD)),
    Container(),
    AddonPage(key: PageStorageKey(PAGE_STORAGE_KEY_ADDON)),
    Container(),
    Container(),
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      final appLoc = AppLocalizations.of(context);
      _title.add(appLoc.titleDashboard);
      _title.add(appLoc.labelAddons);
      _title.add(appLoc.labelAddons);
      _title.add(appLoc.labelAddons);
      _title.add(appLoc.labelAddons);
      loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: _buildHomeFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: isPlatformAndroid ? CircularNotchedRectangleCustom() : null,
          //notchMargin: 4.0,
          child: Container(
              color: colorBottomBarMenu,
              height: 50,
              child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
//                            _pageNavBloc.currentPage(PAGE_COUPONS);
                          },
                          icon: Icon(
                            Icons.account_balance_wallet,
                            color: colorIconBottomBar,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _pageNavBloc.currentPage(PAGE_ADDONS);
                          },
                          icon: Icon(
                            Icons.note_add,
                            color: colorIconBottomBar,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
//                            _pageNavBloc.currentPage(PAGE_REPORTS);
                          },
                          icon: Icon(
                            Icons.note,
                            color: colorIconBottomBar,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
//                            _pageNavBloc.currentPage(PAGE_STAFF);
                          },
                          icon: Icon(
                            Icons.people,
                            color: colorIconBottomBar,
                          ),
                        ),
                      ])))),
      body: WillPopScope(
        onWillPop: doubleBackPressToExit,
        child: Column(
          children: <Widget>[
            _buildTopBgContainer(),
            Expanded(
              child: BlocBuilder<PageNavBloc, PageNavState>(
                bloc: _pageNavBloc,
                condition: (prevState, newState) =>
                prevState.page != newState.page,
                builder: (_, state) {
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
                onPressed: () => showLogoutConfirmationDialog()),
          ),
        ],
      ),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(colorHeaderBgFilter, BlendMode.srcATop),
          image: AssetImage(headerBackgroundImage),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

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
      context.toast(
        AppLocalizations
            .of(context)
            .exitWarning,
        duration: const Duration(seconds: 2),
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
              _userBloc.clearLoginDetails();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(loginRoute);
            },
            child: Text(AppLocalizations
                .of(context)
                .btnLogout)),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }
}
