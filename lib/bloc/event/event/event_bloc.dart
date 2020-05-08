import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_main.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/model/event/event_action_response.dart';
import 'package:eventmanagement/model/event/event_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class EventBloc extends Bloc<EventMain, EventState> {
  final ApiProvider apiProvider = ApiProvider();

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void selectFilterValue(filter) {
    add(EventFilterValue(filter: filter));
  }

  void getAllEvents() {
    add(GetAllEvents());
  }

  void deleteEvent(String eventId, Function callback) {
    add(DeleteEvent(eventId, callback));
  }

  void activeInactiveEvent(String eventId, String status, Function callback) {
    add(ActiveInactiveEvent(eventId, status, callback));
  }

  @override
  EventState get initialState => EventState.initial();

  @override
  Stream<EventState> mapEventToState(EventMain event) async* {
    if (event is AuthTokenSave) {
      state.authToken = event.authToken;
    }
    if (event is EventFilterValue) {
      yield state.copyWith(eventCurrentFilter: event.filter);
    }
    if (event is GetAllEvents) {
      yield state.copyWith(loading: true);
      getAllEventsApi(event);
    }

    if (event is EventListAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        eventDataList: event.success ? event.eventList : null,
      );
    }

    if (event is DeleteEvent) {
      deleteEventApi(event);
    }

    if (event is DeleteEventResult) {
      if (event.success) {
        state.eventDataList
            .removeWhere((eventData) => eventData.id == event.eventId);

        yield state.copyWith(
            eventDataList: List.of(state.eventDataList),
            loading: false,
            uiMsg: event.uiMsg);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }

    if (event is ActiveInactiveEvent) {
      activeInactiveEventApi(event);
    }

    if (event is ActiveInactiveEventResult) {
      if (event.success) {
        final eventData = state.eventDataList
            .firstWhere((eventData) => eventData.id == event.eventId);
        eventData.status = event.status;

        yield state.copyWith(
            eventDataList: List.of(state.eventDataList),
            loading: false,
            uiMsg: event.uiMsg);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }
  }

  void getAllEventsApi(GetAllEvents event) {
    apiProvider.getAllEvents(state.authToken).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var eventResponse =
        networkServiceResponse.response as EventResponse;
        if (eventResponse.code == apiCodeSuccess)
          add(EventListAvailable(true,
              eventList: eventResponse.events));
        else
          add(EventListAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      } else {
        add(EventListAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
    }).catchError((error) {
      print('Error in getAllEventsApi--->$error');
      add(EventListAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
    });
  }

  void deleteEventApi(DeleteEvent event) {
    apiProvider
        .deleteEvent(state.authToken, event.eventId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
        networkServiceResponse.response as EventActionResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(DeleteEventResult(
            true,
            eventId: event.eventId,
            uiMsg: eventActionResponse.message,
          ));
          event.callback(eventActionResponse);
        } else {
          add(DeleteEventResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse);
        }
      } else {
        add(DeleteEventResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in deleteEventApi--->$error');
      add(DeleteEventResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }

  void activeInactiveEventApi(ActiveInactiveEvent event) {
    Map<String, dynamic> requestBody = HashMap();
    requestBody.putIfAbsent('eventId', () => event.eventId);
    requestBody.putIfAbsent('value', () => event.status);

    apiProvider
        .activeInactiveEvent(state.authToken, requestBody, event.eventId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
        networkServiceResponse.response as EventActionResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(ActiveInactiveEventResult(
            true,
            eventId: event.eventId,
            status: event.status,
            uiMsg: eventActionResponse.message,
          ));
          event.callback(eventActionResponse);
        } else {
          add(ActiveInactiveEventResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse.message);
        }
      } else {
        add(ActiveInactiveEventResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in activeInactiveEventApi--->$error');
      add(ActiveInactiveEventResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
