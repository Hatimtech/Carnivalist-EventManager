import 'package:eventmanagement/ui/cliper/circular_notched_rectangle_custom.dart';
import 'package:eventmanagement/ui/page/dashboard_page.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () {},
            child: Padding(padding: EdgeInsets.all(18), child: Image(image: AssetImage(bottomMenuBarHomeImage), color: Colors.white))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangleCustom(),
            //notchMargin: 4.0,
            child: Container(color: HexColor(colorBottomBarMenu),
                height: 50,
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(image: AssetImage(bottomMenuBarEventImage),  color: HexColor('#5d5d5d')))),
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child:Image(image: AssetImage(bottomMenuBarCouponsImage),  color: HexColor('#5d5d5d')))),
                          SizedBox(width: 40),
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(image: AssetImage(bottomMenuBarAddImage),  color: HexColor('#5d5d5d')))),
                          InkWell(
                              customBorder: new CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Image(image: AssetImage(bottomMenuBarUserImage),  color: HexColor('#5d5d5d'))))
                        ])))),
        body: PageStorage(child: currentScreen, bucket: bucket));
  }
}
