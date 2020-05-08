import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final ApiProvider apiProvider = ApiProvider();

  void nameInput(name) {
    add(NameInput(name: name));
  }

  void mobileInput(mobile) {
    add(MobileInput(mobile: mobile));
  }

  void emailInput(email) {
    add(EmailInput(email: email));
  }

  void passwordInput(password) {
    add(PasswordInput(password: password));
  }

  void confirmPasswordInput(confirmPasswordInput) {
    add(ConfirmPasswordInput(confirmPasswordInput: confirmPasswordInput));
  }

  void signUp(callback) {
    add(SignUp(callback: callback));
  }

  @override
  SignUpState get initialState => SignUpState.initial();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is NameInput) {
      yield state.copyWith(name: event.name);
    }

    if (event is MobileInput) {
      yield state.copyWith(mobile: event.mobile);
    }

    if (event is EmailInput) {
      yield state.copyWith(email: event.email);
    }

    if (event is PasswordInput) {
      yield state.copyWith(password: event.password);
    }

    if (event is ConfirmPasswordInput) {
      yield state.copyWith(confirmPassword: event.confirmPasswordInput);
    }

    if (event is SignUp) {
      yield state.copyWith(loading: true);
      signupApi(event);
    }

    if (event is SignupResult) {
      if (event.success) {
        yield state.copyWith(loading: false);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }
  }

  void signupApi(SignUp event) {
    Map<String, dynamic> param = Map();
    param.putIfAbsent('name', () => state.name);
    param.putIfAbsent('email', () => state.email);
    param.putIfAbsent('mobile', () => state.mobile);
    param.putIfAbsent('password', () => state.password);
    param.putIfAbsent('userType', () => 'manager');

    apiProvider.getSignUp(param).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final signupResponse = networkServiceResponse.response as LoginResponse;
        if (signupResponse.code == apiCodeSuccess) {
          add(SignupResult(true));
          event.callback(signupResponse);
        } else {
          add(SignupResult(false,
              uiMsg: signupResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(signupResponse);
        }
      } else {
        add(SignupResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in signupApi--->$error');
      add(SignupResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
