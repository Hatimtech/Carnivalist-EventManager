import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:flutter/material.dart';

abstract class BasicEvent {}

class EventFrequency extends BasicEvent {}

class AuthTokenSave extends BasicEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class BasicDefault extends BasicEvent {
  BasicDefault();
}

class PopulateExistingEvent extends BasicEvent {
  final EventData eventData;

  PopulateExistingEvent({this.eventData});
}

class EventTypeAvailable extends BasicEvent {
  final bool success;
  final dynamic error;
  final List<Carnivals> carnivalList;

  EventTypeAvailable(this.success, {this.error, this.carnivalList});
}

class SelectedTabChange extends BasicEvent {
  final int index;

  SelectedTabChange({this.index});
}

class SelectEventFrequency extends BasicEvent {
  final String eventFreq;

  SelectEventFrequency({this.eventFreq});
}

class SelectEventPrivacy extends BasicEvent {
  final String eventPrivacy;

  SelectEventPrivacy({this.eventPrivacy});
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

class EventBasicInfoUploadResult extends BasicEvent {
  final bool success;
  final dynamic uiMsg;

  EventBasicInfoUploadResult(this.success, {this.uiMsg});
}
