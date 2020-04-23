import 'package:eventmanagement/ui/cliper/bubble_indication_painter.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';

class GalleryPage extends StatefulWidget {
  @override
  createState() => _GalleryState();
}

class _GalleryState extends State<GalleryPage> {
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
                      child: Text(btnPrevious,
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
                  Stack(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor('#f7e4fc'),
                          borderRadius: BorderRadius.circular(5)),
                      height: 180,
                    ),
                    Positioned.fill(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Image.asset('assets/images/gallry_upload.png',
                              scale: 2.5),
                          SizedBox(width: 5),
                          Text('Upload your banner image',
                              style: TextStyle(
                                  fontSize: 12, color: HexColor('#8c3ee9')))
                        ]))
                  ]),

                ]))));
  }
}
