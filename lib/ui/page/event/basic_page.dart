import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicPage extends StatefulWidget {
  @override
  createState() => _BasicState();
}

class _BasicState extends State<BasicPage> {

  bool loaded = false;

  BasicBloc _basicBloc;
  UserBloc _userBloc;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventEventEndDateController =
  TextEditingController();
  final TextEditingController _eventEventEndTimeController =
  TextEditingController();
  final TextEditingController _eventTimeZoneController =
  TextEditingController();
  final TextEditingController _eventTagsController = TextEditingController();
  final TextEditingController _eventStartDateController =
  TextEditingController();
  final TextEditingController _eventStartTimeController =
  TextEditingController();
  final TextEditingController _eventLocationController =
  TextEditingController();
  final TextEditingController _eventStateController = TextEditingController();
  final TextEditingController _eventCityController = TextEditingController();
  final TextEditingController _eventPostalCodeController =
  TextEditingController();
  final TextEditingController _eventDescriptionController =
  TextEditingController();
  String selectedCarnival;
  String selectedTimeZone;
  List<String> timeZoneList = [
    '(UTC+5:30) Kolkata',
    '(UTC+08:00) Perth',
    '(UTC+13:00) Samoa',
    '(UTC-06:00) US&Canada',
    '(UTC+01:00) Amsterdam, Berlin, Rome, Vienna',
    '(UTC+00:00) Dublin, Lisbon, London'
  ];


