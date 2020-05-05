import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:flutter/material.dart';

class BasicState {
  final String authToken;
  final String eventMenuName, postType;
  final List<MenuCustom> eventMenuList;
  final List<MenuCustom> postTypeList;
  final String eventName;
  final String eventType;
  final String eventTimeZone;
  final List<String> eventTags;
  final DateTime eventStartDate;
  final TimeOfDay eventStartTime;
  final DateTime eventEndDate;
  final TimeOfDay eventEndTime;
  final String eventWeekday;
  final String eventLocation;
  final String eventState;
  final String eventCity;
  final String eventPostalCode;
  final String eventDescription;
  final List<Carnivals> eventTypeList;
  final List<EventCustomDate> eventCustomDateTimeList;
  final bool loading;
  int errorCode;
  int selectedTab;
  bool uploadRequired;

  BasicState({
    this.authToken,
    this.eventMenuName,
    this.eventMenuList,
    this.postType,
    this.postTypeList,
    this.eventName,
    this.eventType,
    this.eventTimeZone,
    this.eventTags,
    this.eventStartDate,
    this.eventStartTime,
    this.eventEndDate,
    this.eventEndTime,
    this.eventWeekday,
    this.eventLocation,
    this.eventState,
    this.eventCity,
    this.eventPostalCode,
    this.eventDescription,
    this.eventTypeList,
    this.eventCustomDateTimeList,
    this.loading,
    this.errorCode,
    this.selectedTab,
    this.uploadRequired,
  });

  /* BasicState(
      {this.loading,
      this.eventMenuName,
      this.eventMenuList,
      this.postType,
      this.postTypeList});*/

  factory BasicState.initial() {
    return BasicState(
      authToken: '',
      eventMenuName: '',
      eventMenuList: List(),
      postType: '',
      postTypeList: List(),
      eventName: '',
      eventType: '',
      eventTimeZone: '',
      eventTags: [],
      eventStartDate: null,
      eventStartTime: null,
      eventEndDate: null,
      eventEndTime: null,
      eventWeekday: null,
      eventLocation: '',
      eventState: '',
      eventCity: '',
      eventPostalCode: '',
      eventDescription: '',
      eventTypeList: List(),
      eventCustomDateTimeList: [],
      loading: false,
      errorCode: null,
      selectedTab: 0,
      uploadRequired: false,
    );
  }

  /*factory BasicState.initial() {
    return BasicState(
      authToken: '',
      eventMenuName: '',
      eventMenuList: List(),
      postType: '',
      postTypeList: List(),
      eventName: 'Mobile Event',
      eventType: 'Winter Carnival',
      eventTimeZone: '(+11:00) Australia/Hobart',
      eventTags: ['mob 1', 'mob 2'],
      eventStartDate: DateTime(2020, 30, 4),
      eventStartTime: TimeOfDay(hour: 17, minute: 00),
      eventEndDate: DateTime(2020, 30, 4),
      eventEndTime: TimeOfDay(hour: 18, minute: 00),
      eventWeekday: null,
      eventLocation: 'Kolar Road',
      eventState: 'MP',
      eventCity: 'Bhopal',
      eventPostalCode: '462042',
      eventDescription: 'Mobile Event Description',
      eventTypeList: List(),
      eventCustomDateTimeList: [],
      loading: false,
      errorCode: null,
      selectedTab: 0,
      uploadRequired: false,
    );
  }*/

  BasicState copyWith({
    String authToken,
    String eventMenuName,
    List<MenuCustom> eventMenuList,
    String postType,
    List<MenuCustom> postTypeList,
    String eventName,
    String eventCarnival,
    String eventTimeZone,
    List<String> eventTags,
    DateTime eventStartDate,
    TimeOfDay eventStartTime,
    DateTime eventEndDate,
    TimeOfDay eventEndTime,
    String eventWeekday,
    String eventLocation,
    String eventState,
    String eventCity,
    String eventPostalCode,
    String eventDescription,
    List<Carnivals> eventTypeList,
    List<EventCustomDate> eventCustomDateTimeList,
    bool loading,
    int errorCode = null,
    int selectedTab,
    bool uploadRequired,
  }) {
    return BasicState(
      authToken: authToken ?? this.authToken,
      eventMenuName: eventMenuName ?? this.eventMenuName,
      eventMenuList: eventMenuList ?? this.eventMenuList,
      postType: postType ?? this.postType,
      postTypeList: postTypeList ?? this.postTypeList,
      eventName: eventName ?? this.eventName,
      eventType: eventCarnival ?? this.eventType,
      eventTimeZone: eventTimeZone ?? this.eventTimeZone,
      eventTags: eventTags ?? this.eventTags,
      eventStartDate: eventStartDate ?? this.eventStartDate,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      eventEndTime: eventEndTime ?? this.eventEndTime,
      eventWeekday: eventWeekday ?? this.eventWeekday,
      eventLocation: eventLocation ?? this.eventLocation,
      eventState: eventState ?? this.eventState,
      eventCity: eventCity ?? this.eventCity,
      eventPostalCode: eventPostalCode ?? this.eventPostalCode,
      eventDescription: eventDescription ?? this.eventDescription,
      eventTypeList: eventTypeList ?? this.eventTypeList,
      eventCustomDateTimeList:
      eventCustomDateTimeList ?? this.eventCustomDateTimeList,
      loading: loading ?? this.loading,
      errorCode: errorCode,
      selectedTab: selectedTab ?? this.selectedTab,
      uploadRequired: uploadRequired ?? this.uploadRequired,
    );
  }
}

class EventCustomDate {
  final DateTime eventStartDateTime;
  final DateTime eventEndDateTime;

  EventCustomDate({
    this.eventStartDateTime,
    this.eventEndDateTime,
  });
}
