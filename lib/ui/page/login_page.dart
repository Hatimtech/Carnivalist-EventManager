import 'package:eventmanagement/bloc/login/login_bloc.dart';
import 'package:eventmanagement/bloc/login/login_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/logindetail/login_detail_response.dart';
import 'package:eventmanagement/ui/widget/labeled_checkbox.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validate = false;
  bool visible = true;

  LoginBloc _loginBloc;
  UserBloc _userBloc;

  final _focusNodePassword = FocusNode();

  @override
  void initState() {
    super.initState();

    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(key: _key, autovalidate: _validate, child: _loginBody()));
  }

  _loginBody() => Stack(children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover))),
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black.withOpacity(0.2),
            body: Center(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  _buildErrorReceiverEmptyBloc(),
                  const SizedBox(height: 40),
                  Image.asset(logoImage, scale: 2.0),
                  const SizedBox(height: 40),
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Card(
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: 15, bottom: 2, right: 15, left: 15),
                              child: Column(children: <Widget>[
                                Text(AppLocalizations
                                    .of(context)
                                    .titleSignIn,
                                    textAlign: TextAlign.center,
                                    style: (TextStyle(
                                        fontSize: 19,
                                        color: colorTitle,
                                        fontFamily: montserratBoldFont))),
                                _phoneEmailInput(),
                                _passwordInput(),
                                const SizedBox(height: 8.0),
                                _buildStaffLoginCheckbox(),
                                const SizedBox(height: 15),
                                _signInButton(),
                                RawMaterialButton(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .labelForgotPassword,
                                        style: TextStyle(
                                            color: colorTitle,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0)),
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.pushNamed(
                                          context, forgotPasswordRoute);
                                    })
                              ])),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.0,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          ))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .labelSignUp,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center))),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.pushNamed(context, signUpRoute);
                            }),
                        Container(width: 1, height: 10, color: Colors.white),
                        InkWell(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .labelBecomeAVendorPartner,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center))),
                            onTap: () {})
                      ])
                ]),
              ),
            ))
      ]);

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<LoginBloc, LoginState>(
        cubit: _loginBloc,
        buildWhen: (prevState, newState) => newState.uiMsg != null,
        builder: (context, state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            context.toast(errorMsg);

            state.uiMsg = null;
          }

          return const SizedBox.shrink();
        },
      );

  _phoneEmailInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(
            _phoneEmailController,
            onChanged: _loginBloc.mobileInput,
            labelText: AppLocalizations
                .of(context)
                .inputHintPhoneEmail,
            labelStyle: Theme
                .of(context)
                .textTheme
                .body1,
            validation: (value) =>
                validateEmail(value, AppLocalizations.of(context)),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            nextFocusNode: _focusNodePassword,
          ));

  _passwordInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(_passwordController,
              onChanged: _loginBloc.passwordInput,
              labelText: AppLocalizations
                  .of(context)
                  .inputHintPassword,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1,
              obscureText: visible,
              validation: (value) =>
                  validatePassword(value, AppLocalizations.of(context)),
              focusNode: _focusNodePassword,
              inkWell: InkWell(
                  child: Icon(
                      visible ? Icons.visibility_off : Icons.visibility),
                  onTap: () => setState(() => visible = !visible))));

  Widget _buildStaffLoginCheckbox() =>
      BlocBuilder<LoginBloc, LoginState>(
          cubit: _loginBloc,
          buildWhen: (prevState, newState) =>
          prevState.eventStaffLogin != newState.eventStaffLogin,
          builder: (BuildContext context, LoginState state) {
            return LabeledCheckbox(
              label: AppLocalizations
                  .of(context)
                  .labelEventStaffLogin,
              value: state.eventStaffLogin,
              padding: const EdgeInsets.all(0.0),
              onChanged: _loginBloc.eventStaffLoginInput,
            );
          });

  _signInButton() => GestureDetector(
      onTap: () => _loginValidate(),
      child: Container(
          height: 40,
          width: 110.0,
          child: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations
                  .of(context)
                  .btnSignIn
                  .toUpperCase(),
                  style: new TextStyle(color: Colors.white, fontSize: 14.0))),
          decoration: buttonBg()));

  _loginToApi() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _loginBloc.login((results, authToken) {
      context.hideProgress(context);

      if (results is LoginDetailResponse) {
        var loginDetailResponse = results;

        if (loginDetailResponse.code == apiCodeSuccess) {
          _userBloc.saveUserName(loginDetailResponse.loginDetail.name);
          _userBloc.saveLastName(loginDetailResponse.loginDetail.lastName);
          _userBloc.saveEmail(loginDetailResponse.loginDetail.email);
          _userBloc.saveMobile(loginDetailResponse.loginDetail.mobileNumber);
          _userBloc.saveProfilePicture(loginDetailResponse.loginDetail.avatar);
          _userBloc.saveUserId(loginDetailResponse.loginDetail.userId);
          _userBloc.saveDomainName(loginDetailResponse.loginDetail.domainName);
          _userBloc.saveEventStaff(_loginBloc.state.eventStaffLogin);
          _userBloc.savAuthToken(authToken);
          _userBloc.saveIsLogin(true);
          _userBloc.getLoginDetails();

          if (_loginBloc.state.eventStaffLogin ?? false) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                bandStaffHomeRoute, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                bottomMenuRoute, (Route<dynamic> route) => false);
          }
        }
      } else if (results is String) {
//        context.toast(results);

//        _phoneEmailController.clear();
//        _passwordController.clear();
      }
    });
  }

  _loginValidate() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _loginToApi();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
