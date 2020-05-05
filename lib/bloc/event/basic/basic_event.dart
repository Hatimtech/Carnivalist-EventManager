import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:flutter/material.dart';

abstract class BasicEvent {}

class EventMenu extends BasicEvent {}

class AuthTokenSave extends BasicEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class SelectedTabChange extends BasicEvent {
  final int index;

  SelectedTabChange({this.index});
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

class EventTypeInput extends BasicEvent {
  final String eventType;

  EventTypeInput({this.eventType});
}

class EventTimeZoneInput extends BasicEvent {
  final String eventTimeZone;

  EventTimeZoneInput({this.eventTimeZone});
}

class EventTagsInput extends BasicEvent {
  final String eventTag;

  EventTagsInput({this.eventTag});
}

class EventRemoveTag extends BasicEvent {
  final String eventTag;

  EventRemoveTag({this.eventTag});
}

class EventStartDateInput extends BasicEvent {
  final DateTime eventStartDate;

  EventStartDateInput({this.eventStartDate});
}

class EventStartTimeInput extends BasicEvent {
  final TimeOfDay eventStartTime;

  EventStartTimeInput({this.eventStartTime});
}

class EventEndDateInput extends BasicEvent {
  final DateTime eventEndDate;

  EventEndDateInput({this.eventEndDate});
}

class EventEndTimeInput extends BasicEvent {
  final TimeOfDay eventEndTime;

  EventEndTimeInput({this.eventEndTime});
}

class EventWeekdayInput extends BasicEvent {
  final String eventWeekday;

  EventWeekdayInput({this.eventWeekday});
}

class EventAddCustomDate extends BasicEvent {
  EventAddCustomDate();
}

class EventRemoveCustomDate extends BasicEvent {
  EventCustomDate eventCustomDate;

  EventRemoveCustomDate({this.eventCustomDate});
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
