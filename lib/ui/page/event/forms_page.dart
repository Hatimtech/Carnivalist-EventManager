import 'package:eventmanagement/intl/app_localizations.dart';
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
        backgroundColor: bgColor,
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  Align(
                      alignment: Alignment.topRight,
                      child: RaisedButton(
                          splashColor: Colors.black.withOpacity(0.2),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0.0),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CreateFieldsDialog()),
                          child: Text(
                              AppLocalizations
                                  .of(context)
                                  .btnCreateFields,
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
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2
                                                  .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )),
                                          Text('Yes ',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2)
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
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2
                                                  .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )),
                                          Text('Yes ',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2)
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
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2
                                                  .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )),
                                          Text('Yes ',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2)
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
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(height: 5),
                                          Text('Coppon: 3 Add ons: 2',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2
                                                  .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ))
                                        ])),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 2),
                                          Text('Mandatory',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              )),
                                          Text('Yes ',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body2)
                                        ]))
                              ])
                            ])))
                  ])
                ]))));
  }
}
