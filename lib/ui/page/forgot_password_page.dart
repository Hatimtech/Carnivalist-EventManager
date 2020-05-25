import 'package:eventmanagement/bloc/forgotpassword/forgot_password_bloc.dart';
import 'package:eventmanagement/bloc/forgotpassword/forgot_password_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneEmailController = TextEditingController();

  ForgotPasswordBloc _forgotPasswordBloc;
  bool _validate = false;

  @override
  void initState() {
    super.initState();

    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(children: [
      Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover))),
      Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black.withOpacity(0.2),
          body: Form(
              key: _key, autovalidate: _validate, child: _forgotPasswordBody()))
    ]));
  }

  _forgotPasswordBody() => ListView(children: <Widget>[
        SizedBox(height: 40),
        Image.asset(logoImage, scale: 2.0),
        SizedBox(height: 40),
        Container(
            margin: EdgeInsets.all(20),
            child: Card(
                child: Container(
                    margin: EdgeInsets.all(15),
                    child: Column(children: <Widget>[
                      Text(AppLocalizations
                          .of(context)
                          .titleForgotPassword,
                          textAlign: TextAlign.center,
                          style: (TextStyle(
                              fontSize: 19,
                              color: colorTitle,
                              fontFamily: montserratBoldFont))),
                      _emailInput(),
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _backButton(),
                            SizedBox(width: 15),
                            _resetButton()
                          ])
                    ])),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))))
      ]);

  _emailInput() => BlocBuilder(
      bloc: _forgotPasswordBloc,
      builder: (BuildContext context, ForgotPasswordState state) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(_phoneEmailController,
              onChanged: _forgotPasswordBloc.mobileInput,
              labelText: AppLocalizations
                  .of(context)
                  .inputHintPhoneEmail,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1,
              validation: (value) =>
                  validatePhoneEmail(value, AppLocalizations.of(context)),
              keyboardType: TextInputType.emailAddress)));

  _resetButton() => GestureDetector(
      onTap: () => _forgotPasswordValidate(),
      child: Container(
          height: 40,
          width: 110.0,
          child: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations
                  .of(context)
                  .btnReset
                  .toUpperCase(),
                  style: new TextStyle(color: Colors.white, fontSize: 14.0))),
          decoration: buttonBg()));

  _backButton() => GestureDetector(
      child: Container(
          height: 40,
          width: 110.0,
          child: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations
                  .of(context)
                  .btnBack
                  .toUpperCase(),
                  style: new TextStyle(color: Colors.white, fontSize: 14.0))),
          decoration: buttonBg()),
      onTap: () => Navigator.pop(context));

  _forgotPasswordToApi() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _forgotPasswordBloc.forgotPassword((results) {
      context.hideProgress(context);

      LoginResponse loginResponse = results;
      if (loginResponse.code == apiCodeSuccess) {
        FocusScope.of(context).requestFocus(FocusNode());
        context.toast(loginResponse.message);
        Navigator.pop(context);
      } else {
        context.toast(loginResponse.message);
      }
    });
  }

  _forgotPasswordValidate() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _forgotPasswordToApi();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
