import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_event.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_state.dart';
import 'package:eventmanagement/model/eventdetails/event_detail_action_response.dart';
import 'package:eventmanagement/model/eventdetails/event_detail_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final ApiProvider apiProvider = ApiProvider();
  final String eventId;

  EventDetailBloc({this.eventId});

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void getEventDetail({Completer<bool> downloadCompleter}) {
    add(GetEventDetail(downloadCompleter: downloadCompleter));
  }

  void deleteCoupon(String id) {
    add(DeleteCoupon(id));
  }

  void attendeesResendTicket(String orderId, String email, Function callback) {
    add(ResendTicketEvent(orderId: orderId, email: email, callback: callback));
  }

  @override
  EventDetailState get initialState => EventDetailState.initial();

  @override
  Stream<EventDetailState> mapEventToState(EventDetailEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is GetEventDetail) {
      if (event.downloadCompleter == null) yield state.copyWith(loading: true);
      getEventDetailApi(event);
    }

    if (event is EventDetailAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        couponList: event.success ? event.couponList : null,
      );
    }

    if (event is ResendTicketEvent) {
      resendTicketApi(event);
    }

    if (event is ResendTicketEventResult) {
      if (!event.success) {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }
  }

  void getEventDetailApi(EventDetailEvent event) {
    apiProvider
        .getEventDetail(state.authToken, eventId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var couponResponse =
            networkServiceResponse.response as EventDetailResponse;
        if (couponResponse != null && couponResponse.code == apiCodeSuccess) {
          final couponsList = couponResponse.reports;
          add(EventDetailAvailable(true, couponList: couponsList));
        }
      } else {
        add(EventDetailAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
      if (event is GetEventDetail && event.downloadCompleter != null)
        event.downloadCompleter.complete(true);
    }).catchError((error, stack) {
      print('Error in getEventDetailApi--->$error\n$stack');
      add(EventDetailAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      if (event is GetEventDetail && event.downloadCompleter != null)
        event.downloadCompleter.complete(false);
    });
  }

  void resendTicketApi(ResendTicketEvent event) {
    Map<String, dynamic> requestBody = HashMap();
    requestBody.putIfAbsent('orderId', () => event.orderId);
    requestBody.putIfAbsent('email', () => event.email);
    apiProvider
        .attendeesResendTicket(state.authToken, requestBody)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
            networkServiceResponse.response as EventDetailActionResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(ResendTicketEventResult(
            true,
            uiMsg: eventActionResponse.message,
          ));
          event.callback(eventActionResponse);
        } else {
          add(ResendTicketEventResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse.message);
        }
      } else {
        add(ResendTicketEventResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in resendTicketApi--->$error');
      add(ResendTicketEventResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
