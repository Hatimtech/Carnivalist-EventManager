import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/user_profile_response.dart';
import 'package:eventmanagement/model/logindetail/login_detail_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  ApiProvider _apiProvider = ApiProvider();
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

  void updateLoginDetails(name, email, mobile, profilePic, callback) {
    add(UpdateUserDetails(
        name: name,
        email: email,
        mobile: mobile,
        profilePic: profilePic,
        callback: callback));
  }

  @override
  UserState get initialState => UserState.initial();

  @override
  Stream<UserState> mapEventToState(UserEvent event,) async* {
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
      await pref.clear();
    }

    if (event is UpdateUserDetails) {
      updateUserDetails(event);
    }

    if (event is UpdateUserResult) {
      if (event.success) {
        pref = await SharedPreferences.getInstance();
        pref.setString("username", event.name);
        pref.setString("mobile", event.mobile);
        pref.setString("profilePicture", event.profilePic);
        yield state.copyWith(
          mobile: pref.getString('mobile'),
          userName: pref.getString('username'),
          userId: pref.getString('userId'),
          authToken: pref.getString('authToken'),
          email: pref.getString('email'),
          address: pref.getString('address'),
          profilePicture: pref.getString('profilePicture'),
          isLogin: pref.getBool('isLogin'),
          uiMsg: event.uiMsg,
        );
      } else {
        yield state.copyWith(uiMsg: event.uiMsg);
      }
    }
  }

  Future<void> updateUserDetails(UpdateUserDetails event) async {
    final systemPath = await getSystemDirPath();
    if (isValid(event.profilePic) && event.profilePic.contains(systemPath)) {
      _apiProvider
          .uploadProfilePic(state.authToken, event.profilePic)
          .then((networkServiceResponse) async {
        if (networkServiceResponse.responseCode == ok200) {
          final userProfileResponse =
          networkServiceResponse.response as UserProfileResponse;
          if (userProfileResponse.code == apiCodeSuccess) {
            updateUserDetailJson(event);
          } else {
            add(UpdateUserResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
            event.callback(ERR_SOMETHING_WENT_WRONG);
          }
        } else {
          add(UpdateUserResult(false,
              uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(
              networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG);
        }
      });
    } else {
      updateUserDetailJson(event);
    }
  }

  void updateUserDetailJson(UpdateUserDetails event) {
    Map<String, dynamic> param = Map();
    param.putIfAbsent('name', () => event.name);
    param.putIfAbsent('mobileNumber', () => event.mobile);

    _apiProvider
        .updateUserDetails(state.authToken, param)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final userProfileRes =
        networkServiceResponse.response as UserProfileResponse;
        if (userProfileRes.code == apiCodeSuccess) {
          loginDetailApi(event, userProfileRes.message);
        } else {
          add(UpdateUserResult(false,
              uiMsg: userProfileRes.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(userProfileRes);
        }
      } else {
        add(UpdateUserResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in updateUserDetailJson--->$error');
      add(UpdateUserResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }

  void loginDetailApi(UpdateUserDetails event, String successMsg) {
    _apiProvider.getLoginDetail(state.authToken).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final loginDetailResponse =
        networkServiceResponse.response as LoginDetailResponse;
        if (loginDetailResponse.code == apiCodeSuccess) {
          add(UpdateUserResult(
            true,
            uiMsg: successMsg,
            name: loginDetailResponse.loginDetail.name,
            mobile: loginDetailResponse.loginDetail.mobileNumber,
            profilePic: loginDetailResponse.loginDetail.avatar,
          ));
          event.callback(loginDetailResponse);
        } else {
          add(UpdateUserResult(false,
              uiMsg: loginDetailResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(loginDetailResponse, null);
        }
      } else {
        add(UpdateUserResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error, null);
      }
    }).catchError((error) {
      print('Error in loginDetailApi--->$error');
      add(UpdateUserResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG, null);
    });
  }
}
