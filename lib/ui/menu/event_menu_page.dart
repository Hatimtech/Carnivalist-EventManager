import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_bloc.dart';
import 'package:eventmanagement/bloc/event/gallery/gallery_bloc.dart';
import 'package:eventmanagement/bloc/event/setting/setting_bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_bloc.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/form/form_action_response.dart';
import 'package:eventmanagement/model/event/gallery/gallery_response.dart';
import 'package:eventmanagement/model/event/settings/setting_response.dart';
import 'package:eventmanagement/ui/page/event/basic/basic_page.dart';
import 'package:eventmanagement/ui/page/event/forms/forms_page.dart';
import 'package:eventmanagement/ui/page/event/gallery/gallery_page.dart';
import 'package:eventmanagement/ui/page/event/settings/setting_page.dart';
import 'package:eventmanagement/ui/page/event/ticket/tickets_page.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventMenuPage extends StatefulWidget {
  final String eventId;

  EventMenuPage(this.eventId, {Key key}) : super(key: key);

  @override
  createState() => _EventMenuState();
}

class _EventMenuState extends State<EventMenuPage>
    with SingleTickerProviderStateMixin {
  bool refreshList = false;
  TabController _tabController;
  TextStyle tabStyle = TextStyle(fontSize: 16);

  UserBloc _userBloc;
  EventBloc _eventBloc;
  BasicBloc _basicBloc;
  TicketsBloc _ticketsBloc;
  FormBloc _formBloc;
  GalleryBloc _galleryBloc;
  SettingBloc _settingBloc;

  EventData _eventData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      _basicBloc.selectedTabChange(_tabController.index);
    });

    _userBloc = BlocProvider.of<UserBloc>(context);

    _eventBloc = BlocProvider.of<EventBloc>(context);
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    _ticketsBloc = BlocProvider.of<TicketsBloc>(context);
    _formBloc = BlocProvider.of<FormBloc>(context);
    _galleryBloc = BlocProvider.of<GalleryBloc>(context);
    _settingBloc = BlocProvider.of<SettingBloc>(context);

