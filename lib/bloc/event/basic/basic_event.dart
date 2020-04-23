abstract class BasicEvent {}

class EventMenu extends BasicEvent {}

class AuthTokenSave extends BasicEvent {
  final String authToken;
  AuthTokenSave({this.authToken});
}

class SelectEventMenu extends BasicEvent {
  final String eventMenuName;
  SelectEventMenu({this.eventMenuName});
}

class PostType extends BasicEvent {}

class SelectPostType extends BasicEvent {
  final String postType;
  SelectPostType({this.postType});
}

class EventNameInput extends BasicEvent {
  final String eventName;
  EventNameInput({this.eventName});
}

class EventEndDateInput extends BasicEvent {
  final String eventEndDate;
  EventEndDateInput({this.eventEndDate});
}
class EventEndTimeInput extends BasicEvent {
  final String eventEndTime;
  EventEndTimeInput({this.eventEndTime});
}
class EventCarnivalInput extends BasicEvent {
  final String eventCarnival;
  EventCarnivalInput({this.eventCarnival});
}
class EventTimeZoneInput extends BasicEvent {
  final String eventTimeZone;
  EventTimeZoneInput({this.eventTimeZone});
}

class EventTagsInput extends BasicEvent {
  final String eventtags;
  EventTagsInput({this.eventtags});
}

class EventStartDateInput extends BasicEvent {
  final String eventStartDate;
  EventStartDateInput({this.eventStartDate});
}

class EventStartTimeInput extends BasicEvent {
  final String eventStartTime;
  EventStartTimeInput({this.eventStartTime});
}

class EventLocationInput extends BasicEvent {
  final String eventLocation;
  EventLocationInput({this.eventLocation});
}

class EventStateInput extends BasicEvent {
  final String eventState;
  EventStateInput({this.eventState});
}

class EventCityInput extends BasicEvent {
  final String eventCity;
  EventCityInput({this.eventCity});
}

class EventPostalCodeInput extends BasicEvent {
  final String eventPostalCode;
  EventPostalCodeInput({this.eventPostalCode});
}

class EventDescriptionInput extends BasicEvent {
  final String eventDescription;
  EventDescriptionInput({this.eventDescription});
}

class Basic extends BasicEvent {
  Function callback;
  Basic({this.callback});
}
class Carnival extends BasicEvent {
/*  Function callback;
  Basic({this.callback});*/
}