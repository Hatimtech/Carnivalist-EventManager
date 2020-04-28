import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/ui/page/event/basic_page.dart';
import 'package:eventmanagement/ui/page/event/forms_page.dart';
import 'package:eventmanagement/ui/page/event/gallery_page.dart';
import 'package:eventmanagement/ui/page/event/setting_page.dart';
import 'package:eventmanagement/ui/page/event/tickets_page.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  BasicBloc _basicBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    _setActiveTabIndex();

    _basicBloc = BlocProvider.of<BasicBloc>(context);
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
        backgroundColor: bgColor,
        bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .btnCancel,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RaisedButton(
                  onPressed: next,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .btnNext,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ),
              )
            ])),
        body: Column(children: <Widget>[
          Container(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(
                          isPlatformAndroid
                              ? Icons.arrow_back
                              : CupertinoIcons.back,
                          color: Theme
                              .of(context)
                              .appBarTheme
                              .iconTheme
                              .color,
                        ),
                        onPressed: Navigator
                            .of(context)
                            .pop),
                  ),
                  Center(
                    child: Text(
                      AppLocalizations
                          .of(context)
                          .titleCreateEvent,
                      style: Theme
                          .of(context)
                          .appBarTheme
                          .textTheme
                          .title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(headerBackgroundImage),
                    fit: BoxFit.fitWidth,
                  ))),
          const SizedBox(
            height: 16.0,
          ),
          Expanded(
              child: DefaultTabController(
                  length: 5,
                  child: new Scaffold(
                      backgroundColor: bgColor,
                      appBar: TabBar(
                          controller: _tabController,
                          labelColor: Colors.white,
                          indicatorColor: Colors.transparent,
                          labelPadding: EdgeInsets.all(4),
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                                child: tabName('1', _selectedIndex, 0,
                                    AppLocalizations
                                        .of(context)
                                        .menuBasic)),
                            Tab(
                                child: tabName('2', _selectedIndex, 1,
                                    AppLocalizations
                                        .of(context)
                                        .menuTickets)),
                            Tab(
                                child: tabName('3', _selectedIndex, 2,
                                    AppLocalizations
                                        .of(context)
                                        .menuForms)),
                            Tab(
                                child: tabName('4', _selectedIndex, 3,
                                    AppLocalizations
                                        .of(context)
                                        .menuGallery)),
                            Tab(
                                child: tabName('5', _selectedIndex, 4,
                                    AppLocalizations
                                        .of(context)
                                        .menuSettings))
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
          decoration: BoxDecoration(
              color: selectIndex == defaultIndex ? colorBgButton : Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Align(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      index,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead
                          .copyWith(
                        color: selectIndex == defaultIndex
                            ? Colors.white
                            : Theme
                            .of(context)
                            .textTheme
                            .subhead
                            .color,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead
                          .copyWith(
                        color: selectIndex == defaultIndex
                            ? Colors.white
                            : Theme
                            .of(context)
                            .textTheme
                            .subhead
                            .color,
                      ),
                    )
                  ])));

  next() {
    context.showProgress(context);
    _basicBloc.basic((results) {
      if (results is BasicResponse) {
        context.hideProgress(context);
        var basicResponse = results;

        if (basicResponse.code == apiCodeSuccess) {
          context.toast(basicResponse.message);
        } else {
          context.toast(basicResponse.message);
        }
      }
    });
  }
}
