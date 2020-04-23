import 'package:bloc/bloc.dart';
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

      Map<String, dynamic> param = Map();
      param.putIfAbsent('name', () => state.name);
      param.putIfAbsent('email', () => state.email);
      param.putIfAbsent('mobile', () => state.mobile);
      param.putIfAbsent('password', () => state.password);
      param.putIfAbsent('userType', () => 'manager');

      await apiProvider.getSignUp(param);

      try {
        var response = apiProvider.apiResult.response;

        if (apiProvider.apiResult.responseCode == ok200) {
          event.callback(response);
          yield state.copyWith(
            loading: false,
          );
        }
        else{
          yield state.copyWith(
            loading: false,
          );
        }
      } catch (e) {
        yield state.copyWith(
            loading: false
        );
      }
    }
  }
}
