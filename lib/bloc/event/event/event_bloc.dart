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

      await apiProvider.getAllEvents(state.authToken);
      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var eventResponse = apiProvider.apiResult.response as EventResponse;
          if (eventResponse.code == apiCodeSuccess) {
            yield state.copyWith(
              eventDataList: eventResponse.events,
              loading: false,
            );
          } else
            yield state.copyWith(
              loading: false,
            );
        } else {
          yield state.copyWith(
            loading: false,
          );
        }
      } catch (e) {
        yield state.copyWith(loading: false);
      }
    }

    if (event is DeleteEvent) {
      await apiProvider.deleteEvent(state.authToken, event.eventId);

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var eventActionResponse =
          apiProvider.apiResult.response as EventActionResponse;
          if (eventActionResponse.code == apiCodeSuccess) {
            state.eventDataList
                .removeWhere((eventData) => eventData.id == event.eventId);

            yield state.copyWith(
                eventDataList: List.of(state.eventDataList),
                toastMsg: eventActionResponse.message);

            event.callback(eventActionResponse);
          } else {
            yield state.copyWith(toastMsg: eventActionResponse.message);
            event.callback(null);
          }
        } else {
          yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
          event.callback(null);
        }
      } catch (e) {
        yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
        event.callback(null);
      }
    }

    if (event is ActiveInactiveEvent) {
      Map<String, dynamic> requestBody = HashMap();
      requestBody.putIfAbsent('eventId', () => event.eventId);
      requestBody.putIfAbsent('value', () => event.status);

      await apiProvider.activeInactiveEvent(
          state.authToken, requestBody, event.eventId);

      try {
        if (apiProvider.apiResult.responseCode == ok200) {
          var eventActionResponse =
          apiProvider.apiResult.response as EventActionResponse;
          if (eventActionResponse.code == apiCodeSuccess) {
            final eventData = state.eventDataList
                .firstWhere((eventData) => eventData.id == event.eventId);
            eventData.status = event.status;

            yield state.copyWith(
                eventDataList: List.of(state.eventDataList),
                toastMsg: eventActionResponse.message);

            event.callback(eventActionResponse);
          } else {
            yield state.copyWith(toastMsg: eventActionResponse.message);
            event.callback(null);
          }
        } else {
          yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
          event.callback(null);
        }
      } catch (e) {
        yield state.copyWith(errorCode: ERR_SOMETHING_WENT_WRONG);
        event.callback(null);
      }
    }
  }
}
