import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: bgColor,
        floatingActionButton: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: bgColorFloatingActionButton,
            onPressed: () => Navigator.pushNamed(context, eventMenuRoute),
            child: Icon(
              isPlatformAndroid ? Icons.add : CupertinoIcons.add,
              size: 48.0,
            )),
        body: Column(children: <Widget>[
          Container(
              child: Center(
                  child: Text(AppLocalizations
                      .of(context)
                      .titleDashboard,
                      style: Theme
                          .of(context)
                          .appBarTheme
                          .textTheme
                          .title)),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter:
                    ColorFilter.mode(colorHeaderBgFilter, BlendMode.srcATop),
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
                            _category(Icons.account_balance_wallet, "COUPONS"),
                            _category(Icons.note_add, "ADD ONS"),
                            _category(Icons.note, "REPORTS"),
                            _category(Icons.people, "STAFF")
                          ])
                        ])),
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _categoryCounter('Ticket Sold', '00'),
                            SizedBox(width: 10),
                            _categoryCounter('Upcoming Events', '00')
                          ]),
                      const SizedBox(height: 5),
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle,
                    )),
                _upComingEvents()
              ]))
        ]));
  }

  _category(IconData iconData, String name) =>
      Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Container(
          width: MediaQuery.of(context).size.width / 4.5,
          padding: new EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData, size: 18, color: colorIconSecondary),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead,
                )
              ])));

  _categoryCounter(String name, String counter) => Card(
      color: bgColorSecondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Container(
          width: MediaQuery.of(context).size.width / 2.3,
          padding: new EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(counter, style: Theme
                    .of(context)
                    .textTheme
                    .subtitle),
                SizedBox(height: 10),
                Text(name, style: Theme
                    .of(context)
                    .textTheme
                    .subhead)
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
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
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
                          Text(
                            'Event Title',
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle,
                          ),
                          const SizedBox(height: 2.0),
                          Row(children: <Widget>[
                            Icon(Icons.calendar_today, size: 15.0),
                            const SizedBox(width: 3.0),
                            Text(
                              '15-06-2020',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(
                                color: colorTextSubhead,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 15.0),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: <Widget>[
                                  Icon(Icons.image_aspect_ratio, size: 15.0),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    '0/200',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                      color: colorTextSubhead,
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Icon(Icons.visibility, size: 15.0),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    '1000',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                      color: colorTextSubhead,
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Icon(Icons.visibility, size: 15.0),
                                  const SizedBox(width: 3.0),
                                  Align(
                                    child: Text(
                                      '00',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                        color: colorTextSubhead,
                                      ),
                                    ),
                                  )
                                ])
                              ])
                        ])))
          ])));
}
