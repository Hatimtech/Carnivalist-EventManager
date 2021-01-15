import 'package:eventmanagement/bloc/signup/sign_up_bloc.dart';
import 'package:eventmanagement/bloc/signup/sign_up_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/service/network/network_service.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _domainNameController = TextEditingController();

  final _focusNodeLastName = FocusNode();
  final _focusNodePhone = FocusNode();
  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();
  final _focusNodeConfirmPassword = FocusNode();
  final _focusNodeDomainName = FocusNode();

  bool _validate = false;
  bool visible = true;

  SignUpBloc _signUpBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
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
          body: Form(key: _key, autovalidate: _validate, child: _signUpBody()))
    ]));
  }

  _signUpBody() =>
      Center(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            _buildErrorReceiverEmptyBloc(),
            const SizedBox(
              height: 16.0,
            ),
            Image.asset(logoImage, scale: 2.0),
            Padding(
              padding:
              const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Card(
                  child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .titleSignUp,
                            textAlign: TextAlign.center,
                            style: (TextStyle(
                                fontSize: 19,
                                color: colorTitle,
                                fontFamily: montserratBoldFont))),
                        _firstNameInput(),
                        _lastNameInput(),
                        _phoneNoInput(),
                        _emailInput(),
                        _passwordInput(),
                        _confirmPasswordInput(),
                        _domainNameInput(),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _exampleDomain(),
                        ),
                        const SizedBox(height: 15),
                        _signUpButton(),
                        RawMaterialButton(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                AppLocalizations
                                    .of(context)
                                    .labelSignUpAgreement,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: colorTitle, fontSize: 10.0)),
                            onPressed: () {})
                      ])),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              InkWell(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              AppLocalizations
                                  .of(context)
                                  .labelAlredyAccount,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center)))),
              InkWell(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(AppLocalizations
                              .of(context)
                              .labelSignIn,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center))),
                  onTap: () => Navigator.pop(context))
            ])
          ]),
        ),
      );

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<SignUpBloc, SignUpState>(
        cubit: _signUpBloc,
        buildWhen: (prevState, newState) => newState.uiMsg != null,
        builder: (context, state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            context.toast(errorMsg);

            state.uiMsg = null;
          }

          return SizedBox.shrink();
        },
      );

  _firstNameInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(
            _firstNameController,
            labelText: AppLocalizations
                .of(context)
                .inputHintFirstName,
            labelStyle: Theme
                .of(context)
                .textTheme
                .body1,
            onChanged: _signUpBloc.nameInput,
            validation: (value) =>
                validateName(value, AppLocalizations.of(context)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            nextFocusNode: _focusNodeLastName,
          ));

  _lastNameInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(
            _lastNameController,
            labelText: AppLocalizations
                .of(context)
                .inputHintLastName,
            labelStyle: Theme
                .of(context)
                .textTheme
                .body1,
            onChanged: _signUpBloc.lastNameInput,
            validation: (value) =>
                validateLastName(value, AppLocalizations.of(context)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            nextFocusNode: _focusNodePhone,
          ));

  _phoneNoInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(
            _phoneNoController,
            labelText: AppLocalizations
                .of(context)
                .inputHintPhoneNo,
            labelStyle: Theme
                .of(context)
                .textTheme
                .body1,
            onChanged: _signUpBloc.mobileInput,
            maxLength: 13,
            validation: (value) =>
                validateMobile(value, AppLocalizations.of(context)),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            focusNode: _focusNodePhone,
            nextFocusNode: _focusNodeEmail,
          ));

  _emailInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(
            _emailController,
            labelText: AppLocalizations
                .of(context)
                .inputHintEmail,
            labelStyle: Theme
                .of(context)
                .textTheme
                .body1,
            validation: (value) =>
                validateEmail(value, AppLocalizations.of(context)),
            keyboardType: TextInputType.emailAddress,
            onChanged: _signUpBloc.emailInput,
            textInputAction: TextInputAction.next,
            focusNode: _focusNodeEmail,
            nextFocusNode: _focusNodePassword,
          ));

  _passwordInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(_passwordController,
              labelText: AppLocalizations
                  .of(context)
                  .inputHintPassword,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1,
              onChanged: _signUpBloc.passwordInput,
              validation: (value) =>
                  validatePassword(value, AppLocalizations.of(context)),
              maxLength: 20,
              obscureText: visible,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodePassword,
              nextFocusNode: _focusNodeConfirmPassword,
              inkWell: InkWell(
                  child: Icon(
                      visible ? Icons.visibility_off : Icons.visibility),
                  onTap: () => setState(() => visible = !visible))));

  _confirmPasswordInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(_confirmPasswordController,
              labelText: AppLocalizations
                  .of(context)
                  .inputHintConfirmPassword,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1,
              onChanged: _signUpBloc.passwordInput,
              focusNode: _focusNodeConfirmPassword,
              obscureText: visible,
              validation: (confirmation) {
                return confirmation.isEmpty
                    ? AppLocalizations
                    .of(context)
                    .errorConfirmPassword
                    : confirmation.length < 4
                    ? AppLocalizations
                    .of(context)
                    .errorConfirmPasswordLength
                    : validationEqual(confirmation, _passwordController.text)
                    ? null
                    : AppLocalizations
                    .of(context)
                    .errorConfirmPasswordMatch;
              },
              textInputAction: TextInputAction.next,
              nextFocusNode: _focusNodeDomainName,
              maxLength: 20,
              inkWell: InkWell(
                  child: Icon(
                      visible ? Icons.visibility_off : Icons.visibility),
                  onTap: () => setState(() => visible = !visible))));

  _domainNameInput() =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: widget.inputField(
            _domainNameController,
            labelText: AppLocalizations
                .of(context)
                .inputHintDomainName,
            labelStyle: Theme
                .of(context)
                .textTheme
                .body1,
            onChanged: _signUpBloc.domainNameInput,
//            validation: (value) =>
//                validateDomainName(value, AppLocalizations.of(context)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _focusNodeDomainName,
          ));

  _exampleDomain() =>
      Text(
        'Example: https://james.${NetworkService.exampleDomain}/events',
        style: const TextStyle(color: Color(0xFF0000EE), fontSize: 12.0),
      );

  _signUpButton() => GestureDetector(
      onTap: () => _signUpValidate(),
      child: Container(
          height: 40,
          width: 110.0,
          child: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations
                  .of(context)
                  .btnSignUp
                  .toUpperCase(),
                  style: new TextStyle(color: Colors.white, fontSize: 14.0))),
          decoration: buttonBg()));

  _signUpValidate() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _signUpToApi();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  _signUpToApi() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _signUpBloc.signUp((results) {
      context.hideProgress(context);

      if (results is LoginResponse) {
        if (results.code == apiCodeSuccess) {
//          _userBloc.saveUserName(_firstNameController.text);
//          _userBloc.saveEmail(_emailController.text);
//          _userBloc.saveMobile(_phoneNoController.text);
//          _userBloc.saveProfilePicture('');
//          _userBloc.saveUserId('');
//          _userBloc.savAuthToken(results.token);
//          _userBloc.saveIsLogin(true);
//          _userBloc.getLoginDetails();
          context.toast(AppLocalizations
              .of(context)
              .signupSuccess);
          Navigator.of(context).pushReplacementNamed(loginRoute);
        }
      }
    });
  }
}
