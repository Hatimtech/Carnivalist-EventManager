import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  SharedPreferences pref;

  void saveUserId(userId) {
    add(SaveUserId(userId: userId));
  }

  void savAuthToken(authToken) {
    add(SavAuthToken(authToken: authToken));
  }

  void saveUserName(username) {
    add(SaveUserName(username: username));
  }

  void saveMobile(mobile) {
    add(SaveMobile(mobile: mobile));
  }

  void saveEmail(email) {
    add(SaveEmail(email: email));
  }

  void saveAddress(address) {
    add(SaveAddress(address: address));
  }

  void saveProfilePicture(profilePicture) {
    add(SaveProfilePicture(profilePicture: profilePicture));
  }

  void saveIsLogin(isLogin) {
    add(SaveIsLogin(isLogin: isLogin));
  }

  void getLoginDetails() {
    add(GetLoginDetails());
  }

  void clearLoginDetails() {
    add(ClearLoginDetails());
  }

  @override
  UserState get initialState => UserState.initial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SaveUserName) {
      pref = await SharedPreferences.getInstance();
      pref.setString("username", event.username);
    }

    if (event is SaveEmail) {
      pref = await SharedPreferences.getInstance();
      pref.setString("email", event.email);
    }

    if (event is SaveMobile) {
      pref = await SharedPreferences.getInstance();
      pref.setString("mobile", event.mobile);
    }

    if (event is SaveUserId) {
      pref = await SharedPreferences.getInstance();
      pref.setString("userId", event.userId);
    }

    if (event is SavAuthToken) {
      pref = await SharedPreferences.getInstance();
      pref.setString("authToken", event.authToken);
    }

    if (event is SaveIsLogin) {
      pref = await SharedPreferences.getInstance();
      pref.setBool("isLogin", event.isLogin);
    }

    if (event is SaveAddress) {
      pref = await SharedPreferences.getInstance();
      pref.setString("address", event.address);
    }

    if (event is SaveProfilePicture) {
      pref = await SharedPreferences.getInstance();
      pref.setString("profilePicture", event.profilePicture);
    }

    //GET LOGIN DETAILS
    if (event is GetLoginDetails) {
      pref = await SharedPreferences.getInstance();
      yield state.copyWith(
          mobile: pref.getString('mobile'),
          userName: pref.getString('username'),
          userId: pref.getString('userId'),
          authToken: pref.getString('authToken'),
          email: pref.getString('email'),
          address: pref.getString('address'),
          profilePicture: pref.getString('profilePicture'),
          isLogin: pref.getBool('isLogin'));
    }

    //CLEAR LOGIN DETAILS
    if (event is ClearLoginDetails) {
      pref = await SharedPreferences.getInstance();
      bool loginCleared = await pref.clear();
      print('Login Cleared--->$loginCleared');
    }
  }
}
