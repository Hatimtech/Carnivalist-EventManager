import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog/create_fields_dialog.dart';

class FormsPage extends StatefulWidget {
  @override
  createState() => _FormsState();
}

class _FormsState extends State<FormsPage> {
  @override
  void initState() {
    super.initState();
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
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: HexColor('#8c3ee9'),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(btnNext,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400))))
            ])),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          color: HexColor(colorCreateEventBg),
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(5.0),
                          splashColor: Colors.black.withOpacity(0.2),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CreateFieldsDialog()),
                          child: Text(btnCreateFields,
                              style: TextStyle(color: Colors.white)))),
                  ListView(shrinkWrap: true, children: <Widget>[
                    Card(
                        margin: EdgeInsets.only(
                            top: 5, left: 0, right: 0, bottom: 5),
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: TextStyle(fontSize: 12))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          Text('Yes ',
                                              style: TextStyle(fontSize: 10))
                                        ]))
                              ])
                            ]))),
                    Card(
                        margin: EdgeInsets.only(
                            top: 5, left: 0, right: 0, bottom: 5),
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: TextStyle(fontSize: 12))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          Text('Yes ',
                                              style: TextStyle(fontSize: 10))
                                        ]))
                              ])
                            ]))),
                    Card(
                        margin: EdgeInsets.only(
                            top: 5, left: 0, right: 0, bottom: 5),
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: TextStyle(fontSize: 12))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          Text('Yes ',
                                              style: TextStyle(fontSize: 10))
                                        ]))
                              ])
                            ]))),
                    Card(
                        margin: EdgeInsets.only(
                            top: 5, left: 0, right: 0, bottom: 5),
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: TextStyle(fontSize: 12))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          Text('Yes ',
                                              style: TextStyle(fontSize: 10))
                                        ]))
                              ])
                            ])))
                  ])
                ]))));
  }
}
