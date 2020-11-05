import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:flutter/material.dart';

class BasicState {
  final String authToken;
  final String eventFreqName, eventPrivacy;
  final List<MenuCustom> eventFreqList;
  final List<MenuCustom> eventPrivacyList;
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
  final String status;
  final bool loading;
  dynamic uiMsg;
  final int selectedTab;
  bool uploadRequired;
  bool fullRefresh;

  BasicState({
    this.authToken,
    this.eventFreqName,
    this.eventFreqList,
    this.eventPrivacy,
    this.eventPrivacyList,
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
    this.status,
    this.loading,
    this.uiMsg,
    this.selectedTab,
    this.uploadRequired,
    this.fullRefresh,
  });

  factory BasicState.initial() {
    return BasicState(
      authToken: '',
      eventFreqName: '',
      eventFreqList: [],
      eventPrivacy: '',
      eventPrivacyList: [],
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
      status: '',
      loading: false,
      uiMsg: null,
      selectedTab: 0,
      uploadRequired: false,
      fullRefresh: false,
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
      error: null,
      selectedTab: 0,
      uploadRequired: false,
      fullRefresh: false,
    );
  }*/

  BasicState copyWith({
    String authToken,
    String eventFrequency,
    List<MenuCustom> eventFreqList,
    String eventPrivacy,
    List<MenuCustom> eventPrivacyList,
    String eventName,
    String eventType,
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
    String status,
    bool loading,
    dynamic uiMsg,
    int selectedTab,
    bool uploadRequired,
    bool fullRefresh,
  }) {
    return BasicState(
      authToken: authToken ?? this.authToken,
      eventFreqName: eventFrequency ?? this.eventFreqName,
      eventFreqList: eventFreqList ?? this.eventFreqList,
      eventPrivacy: eventPrivacy ?? this.eventPrivacy,
      eventPrivacyList: eventPrivacyList ?? this.eventPrivacyList,
      eventName: eventName ?? this.eventName,
      eventType: eventType ?? this.eventType,
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
      status: status ?? this.status,
      loading: loading ?? this.loading,
      uiMsg: uiMsg,
      selectedTab: selectedTab ?? this.selectedTab,
      uploadRequired: uploadRequired ?? this.uploadRequired,
      fullRefresh: fullRefresh ?? false,
    );
  }

  List<Carnivals> get activeCarnivalsList {
    return eventTypeList
        .where((carnival) =>
    carnival.isCarnivalActive &&
        DateTime.parse(carnival.endDate).isAfter(DateTime.now()))
        .toList();
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
