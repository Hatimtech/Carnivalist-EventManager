import 'package:eventmanagement/ui/cliper/circular_notched_rectangle_custom.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  @override
  createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(bgColor),
        floatingActionButton: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: HexColor(bgColorFloatingActionButton),
            onPressed: () => Navigator.pushNamed(context, eventMenuRoute),
            child: Icon(Icons.add)),
        body: Column(children: <Widget>[
          Container(
              child: Center(
                  child: Text(titleDashboard,
                      style: TextStyle(fontSize: 16, color: colorHeaderTitle))),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(headerBackgroundImage),
                fit: BoxFit.fitWidth,
              ))),
          Expanded(
              child: ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Wrap(spacing: 2.0, children: <Widget>[
                            _category("COUPONS"),
                            _category("ADD ONS"),
                            _category("REPORTS"),
                            _category("STAFF")
                          ])
                        ])),
                Container(
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _categoryCounter('Ticket Sold', '00'),
                            SizedBox(width: 10),
                            _categoryCounter('Upcoming Events', '00')
                          ]),
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _categoryCounter('COUPONS', '00'),
                            SizedBox(width: 10),
                            _categoryCounter('Addons', '00')
                          ])
                    ])),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Upcoming Events',
                      style: TextStyle(
                          fontSize: 16,
                          color: HexColor('#8c3ee9'),
                          fontWeight: FontWeight.bold),
                    )),
                _upComingEvents()
              ]))
        ]));
  }

  _category(String name) => Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Container(
          width: MediaQuery.of(context).size.width / 4.5,
          padding: new EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.calendar_today,
                    size: 18, color: HexColor('#8c3ee9')),
                SizedBox(height: 10),
                Text(name,
                    style: TextStyle(
                        fontSize: 9,
                        color: HexColor('#8c3ee9'),
                        fontWeight: FontWeight.bold))
              ])));

  _categoryCounter(String name, String counter) => Card(
      color: HexColor('#f4e6fa'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Container(
          width: MediaQuery.of(context).size.width / 2.3,
          padding: new EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(counter,
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor('#8c3ee9'),
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(name,
                    style: TextStyle(
                        fontSize: 9,
                        color: HexColor('#8c3ee9'),
                        fontWeight: FontWeight.bold))
              ])));

  _upComingEvents() => Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0), top: Radius.circular(10.0)),
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 0,
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.purple,
                        backgroundImage: NetworkImage(
                            'https://pbs.twimg.com/profile_images/470783207642632192/Zp8-uggw.jpeg'))),
                Expanded(
                    flex: 1,
                    child: Container(
                        margin: EdgeInsets.all(5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Event Title',
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: HexColor('#8c3ee9'),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 2.0),
                              Row(children: <Widget>[
                                Icon(Icons.calendar_today,
                                    color: HexColor('#8c3ee9'), size: 15.0),
                                SizedBox(width: 3.0),
                                Text('15-06-2020',
                                    style: new TextStyle(
                                        fontSize: 10.0,
                                        color: HexColor('#8c3ee9')))
                              ]),
                              SizedBox(height: 15.0),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: <Widget>[
                                      Icon(Icons.image_aspect_ratio,
                                          color: HexColor('#8c3ee9'),
                                          size: 15.0),
                                      SizedBox(width: 2.0),
                                      Text('0/200',
                                          style: new TextStyle(
                                              fontSize: 10.0,
                                              color: HexColor('#8c3ee9')))
                                    ]),
                                    Row(children: <Widget>[
                                      Icon(Icons.visibility,
                                          color: HexColor('#8c3ee9'),
                                          size: 15.0),
                                      SizedBox(width: 2.0),
                                      Text('1000',
                                          style: new TextStyle(
                                              fontSize: 10.0,
                                              color: HexColor('#8c3ee9')))
                                    ]),
                                    Row(children: <Widget>[
                                      Icon(Icons.visibility,
                                          color: HexColor('#8c3ee9'),
                                          size: 15.0),
                                      SizedBox(width: 3.0),
                                      Align(
                                          child: Text('00',
                                              style: new TextStyle(
                                                  fontSize: 10.0,
                                                  color: HexColor('#8c3ee9'))))
                                    ])
                                  ])
                            ])))
              ])));
}
