import 'package:eventmanagement/model/event/event_data.dart';

abstract class EventMain {}

class AuthTokenSave extends EventMain {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class EventFilterValue extends EventMain {
  final String filter;

  EventFilterValue({this.filter});
}

class GetAllEvents extends EventMain {
  GetAllEvents();
}

class EventListAvailable extends EventMain {
  final bool success;
  final dynamic error;
  final List<EventData> eventList;

  EventListAvailable(this.success, {this.error, this.eventList});
}

class ActiveInactiveEvent extends EventMain {

  final String eventId;
  final String status;
  final Function callback;

  ActiveInactiveEvent(this.eventId, this.status, this.callback);
}

class ActiveInactiveEventResult extends EventMain {
  final bool success;
  final String eventId;
  final String status;
  final dynamic uiMsg;

  ActiveInactiveEventResult(this.success,
      {this.eventId, this.status, this.uiMsg});
}

class DeleteEvent extends EventMain {
  final String eventId;
  final Function callback;

  DeleteEvent(this.eventId, this.callback);
}

class DeleteEventResult extends EventMain {
  final bool success;
  final String eventId;
  final dynamic uiMsg;

  DeleteEventResult(this.success, {this.eventId, this.uiMsg});
}
