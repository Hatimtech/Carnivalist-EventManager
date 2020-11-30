import 'dart:async';
import 'dart:io';

import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  createState() => new _SplashState();
}

class _SplashState extends State<SplashPage> {
  Duration five;
  Timer t2;
  String routeName;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.getLoginDetails();

    //TODO change timer screen duration
    five = const Duration(seconds: 3);
    t2 = new Timer(five, () => _loginGo());
  }

  void _deleteOldPdfFiles() async {
    Directory dir = new Directory('${await getSystemDirPath()}/user_downloads');
    if (dir.existsSync()) {
      List contents = dir.listSync();
      for (var fileOrDir in contents) {
        if (fileOrDir is File) {
          print(fileOrDir.path);
          fileOrDir.deleteSync();
        }
      }
    }
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
    t2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: new DecoratedBox(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/images/splash_backgroud.png"),
                    fit: BoxFit.fill))));
  }

  _loginGo() {
    _deleteOldPdfFiles();
    _userBloc.state.isLogin == true
        ? ((_userBloc.state.eventStaff ?? false)
        ? Navigator.pushReplacementNamed(context, bandStaffHomeRoute)
        : Navigator.pushReplacementNamed(context, bottomMenuRoute))
        : Navigator.pushReplacementNamed(context, loginRoute);
  }
}