//    final _addonBloc = BlocProvider.of<AddonBloc>(context);
//    _addonBloc.authTokenSave(_userBloc.state.authToken);
//    _addonBloc.getAllAddons();

    if (isValid(widget.eventId)) {
      _eventData = _eventBloc.state.findById(widget.eventId);
    }

    initBasicBloc();
    initTicketBloc();
    initFormsBloc();
    initGalleryBloc();
    initSettingsBloc();
  }

  void initBasicBloc() {
    _basicBloc.authTokenSave(_userBloc.state.authToken);

    _basicBloc.basicDefault();

    if (_eventData != null) {
      _basicBloc.eventDataId = _eventData.id;
      _basicBloc.populateExistingEvent(_eventData);
    }
    _basicBloc.carnival();
  }

  void initTicketBloc() {
    _ticketsBloc
        .authTokenSave(BlocProvider
        .of<UserBloc>(context)
        .state
        .authToken);
    if (_eventData != null) {
      _ticketsBloc.populateExistingEvent(_eventData.tickets);
      _ticketsBloc.eventDataId = _eventData.id;
    }
  }

  void initFormsBloc() {
    _formBloc.authTokenSave(BlocProvider
        .of<UserBloc>(context)
        .state
        .authToken);
    if (_eventData != null) {
      if (_eventData.formStructure.isNotEmpty)
        _formBloc.populateExistingEvent(_eventData.formStructure);
      else
        _formBloc.initSolidFields();
      _formBloc.eventDataId = _eventData.id;
    } else {
      _formBloc.initSolidFields();
    }
  }

  void initGalleryBloc() {
    _galleryBloc
        .authTokenSave(BlocProvider
        .of<UserBloc>(context)
        .state
        .authToken);
    if (_eventData != null) {
      _galleryBloc.populateExistingEvent(_eventData.banner, _eventData.gallery);
      _galleryBloc.eventDataId = _eventData.id;
    }
  }

  void initSettingsBloc() {
    _settingBloc
        .authTokenSave(BlocProvider
        .of<UserBloc>(context)
        .state
        .authToken);
    _settingBloc.settingDefault();
    if (_eventData != null) {
      _settingBloc.populateExistingEvent(_eventData);
      _settingBloc.eventDataId = _eventData.id;
    }
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
                  onPressed: previous,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .btnPrevious,
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
                        .btnSubmit,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ),
              )
            ])),
        body: WillPopScope(
          onWillPop: () async {
            bool exit = await checkUnsavedDataAndPop();
            if (exit) Navigator.pop(context, refreshList);
            return false;
          },
          child: Column(children: <Widget>[
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
                            color:
                            Theme
                                .of(context)
                                .appBarTheme
                                .iconTheme
                                .color,
                          ),
                          onPressed: () async {
                            bool exit = await checkUnsavedDataAndPop();
                            if (exit) Navigator.pop(context, refreshList);
                          }),
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
                height: 124,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(headerBackgroundImage),
                      fit: BoxFit.fill,
                    ))),
            Expanded(
                child: DefaultTabController(
                    length: 5,
                    child: Column(children: <Widget>[
                      BlocBuilder<BasicBloc, BasicState>(
                          cubit: _basicBloc,
                          buildWhen: (prevState, newState) =>
                          prevState.selectedTab != newState.selectedTab,
                          builder: (context, BasicState state) {
                            return TabBar(
                              controller: _tabController,
                              labelColor: Colors.white,
                              indicatorColor: Colors.transparent,
                              labelPadding: EdgeInsets.all(4),
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.tab,
                              onTap: (pos) {
                                if (pos > 0 &&
                                    !isValid(_basicBloc.eventDataId)) {
                                  context.toast(AppLocalizations
                                      .of(context)
                                      .validateStep1);
                                  _tabController.index = 0;
                                }
                              },
                              tabs: [
                                Tab(
                                  child: tabName('1', state.selectedTab, 0,
                                      AppLocalizations
                                          .of(context)
                                          .menuBasic),
                                ),
                                Tab(
                                  child: tabName('2', state.selectedTab, 1,
                                      AppLocalizations
                                          .of(context)
                                          .menuTickets),
                                ),
                                Tab(
                                  child: tabName('3', state.selectedTab, 2,
                                      AppLocalizations
                                          .of(context)
                                          .menuForms),
                                ),
                                Tab(
                                  child: tabName('4', state.selectedTab, 3,
                                      AppLocalizations
                                          .of(context)
                                          .menuGallery),
                                ),
                                Tab(
                                  child: tabName(
                                      '5',
                                      state.selectedTab,
                                      4,
                                      AppLocalizations
                                          .of(context)
                                          .menuSettings),
                                )
                              ],
                            );
                          }),
                      Expanded(
                        child: TabBarView(
                          physics: isValid(_basicBloc.eventDataId)
                              ? null
                              : NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            BasicPage(),
                            TicketsPage(),
                            FormsPage(),
                            GalleryPage(),
                            SettingPage()
                          ],
                        ),
                      ),
                    ])))
          ]),
        ));
  }

  @override
  bool get wantKeepAlive => false;

  tabName(String index, int selectIndex, int defaultIndex, String name) =>
      Container(
          decoration: BoxDecoration(
              color: selectIndex == defaultIndex ? bgColorButton : Colors.white,
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

  void next() {
    if (_tabController.index == 0) {
      submitBasicStep();
    } else if (_tabController.index == 1) {
      submitTicketStep();
    } else if (_tabController.index == 2) {
      submitFormStep();
    } else if (_tabController.index == 3) {
      submitGalleryStep();
    } else if (_tabController.index == 4) {
      submitSettingStep();
    }
  }

  void previous() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void submitBasicStep() {
    context.showProgress(context);

    _basicBloc.basic((results) {
      context.hideProgress(context);

      if (results is BasicResponse) {
        if (results.code == apiCodeSuccess) {
          shareEventDataWithOtherBlocs();
          _tabController.animateTo(1);
          refreshList = true;
        }
      }

      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void shareEventDataWithOtherBlocs() {
    if (widget.eventId == null) {
      if (!isValid(_ticketsBloc.eventDataId))
        _ticketsBloc.eventDataId = _basicBloc.eventDataId;

      if (!isValid(_formBloc.eventDataId)) {
        _formBloc.eventDataId = _basicBloc.eventDataId;
      }
      _formBloc.eventDataToUpload = _basicBloc.eventDataToUpload;

      if (!isValid(_galleryBloc.eventDataId)) {
        _galleryBloc.eventDataId = _basicBloc.eventDataId;
      }
      _galleryBloc.eventDataToUpload = _basicBloc.eventDataToUpload;

      if (!isValid(_settingBloc.eventDataId))
        _settingBloc.eventDataId = _basicBloc.eventDataId;
    }
  }

  void submitTicketStep() {
    if (_ticketsBloc.state.ticketsList.length > 0) {
      _tabController.animateTo(2);
      refreshList = true;
    } else {
      context.toast(AppLocalizations
          .of(context)
          .errorTicketLength);
    }
  }

  void submitFormStep() {
    context.showProgress(context);

    _formBloc.uploadFields((results) {
      context.hideProgress(context);

      if (results is FormActionResponse) {
        if (results.code == apiCodeSuccess) {
          _tabController.animateTo(3);
          refreshList = true;
        }
      } else if (results is String && results == 'Upload not required') {
        _tabController.animateTo(3);
      }
    });
  }

  void submitGalleryStep() {
    context.showProgress(context);

    _galleryBloc.uploadGallery((results) {
      context.hideProgress(context);

      if (results is GalleryResponse) {
        var galleryResponse = results;
        if (galleryResponse.code == apiCodeSuccess) {
          _tabController.animateTo(4);
          refreshList = true;
        }
      } else if (results is String) {
        if (results == 'Upload not required') _tabController.animateTo(4);
      }
    });
  }

  void submitSettingStep() {
    if (_basicBloc.state.uploadRequired) {
      context.toast(AppLocalizations
          .of(context)
          .errorUnsavedBasic);
      return;
    }

    if (_ticketsBloc.state.ticketsList.length == 0) {
      context.toast(AppLocalizations
          .of(context)
          .errorTicketLength);
      return;
    }

    if (_formBloc.state.uploadRequired) {
      context.toast(AppLocalizations
          .of(context)
          .errorUnsavedForm);
      return;
    }

    if (!isValid(_galleryBloc.state.banner)) {
      context.toast(AppLocalizations
          .of(context)
          .errorGalleryBanner);
      return;
    }

    if (_galleryBloc.state.uploadRequired) {
      context.toast(AppLocalizations
          .of(context)
          .errorUnsavedGallery);
      return;
    }

    context.showProgress(context);

    _settingBloc.uploadSettings((results) {
      context.hideProgress(context);

      if (results is SettingResponse) {
        if (results.code == apiCodeSuccess) {
          refreshList = true;
          Navigator.of(context).pop(refreshList);
        }
      }
    });
  }

  Future<bool> checkUnsavedDataAndPop() async {
    bool uploadBasic = false,
        uploadForm = false,
        uploadGallery = false,
        uploadSetting = false;

    if (_basicBloc.state.uploadRequired) {
      uploadBasic = true;
    }

    if (_formBloc.state.uploadRequired &&
        _formBloc.state.fieldList.length > 4) {
      uploadForm = true;
    }

    if (_galleryBloc.state.uploadRequired) {
      uploadGallery = true;
    }

    if (_settingBloc.state.uploadRequired) {
      uploadSetting = true;
    }

    if (uploadBasic || uploadForm || uploadGallery || uploadSetting) {
      AlertDialog alertDialog = AlertDialog(
        content: Text(
          AppLocalizations
              .of(context)
              .errorUnsavedChanges,
          style: Theme
              .of(context)
              .textTheme
              .title
              .copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations
                  .of(context)
                  .btnCancel)),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, refreshList);
              },
              child: Text(AppLocalizations
                  .of(context)
                  .btnGoBack)),
        ],
      );

      showDialog(context: context, builder: (context) => alertDialog);

      return false;
    }

    return true;
  }
}
