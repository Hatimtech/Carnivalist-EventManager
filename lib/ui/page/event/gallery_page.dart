import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: bgColor,
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
