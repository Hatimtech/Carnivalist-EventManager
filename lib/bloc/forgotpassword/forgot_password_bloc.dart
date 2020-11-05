import 'package:bloc/bloc.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ApiProvider apiProvider = ApiProvider();

  ForgotPasswordBloc() : super(initialState);

  void mobileInput(mobile) {
    add(MobileInput(mobile: mobile));
  }

  void forgotPassword(callback) {
    add(ForgotPassword(callback: callback));
  }

  static ForgotPasswordState get initialState => ForgotPasswordState.initial();

  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    if (event is MobileInput) {
      yield state.copyWith(mobile: event.mobile);
    }

    if (event is ForgotPassword) {
      yield state.copyWith(loading: true);

      Map<String, dynamic> param = Map();
      param.putIfAbsent(emailParam, () => state.mobile);
      param.putIfAbsent(redirectParam, () => redirectUrlValue);

      final networkServiceResponse = await apiProvider.getForgotPassword(param);

      try {
        if (networkServiceResponse.responseCode == ok200) {
          var response = networkServiceResponse.response;
          event.callback(response);
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
