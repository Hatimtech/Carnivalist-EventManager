import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/cliper/circular_notched_rectangle_custom.dart';
import 'package:eventmanagement/ui/page/dashboard_page.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomMenuPage extends StatefulWidget {
  @override
  createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenuPage> {
  int currentTab = 0;
  final List<Widget> screens = [
    DashboardPage(),
    Container(),
    Container(),
    Container(),
  ]; // to store nested tabs
  Widget currentScreen = DashboardPage();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
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
                          Icon(
                            Icons.account_balance_wallet,
                            color: colorIconBottomBar,
                          ),
                          Icon(
                            Icons.note_add,
                            color: colorIconBottomBar,
                          ),
                          Icon(
                            Icons.note,
                            color: colorIconBottomBar,
                          ),
                          Icon(
                            Icons.people,
                            color: colorIconBottomBar,
                          ),
                          /*InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(
                                      image:
                                          AssetImage(bottomMenuBarEventImage),
                                      color: HexColor('#5d5d5d')))),
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(
                                      image:
                                          AssetImage(bottomMenuBarCouponsImage),
                                      color: HexColor('#5d5d5d')))),
                          SizedBox(width: 40),
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(
                                      image: AssetImage(bottomMenuBarAddImage),
                                      color: HexColor('#5d5d5d')))),
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(
                                      image: AssetImage(bottomMenuBarUserImage),
                                      color: HexColor('#5d5d5d'))))*/
                        ])))),
        body: PageStorage(child: currentScreen, bucket: bucket));
  }

  Widget _buildHomeFAB() {
    return _buildFABDecorationByPlatform(
      child: FloatingActionButton(
        mini: true,
        elevation: isPlatformAndroid ? 4.0 : 0.0,
        backgroundColor: colorAccent,
        onPressed: () {},
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
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFFDCDE2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
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
}
