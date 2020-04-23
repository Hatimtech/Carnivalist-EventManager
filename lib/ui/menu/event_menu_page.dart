import 'package:eventmanagement/ui/page/event/basic_page.dart';
import 'package:eventmanagement/ui/page/event/forms_page.dart';
import 'package:eventmanagement/ui/page/event/gallery_page.dart';
import 'package:eventmanagement/ui/page/event/setting_page.dart';
import 'package:eventmanagement/ui/page/event/tickets_page.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EventMenuPage extends StatefulWidget {
  EventMenuPage({Key key}) : super(key: key);

  @override
  createState() => _EventMenuState();
}

class _EventMenuState extends State<EventMenuPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  TabController _tabController;
  TextStyle tabStyle = TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    _setActiveTabIndex();
  }

  void _setActiveTabIndex() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(bgColor),
        body: Column(children: <Widget>[
          Container(
              child: Center(
                  child: Text(titleCreateEvent,
                      style: TextStyle(fontSize: 16, color: colorHeaderTitle))),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(headerBackgroundImage),
                fit: BoxFit.fitWidth,
              ))),
          Expanded(
              child: DefaultTabController(
                  length: 5,
                  child: new Scaffold(
                      backgroundColor: HexColor(bgColor),
                      appBar: TabBar(
                          controller: _tabController,
                          labelColor: Colors.white,
                          indicatorPadding: EdgeInsets.all(0),
                          indicatorColor: Colors.transparent,
                          labelPadding: EdgeInsets.all(0),
                          unselectedLabelColor: HexColor('#8c3ee9'),
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                                child:
                                    tabName('1', _selectedIndex, 0, menuBasic)),
                            Tab(
                                child: tabName(
                                    '2', _selectedIndex, 1, menuTickets)),
                            Tab(
                                child:
                                    tabName('3', _selectedIndex, 2, menuForms)),
                            Tab(
                                child: tabName(
                                    '4', _selectedIndex, 3, menuGallery)),
                            Tab(
                                child: tabName(
                                    '5', _selectedIndex, 4, menuSettings))
                          ]),
                      body: TabBarView(controller: _tabController, children: [
                        BasicPage(),
                        TicketsPage(),
                        FormsPage(),
                        GalleryPage(),
                        SettingPage()
                      ]))))
        ]));
  }

  @override
  bool get wantKeepAlive => false;

  tabName(String index, int selectIndex, int defaultIndex, String name) =>
      Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(top: 2, bottom: 2),
          decoration: BoxDecoration(
              color: selectIndex == defaultIndex
                  ? HexColor('#8c3ee9')
                  : Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Align(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Text(index),
                Text(name, style: TextStyle(fontSize: 12))
              ])));
}
