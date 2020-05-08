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

class ActiveInactiveEvent extends EventMain {

  final String eventId;
  final String status;
  final Function callback;

  ActiveInactiveEvent(this.eventId, this.status, this.callback);
}

class DeleteEvent extends EventMain {
  final String eventId;
  final Function callback;

  DeleteEvent(this.eventId, this.callback);
}
