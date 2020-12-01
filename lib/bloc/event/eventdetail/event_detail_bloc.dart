import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_event.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_state.dart';
import 'package:eventmanagement/model/eventdetails/event_detail_action_response.dart';
import 'package:eventmanagement/model/eventdetails/event_detail_response.dart';
import 'package:eventmanagement/model/eventdetails/tag_scanned_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final ApiProvider apiProvider = ApiProvider();
  final String eventId;

  EventDetailBloc({this.eventId}) : super(initialState);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void updateCurrentAttendeesFilter(filter) {
    add(CurrentAttendeesFilter(currentFilter: filter));
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

  void uploadNewScannedTag(String tag, bool isNFC, Function callback) {
    add(TagScannedEvent(tag: tag, isNFC: isNFC ?? false, callback: callback));
  }

  String get selectedEventId => eventId;

  static EventDetailState get initialState => EventDetailState.initial();

  @override
  Stream<EventDetailState> mapEventToState(EventDetailEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is CurrentAttendeesFilter) {
      yield state.copyWith(currentFilter: event.currentFilter);
    }

    if (event is GetEventDetail) {
      if (event.downloadCompleter == null) yield state.copyWith(loading: true);
      getEventDetailApi(event);
    }

    if (event is EventDetailAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        eventDetailList: event.success ? event.couponList : null,
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

    if (event is TagScannedEvent) {
      uploadScannedTagApi(event);
    }

    if (event is TagScannedEventResult) {
      if (event.success) {
        if (event.eventDetailId != null) {
          final item = state.eventDetailList.firstWhere(
                  (element) => element.id == event.eventDetailId,
              orElse: () => null);

          print('TagScannedEventResult item--->$item');
          if (item != null) {
            item.isEventAttended = true;
          }
          state.eventDetailList.remove(item);
          state.eventDetailList.insert(0, item);
        }
        yield state.copyWith(
          loading: false,
          uiMsg: event.uiMsg,
          eventDetailList: List.of(state.eventDetailList),
        );
      } else {
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

  void uploadScannedTagApi(TagScannedEvent event) {
    Map<String, dynamic> requestBody = HashMap();

    if (event.isNFC) {
      requestBody.putIfAbsent('userId', () => event.tag);
      requestBody.putIfAbsent('eventId', () => eventId);
    } else {
      try {
        var jsonDecode = json.decode(event.tag);
        requestBody.putIfAbsent('orderId', () => jsonDecode['orderId']);
        requestBody.putIfAbsent('ticketNo', () => jsonDecode['ticketId']);
      } catch (e) {
        add(TagScannedEventResult(
          false,
          uiMsg: "Invalid QR Code",
        ));
        event.callback(null);
        return;
      }
    }
    apiProvider
        .uploadTagScanned(state.authToken, requestBody, event.isNFC)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
        networkServiceResponse.response as TagScannedResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(TagScannedEventResult(true,
              uiMsg: eventActionResponse.message,
              eventDetailId: eventActionResponse.eventDetailId));
          event.callback(eventActionResponse);
        } else {
          add(TagScannedEventResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse.message);
        }
      } else {
        add(TagScannedEventResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error, stack) {
      print('Error in uploadScannedTagApi--->$error\n$stack');
      add(TagScannedEventResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
