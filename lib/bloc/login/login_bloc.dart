import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/model/logindetail/login_detail_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiProvider apiProvider = ApiProvider();

  void mobileInput(mobile) {
    add(MobileInput(mobile: mobile));
  }

  void passwordInput(password) {
    add(PasswordInput(password: password));
  }

  void login(callback) {
    add(Login(callback: callback));
  }

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is MobileInput) {
      yield state.copyWith(mobile: event.mobile);
    }

    if (event is PasswordInput) {
      yield state.copyWith(password: event.password);
    }

    if (event is Login) {
      yield state.copyWith(loading: true);
      loginApi(event);
    }

    if (event is LoginResult) {
      if (event.success) {
        yield state.copyWith(loading: false);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }
  }

  void loginApi(Login event) {
    Map<String, dynamic> param = Map();
    param.putIfAbsent('username', () => state.mobile);
    param.putIfAbsent('password', () => state.password);
    param.putIfAbsent('userType', () => 'manager');

    apiProvider.getLogin(param).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final loginResponse = networkServiceResponse.response as LoginResponse;
        if (loginResponse.code == apiCodeSuccess) {
          loginDetailApi(event, loginResponse.token);
        } else {
          add(LoginResult(false,
              uiMsg: loginResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(loginResponse, null);
        }
      } else {
        add(LoginResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error, null);
      }
    }).catchError((error) {
      print('Error in loginApi--->$error');
      add(LoginResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG, null);
    });
  }

  void loginDetailApi(Login event, String authToken) {
    apiProvider.getLoginDetail(authToken).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final loginDetailResponse =
        networkServiceResponse.response as LoginDetailResponse;
        if (loginDetailResponse.code == apiCodeSuccess) {
          add(LoginResult(true));
          event.callback(loginDetailResponse, authToken);
        } else {
          add(LoginResult(false,
              uiMsg: loginDetailResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(loginDetailResponse, null);
        }
      } else {
        add(LoginResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error, null);
      }
    }).catchError((error) {
      print('Error in loginDetailApi--->$error');
      add(LoginResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG, null);
    });
  }
}
