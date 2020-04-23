import 'dart:convert';

import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/model/event/basic/basic_json.dart';
import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicPage extends StatefulWidget {
  @override
  createState() => _BasicState();
}

class _BasicState extends State<BasicPage> {
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
  String selectedCarnival = inputHintCarnival;
  String selectedTimeZone = inputHintTimeZone;
  List<String> timeZoneList = ['(UTC+5:30) Kolkata','(UTC+08:00) Perth','(UTC+13:00) Samoa','(UTC-06:00) US&Canada','(UTC+01:00) Amsterdam, Berlin, Rome, Vienna','(UTC+00:00) Dublin, Lisbon, London'];


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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(bgColor),
        bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(children: <Widget>[
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: HexColor('#8c3ee9'),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(btnCancel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)))),
              SizedBox(width: 15),
              Expanded(
                  child: GestureDetector(
                      onTap: () => next(),
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: HexColor('#8c3ee9'),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(btnNext,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)))))
            ])),
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
                        Text(titleBasicInfo,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 20.0),
                        Text(labelEventName,
                            style: (TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 4.0),
                        _eventNameInput(),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(labelCarnivalName,
                                            textAlign: TextAlign.left,
                                            style: (TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: montserratBoldFont))),
                                        SizedBox(height: 4.0),
                                        InkWell(onTap: () {
                                          _onCarnivalButtonPressed();
                                        }, child: Container(
                                          height: 48,
                                          padding: EdgeInsets.only(left: 3.0),
                                          decoration: boxDecorationRectangle(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(selectedCarnival,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0),),),
                                        ),),
                                        // _eventCarnivalNameInput(),
                                      ])),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(labelTimeZone,
                                            textAlign: TextAlign.left,
                                            style: (TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: montserratBoldFont))),
                                        SizedBox(height: 4.0),
                                        InkWell(onTap: () {
                                          _onTimeZoneButtonPressed();
                                        }, child: Container(
                                          height: 48,
                                          padding: EdgeInsets.only(left: 3.0),
                                          decoration: boxDecorationRectangle(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(selectedTimeZone,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0),),),
                                        ),),
                                      ]))
                            ]),
                        SizedBox(height: 10.0),
                        Text(labelTags,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 4.0),
                        _eventTagInput(),
                        SizedBox(height: 5)
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
                        Text(titleEventDate,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
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
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                                labelStartDate,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: (TextStyle(
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: FontWeight
                                                                        .normal,
                                                                    fontFamily: montserratBoldFont))),
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
                                                                labelStartTime,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: (TextStyle(
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: FontWeight
                                                                        .normal,
                                                                    fontFamily: montserratBoldFont))),
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
                                                                labelEndDate,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: (TextStyle(
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: FontWeight
                                                                        .normal,
                                                                    fontFamily: montserratBoldFont))),
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
                                                                labelEndTime,
                                                                textAlign: TextAlign
                                                                    .left,
                                                                style: (TextStyle(
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: FontWeight
                                                                        .normal,
                                                                    fontFamily: montserratBoldFont))),
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
                        Text(titleAddress,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 20.0),
                        Text(labelLocation,
                            style: (TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 4.0),
                        _eventLocationInput(),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(labelState,
                                            textAlign: TextAlign.left,
                                            style: (TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: montserratBoldFont))),
                                        SizedBox(height: 4.0),
                                        _eventStateInput(),
                                      ])),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(labelCity,
                                            textAlign: TextAlign.left,
                                            style: (TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: montserratBoldFont))),
                                        SizedBox(height: 4.0),
                                        _eventCityInput(),
                                      ]))
                            ]),
                        SizedBox(height: 10.0),
                        Text(labelPostalCode,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 4.0),
                        _eventPostalCodeInput(),
                        SizedBox(height: 5)
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
                        Text(titleDescription,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 20.0),
                        _eventDescriptionInput(),
                        SizedBox(height: 10.0),
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
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontSize:
                                                                  12.0)))));
                                            }).toList()))))
                      ]))),
        ]));
  }

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

  _eventNameInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventNameController,
                  onChanged: _basicBloc.eventNameInput,
                  hintText: inputHintEventName));

  _eventEndDateInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventEventEndDateController,
                  onChanged: _basicBloc.eventEndDateInput,
                  hintText: inputHintDate));
  _eventEndTimeInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventEventEndTimeController,
                  onChanged: _basicBloc.eventEndTimeInput,
                  hintText: inputHintTime));


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
                  hintText: inputHintTag));

  _eventStartDateInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventStartDateController,
                  onChanged: _basicBloc.eventStartDateInput,
                  hintText: inputHintDate));

  _eventStartTimeInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventStartTimeController,
                  onChanged: _basicBloc.eventStartTimeInput,
                  hintText: inputHintTime));

  _eventLocationInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventLocationController,
                  onChanged: _basicBloc.eventLocationInput,
                  hintText: inputHintTypeYourLocation));

  _eventStateInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventStateController,
                  onChanged: _basicBloc.eventStateInput,
                  hintText: labelSelectState));

  _eventCityInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventCityController,
                  onChanged: _basicBloc.eventCityInput,
                  hintText: labelTypeCityName));

  _eventPostalCodeInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventPostalCodeController,
                  onChanged: _basicBloc.eventPostalCodeInput,
                  hintText: labelTypePostalCode));

  _eventDescriptionInput() =>
      BlocBuilder(
          bloc: _basicBloc,
          builder: (BuildContext context, BasicState state) =>
              widget.inputFieldRectangle(_eventDescriptionController,
                  onChanged: _basicBloc.eventDescriptionInput,
                  hintText: inputHintDescription));

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
                          style: TextStyle(
                              fontWeight: FontWeight.w500)),),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w500)),),
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
                    HexColor(colorProgressBar))))
            : carnivalList(snapshot.carnivalList));
  }
}
