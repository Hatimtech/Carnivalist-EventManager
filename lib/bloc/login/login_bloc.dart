import 'package:bloc/bloc.dart';
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

      Map<String, dynamic> param = Map();
      param.putIfAbsent('username', () => state.mobile);
      param.putIfAbsent('password', () => state.password);
      param.putIfAbsent('userType', () => 'manager');

      await apiProvider.getLogin(param);

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var loginResponse = apiProvider.apiResult.response;
          if (loginResponse.code == apiCodeSuccess) {
            await apiProvider.getLoginDetail(loginResponse.token);
            if (apiProvider.apiResult.responseCode == ok200) {
              var loginDetailResponse = apiProvider.apiResult.response;
              event.callback(loginDetailResponse, loginResponse.token);
            }
          } else if (loginResponse.code == apiCodeError) {
            event.callback(loginResponse.message, '');
          }

          yield state.copyWith(
            loading: false,
          );
        } else {
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
