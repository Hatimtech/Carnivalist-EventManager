import 'dart:async';
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
    _userBloc.state.isLogin == true
        ? Navigator.pushReplacementNamed(context, bottomMenuRoute)
        : Navigator.pushReplacementNamed(context, loginRoute);
  }
}