  @override
  void initState() {
    super.initState();
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.getLoginDetails();
    _basicBloc.authTokenSave(_userBloc.state.authToken);

    _basicBloc.eventMenu();
    _basicBloc.postType();
    _basicBloc.selectEventMenu('Once');
    _basicBloc.selectPostType('Public');
    _basicBloc.carnival();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      selectedCarnival = AppLocalizations
          .of(context)
          .inputHintCarnival;
      selectedTimeZone = AppLocalizations
          .of(context)
          .inputHintTimeZone;
      loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: ListView(shrinkWrap: true, padding: EdgeInsets.all(0), children: <
            Widget>[
          Card(
              color: Theme
                  .of(context)
                  .cardColor,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .titleBasicInfo,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .title),
                        const SizedBox(height: 20.0),
                        Text(AppLocalizations
                            .of(context)
                            .labelEventName,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2),
                        const SizedBox(height: 4.0),
                        _eventNameInput(),
                        const SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(AppLocalizations
                                            .of(context)
                                            .labelCarnivalName,
                                            textAlign: TextAlign.left,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .body2),
                                        const SizedBox(height: 4.0),
                                        InkWell(onTap: () {
                                          _onCarnivalButtonPressed();
                                        }, child: Container(
                                          height: 48,
                                          padding: EdgeInsets.only(left: 3.0),
                                          decoration: boxDecorationRectangle(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(selectedCarnival,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(color: Theme
                                                  .of(context)
                                                  .hintColor),),),
                                        ),),
                                        // _eventCarnivalNameInput(),
                                      ])),
                              const SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(AppLocalizations
                                            .of(context)
                                            .labelTimeZone,
                                            textAlign: TextAlign.left,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .body2),
                                        const SizedBox(height: 4.0),
                                        InkWell(onTap: () {
                                          _onTimeZoneButtonPressed();
                                        }, child: Container(
                                          height: 48,
                                          padding: EdgeInsets.only(left: 3.0),
                                          decoration: boxDecorationRectangle(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(selectedTimeZone,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(color: Theme
                                                  .of(context)
                                                  .hintColor),),),
                                        ),),
                                      ]))
                            ]),
                        const SizedBox(height: 10.0),
                        Text(AppLocalizations
                            .of(context)
                            .labelTags,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2),
                        const SizedBox(height: 4.0),
                        _eventTagInput(),
                        const SizedBox(height: 5)
                      ]))),
          Card(
              color: Theme
                  .of(context)
                  .cardColor,
              margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(7.0), top: Radius.circular(7.0))),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .titleEventDate,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .title),
                        Container(
                            child: BlocBuilder(
                                bloc: _basicBloc,
                                builder:
                                    (context, BasicState state) =>
                                    Column(children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                              color: HexColor('#EEEEEF'),
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      5.0))),
                                          child: Row(
                                              children: state.eventMenuList
                                                  .map((data) {
                                                return Expanded(
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          _basicBloc
                                                              .selectEventMenu(
                                                              data.name);
                                                        },
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: state
                                                                    .eventMenuName ==
                                                                    data.name
                                                                    ? HexColor(
                                                                    '#8c3ee9')
                                                                    : Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5)),
                                                            padding:
                                                            EdgeInsets.all(
                                                                8),
                                                            child: Text(
                                                                data.name,
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .body1
                                                                    .copyWith(
                                                                    fontSize: 12.0)))));
                                              }).toList())),
                                      Container(
                                          child:
                                          state.eventMenuName == 'Once'
                                              ? Column(children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                                AppLocalizations
                                                                    .of(context)
                                                                    .labelStartDate,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .body2),
                                                            SizedBox(
                                                                height:
                                                                4.0),
                                                            _eventStartDateInput(),
                                                          ])),
                                                  SizedBox(
                                                      width: 10.0),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                                AppLocalizations
                                                                    .of(context)
                                                                    .labelStartTime,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .body2),
                                                            SizedBox(
                                                                height:
                                                                4.0),
                                                            _eventStartTimeInput(),
                                                          ])),
                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                          width:
                                                          10.0))
                                                ]),
                                            SizedBox(
                                                height: 10.0),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                                AppLocalizations
                                                                    .of(context)
                                                                    .labelEndDate,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .body2),
                                                            SizedBox(
                                                                height:
                                                                4.0),
                                                            _eventEndDateInput(),
                                                          ])),
                                                  SizedBox(
                                                      width: 10.0),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                                AppLocalizations
                                                                    .of(context)
                                                                    .labelEndTime,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .body2),
                                                            SizedBox(
                                                                height:
                                                                4.0),
                                                            _eventEndTimeInput(),
                                                          ])),
                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                          width:
                                                          10.0))
                                                ])
                                          ],) : Container())
                                    ]))),
                      ]))),
          Card(
              color: Theme
                  .of(context)
                  .cardColor,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .titleAddress,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .title),
                        const SizedBox(height: 20.0),
                        Text(AppLocalizations
                            .of(context)
                            .labelLocation,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2),
                        const SizedBox(height: 4.0),
                        _eventLocationInput(),
                        const SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(AppLocalizations
                                            .of(context)
                                            .labelState,
                                            textAlign: TextAlign.left,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .body2),
                                        const SizedBox(height: 4.0),
                                        _eventStateInput(),
                                      ])),
                              const SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(AppLocalizations
                                            .of(context)
                                            .labelCity,
                                            textAlign: TextAlign.left,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .body2),
                                        const SizedBox(height: 4.0),
                                        _eventCityInput(),
                                      ]))
                            ]),
                        const SizedBox(height: 10.0),
                        Text(AppLocalizations
                            .of(context)
                            .labelPostalCode,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2),
                        const SizedBox(height: 4.0),
                        _eventPostalCodeInput(),
                        const SizedBox(height: 5)
                      ]))),
          Card(
              color: Theme
                  .of(context)
                  .cardColor,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .titleDescription,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .title),
                        const SizedBox(height: 20.0),
                        _eventDescriptionInput(),
                        const SizedBox(height: 10.0),
                        Container(
                            child: BlocBuilder(
                                bloc: _basicBloc,
                                builder: (context, BasicState state) =>
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                            color: HexColor('#EEEEEF'),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        child: Row(
                                            children:
                                            state.postTypeList.map((data) {
                                              return Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _basicBloc
                                                            .selectPostType(
                                                            data.name);
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: state
                                                                  .postType ==
                                                                  data.name
                                                                  ? HexColor(
                                                                  '#8c3ee9')
                                                                  : Colors
                                                                  .transparent,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                          padding:
                                                          EdgeInsets.all(8),
                                                          child: Text(data.name,
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: Theme
                                                                  .of(context)
                                                                  .textTheme
                                                                  .body2
                                                                  .copyWith(
                                                                fontSize: 12.0,)))));
                                            }).toList()))))
                      ]))),
        ]));
  }

  _eventNameInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventNameController,
                  onChanged: _basicBloc.eventNameInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintEventName,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventEndDateInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventEventEndDateController,
                  onChanged: _basicBloc.eventEndDateInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintDate,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventEndTimeInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventEventEndTimeController,
                  onChanged: _basicBloc.eventEndTimeInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintTime,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));


  /* _eventEventTimeZoneInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventTimeZoneController,
                  onChanged: _basicBloc.eventTimeZoneInput,
                  hintText: inputHintTimeZone));*/

  _eventTagInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventTagsController,
                  onChanged: _basicBloc.eventTagsInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintTag,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventStartDateInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventStartDateController,
                  onChanged: _basicBloc.eventStartDateInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintDate,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventStartTimeInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventStartTimeController,
                  onChanged: _basicBloc.eventStartTimeInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintTime,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventLocationInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventLocationController,
                  onChanged: _basicBloc.eventLocationInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintTypeYourLocation,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventStateInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventStateController,
                  onChanged: _basicBloc.eventStateInput,
                  hintText: AppLocalizations
                      .of(context)
                      .labelSelectState,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventCityInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventCityController,
                  onChanged: _basicBloc.eventCityInput,
                  hintText: AppLocalizations
                      .of(context)
                      .labelTypeCityName,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventPostalCodeInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventPostalCodeController,
                  onChanged: _basicBloc.eventPostalCodeInput,
                  hintText: AppLocalizations
                      .of(context)
                      .labelTypePostalCode,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  _eventDescriptionInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventDescriptionController,
                  onChanged: _basicBloc.eventDescriptionInput,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintDescription,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1));

  carnivalList(List<Carnivals> carnivalList) =>
      ListView.builder(
          itemCount: carnivalList.length,
          shrinkWrap: true,
          itemBuilder: (context, position) {
            return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedCarnival = carnivalList[position].category;
                  });
                  print(carnivalList[position].category);
                },
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(padding: EdgeInsets.all(10.0),
                      height: 40.0,
                      child: Text(carnivalList[position].category,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1),),
                    Divider(height: 2),
                  ],));
          });

  void _onCarnivalButtonPressed() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              child: _carnivalSelect(),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  void _onTimeZoneButtonPressed() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              child: _timeZonelist(timeZoneList),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Widget _timeZonelist(List<String> timeZonelist) =>
      ListView.builder(
          itemCount: timeZonelist.length,
          shrinkWrap: true,
          itemBuilder: (context, position) {
            return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedTimeZone = timeZonelist[position];
                    _basicBloc.eventTimeZoneInput(selectedTimeZone);
                  });
                  print(timeZonelist[position]);
                },
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(padding: EdgeInsets.all(10.0),
                      height: 40.0,
                      child: Text(timeZonelist[position],
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1),),
                    Divider(height: 2),
                  ],));
          });

  boxDecorationRectangle() =>
      BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
        ),
      );

  _carnivalSelect() {
    return BlocBuilder(
        bloc: _basicBloc,
        builder: (context, BasicState snapshot) =>
        snapshot
            .loading
            ? Container(
            alignment: FractionalOffset.center,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    colorProgressBar)))
            : carnivalList(snapshot.carnivalList));
  }
}
