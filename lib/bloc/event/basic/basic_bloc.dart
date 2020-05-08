import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/model/event/carnivals/carnival_resonse.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'basic_event.dart';
import 'basic_state.dart';

class BasicBloc extends Bloc<BasicEvent, BasicState> {
  final ApiProvider apiProvider = ApiProvider();
  EventData mainEventData;
  String eventDataId;

  List<String> timeZoneList = [
    '(+01:00) Europe/Andorra',
    '(+04:00) Asia/Dubai',
    '(+04:30) Asia/Kabul',
    '(+01:00) Europe/Tirane',
    '(+04:00) Asia/Yerevan',
    '(-03:00) Antarctica/Rothera',
    '(-03:00) Antarctica/Palmer',
    '(+05:00) Antarctica/Mawson',
    '(+07:00) Antarctica/Davis',
    '(+08:00) Antarctica/Casey',
    '(+06:00) Antarctica/Vostok',
    '(+10:00) Antarctica/DumontDUrville',
    '(+03:00) Antarctica/Syowa',
    '(+00:00) Antarctica/Troll',
    '(-03:00) America/Argentina/Buenos_Aires',
    '(-03:00) America/Argentina/Cordoba',
    '(-03:00) America/Argentina/Salta',
    '(-03:00) America/Argentina/Jujuy',
    '(-03:00) America/Argentina/Tucuman',
    '(-03:00) America/Argentina/Catamarca',
    '(-03:00) America/Argentina/La_Rioja',
    '(-03:00) America/Argentina/San_Juan',
    '(-03:00) America/Argentina/Mendoza',
    '(-03:00) America/Argentina/San_Luis',
    '(-03:00) America/Argentina/Rio_Gallegos',
    '(-03:00) America/Argentina/Ushuaia',
    '(-11:00) Pacific/Pago_Pago',
    '(+01:00) Europe/Vienna',
    '(+11:00) Australia/Lord_Howe',
    '(+11:00) Antarctica/Macquarie',
    '(+11:00) Australia/Hobart',
    '(+11:00) Australia/Currie',
    '(+11:00) Australia/Melbourne',
    '(+11:00) Australia/Sydney',
    '(+10:30) Australia/Broken_Hill',
    '(+10:00) Australia/Brisbane',
    '(+10:00) Australia/Lindeman',
    '(+10:30) Australia/Adelaide',
    '(+09:30) Australia/Darwin',
    '(+08:00) Australia/Perth',
    '(+08:45) Australia/Eucla',
    '(+04:00) Asia/Baku',
    '(-04:00) America/Barbados',
    '(+06:00) Asia/Dhaka',
    '(+01:00) Europe/Brussels',
    '(+02:00) Europe/Sofia',
    '(-04:00) Atlantic/Bermuda',
    '(+08:00) Asia/Brunei',
    '(-04:00) America/La_Paz',
    '(-02:00) America/Noronha',
    '(-03:00) America/Belem',
    '(-03:00) America/Fortaleza',
    '(-03:00) America/Recife',
    '(-03:00) America/Araguaina',
    '(-03:00) America/Maceio',
    '(-03:00) America/Bahia',
    '(-02:00) America/Sao_Paulo',
    '(-03:00) America/Campo_Grande',
    '(-03:00) America/Cuiaba',
    '(-03:00) America/Santarem',
    '(-04:00) America/Porto_Velho',
    '(-04:00) America/Boa_Vista',
    '(-04:00) America/Manaus',
    '(-05:00) America/Eirunepe',
    '(-05:00) America/Rio_Branco',
    '(-05:00) America/Nassau',
    '(+06:00) Asia/Thimphu',
    '(+03:00) Europe/Minsk',
    '(-06:00) America/Belize',
    '(-03:30) America/St_Johns',
    '(-04:00) America/Halifax',
    '(-04:00) America/Glace_Bay',
    '(-04:00) America/Moncton',
    '(-04:00) America/Goose_Bay',
    '(-04:00) America/Blanc-Sablon',
    '(-05:00) America/Toronto',
    '(-05:00) America/Nipigon',
    '(-05:00) America/Thunder_Bay',
    '(-05:00) America/Iqaluit',
    '(-05:00) America/Pangnirtung',
    '(-06:00) America/Resolute',
    '(-05:00) America/Atikokan',
    '(-06:00) America/Rankin_Inlet',
    '(-06:00) America/Winnipeg',
    '(-06:00) America/Rainy_River',
    '(-06:00) America/Regina',
    '(-06:00) America/Swift_Current',
    '(-07:00) America/Edmonton',
    '(-07:00) America/Cambridge_Bay',
    '(-07:00) America/Yellowknife',
    '(-07:00) America/Inuvik',
    '(-07:00) America/Creston',
    '(-07:00) America/Dawson_Creek',
    '(-07:00) America/Fort_Nelson',
    '(-08:00) America/Vancouver',
    '(-08:00) America/Whitehorse',
    '(-08:00) America/Dawson',
    '(+06:30) Indian/Cocos',
    '(+01:00) Europe/Zurich',
    '(+00:00) Africa/Abidjan',
    '(-10:00) Pacific/Rarotonga',
    '(-03:00) America/Santiago',
    '(-05:00) Pacific/Easter',
    '(+08:00) Asia/Shanghai',
    '(+06:00) Asia/Urumqi',
    '(-05:00) America/Bogota',
    '(-06:00) America/Costa_Rica',
    '(-05:00) America/Havana',
    '(-01:00) Atlantic/Cape_Verde',
    '(-04:00) America/Curacao',
    '(+07:00) Indian/Christmas',
    '(+02:00) Asia/Nicosia',
    '(+01:00) Europe/Prague',
    '(+01:00) Europe/Berlin',
    '(+01:00) Europe/Copenhagen',
    '(-04:00) America/Santo_Domingo',
    '(+01:00) Africa/Algiers',
    '(-05:00) America/Guayaquil',
    '(-06:00) Pacific/Galapagos',
    '(+02:00) Europe/Tallinn',
    '(+02:00) Africa/Cairo',
    '(+00:00) Africa/El_Aaiun',
    '(+01:00) Europe/Madrid',
    '(+01:00) Africa/Ceuta',
    '(+00:00) Atlantic/Canary',
    '(+02:00) Europe/Helsinki',
    '(+12:00) Pacific/Fiji',
    '(-03:00) Atlantic/Stanley',
    '(+10:00) Pacific/Chuuk',
    '(+11:00) Pacific/Pohnpei',
    '(+11:00) Pacific/Kosrae',
    '(+00:00) Atlantic/Faroe',
    '(+01:00) Europe/Paris',
    '(+00:00) Europe/London',
    '(+04:00) Asia/Tbilisi',
    '(-03:00) America/Cayenne',
    '(+00:00) Africa/Accra',
    '(+01:00) Europe/Gibraltar',
    '(-03:00) America/Godthab',
    '(+00:00) America/Danmarkshavn',
    '(-01:00) America/Scoresbysund',
    '(-04:00) America/Thule',
    '(+02:00) Europe/Athens',
    '(-02:00) Atlantic/South_Georgia',
    '(-06:00) America/Guatemala',
    '(+10:00) Pacific/Guam',
    '(+00:00) Africa/Bissau',
    '(-04:00) America/Guyana',
    '(+08:00) Asia/Hong_Kong',
    '(-06:00) America/Tegucigalpa',
    '(-05:00) America/Port-au-Prince',
    '(+01:00) Europe/Budapest',
    '(+07:00) Asia/Jakarta',
    '(+07:00) Asia/Pontianak',
    '(+08:00) Asia/Makassar',
    '(+09:00) Asia/Jayapura',
    '(+00:00) Europe/Dublin',
    '(+02:00) Asia/Jerusalem',
    '(+05:30) Asia/Kolkata',
    '(+06:00) Indian/Chagos',
    '(+03:00) Asia/Baghdad',
    '(+03:30) Asia/Tehran',
    '(+00:00) Atlantic/Reykjavik',
    '(+01:00) Europe/Rome',
    '(-05:00) America/Jamaica',
    '(+02:00) Asia/Amman',
    '(+09:00) Asia/Tokyo',
    '(+03:00) Africa/Nairobi',
    '(+06:00) Asia/Bishkek',
    '(+12:00) Pacific/Tarawa',
    '(+13:00) Pacific/Enderbury',
    '(+14:00) Pacific/Kiritimati',
    '(+08:30) Asia/Pyongyang',
    '(+09:00) Asia/Seoul',
    '(-05:00) America/Cayman',
    '(+06:00) Asia/Almaty',
    '(+06:00) Asia/Qyzylorda',
    '(+05:00) Asia/Aqtobe',
    '(+05:00) Asia/Aqtau',
    '(+05:00) Asia/Oral',
    '(+02:00) Asia/Beirut',
    '(+05:30) Asia/Colombo',
    '(+00:00) Africa/Monrovia',
    '(+02:00) Europe/Vilnius',
    '(+01:00) Europe/Luxembourg',
    '(+02:00) Europe/Riga',
    '(+02:00) Africa/Tripoli',
    '(+00:00) Africa/Casablanca',
    '(+01:00) Europe/Monaco',
    '(+02:00) Europe/Chisinau',
    '(+12:00) Pacific/Majuro',
    '(+12:00) Pacific/Kwajalein',
    '(+06:30) Asia/Rangoon',
    '(+08:00) Asia/Ulaanbaatar',
    '(+07:00) Asia/Hovd',
    '(+08:00) Asia/Choibalsan',
    '(+08:00) Asia/Macau',
    '(-04:00) America/Martinique',
    '(+01:00) Europe/Malta',
    '(+04:00) Indian/Mauritius',
    '(+05:00) Indian/Maldives',
    '(-06:00) America/Mexico_City',
    '(-05:00) America/Cancun',
    '(-06:00) America/Merida',
    '(-06:00) America/Monterrey',
    '(-06:00) America/Matamoros',
    '(-07:00) America/Mazatlan',
    '(-07:00) America/Chihuahua',
    '(-07:00) America/Ojinaga',
    '(-07:00) America/Hermosillo',
    '(-08:00) America/Tijuana',
    '(-08:00) America/Santa_Isabel',
    '(-06:00) America/Bahia_Banderas',
    '(+08:00) Asia/Kuala_Lumpur',
    '(+08:00) Asia/Kuching',
    '(+02:00) Africa/Maputo',
    '(+02:00) Africa/Windhoek',
    '(+11:00) Pacific/Noumea',
    '(+11:00) Pacific/Norfolk',
    '(+01:00) Africa/Lagos',
    '(-06:00) America/Managua',
    '(+01:00) Europe/Amsterdam',
    '(+01:00) Europe/Oslo',
    '(+05:45) Asia/Kathmandu',
    '(+12:00) Pacific/Nauru',
    '(-11:00) Pacific/Niue',
    '(+13:00) Pacific/Auckland',
    '(+13:45) Pacific/Chatham',
    '(-05:00) America/Panama',
    '(-05:00) America/Lima',
    '(-10:00) Pacific/Tahiti',
    '(-09:30) Pacific/Marquesas',
    '(-09:00) Pacific/Gambier',
    '(+10:00) Pacific/Port_Moresby',
    '(+11:00) Pacific/Bougainville',
    '(+08:00) Asia/Manila',
    '(+05:00) Asia/Karachi',
    '(+01:00) Europe/Warsaw',
    '(-03:00) America/Miquelon',
    '(-08:00) Pacific/Pitcairn',
    '(-04:00) America/Puerto_Rico',
    '(+02:00) Asia/Gaza',
    '(+02:00) Asia/Hebron',
    '(+00:00) Europe/Lisbon',
    '(+00:00) Atlantic/Madeira',
    '(-01:00) Atlantic/Azores',
    '(+09:00) Pacific/Palau',
    '(-03:00) America/Asuncion',
    '(+03:00) Asia/Qatar',
    '(+04:00) Indian/Reunion',
    '(+02:00) Europe/Bucharest',
    '(+01:00) Europe/Belgrade',
    '(+02:00) Europe/Kaliningrad',
    '(+03:00) Europe/Moscow',
    '(+03:00) Europe/Simferopol',
    '(+03:00) Europe/Volgograd',
    '(+04:00) Europe/Samara',
    '(+05:00) Asia/Yekaterinburg',
    '(+06:00) Asia/Omsk',
    '(+06:00) Asia/Novosibirsk',
    '(+07:00) Asia/Novokuznetsk',
    '(+07:00) Asia/Krasnoyarsk',
    '(+08:00) Asia/Irkutsk',
    '(+08:00) Asia/Chita',
    '(+09:00) Asia/Yakutsk',
    '(+09:00) Asia/Khandyga',
    '(+10:00) Asia/Vladivostok',
    '(+10:00) Asia/Sakhalin',
    '(+10:00) Asia/Ust-Nera',
    '(+10:00) Asia/Magadan',
    '(+11:00) Asia/Srednekolymsk',
    '(+12:00) Asia/Kamchatka',
    '(+12:00) Asia/Anadyr',
    '(+03:00) Asia/Riyadh',
    '(+11:00) Pacific/Guadalcanal',
    '(+04:00) Indian/Mahe',
    '(+03:00) Africa/Khartoum',
    '(+01:00) Europe/Stockholm',
    '(+08:00) Asia/Singapore',
    '(-03:00) America/Paramaribo',
    '(-06:00) America/El_Salvador',
    '(+02:00) Asia/Damascus',
    '(-04:00) America/Grand_Turk',
    '(+01:00) Africa/Ndjamena',
    '(+05:00) Indian/Kerguelen',
    '(+07:00) Asia/Bangkok',
    '(+05:00) Asia/Dushanbe',
    '(+13:00) Pacific/Fakaofo',
    '(+09:00) Asia/Dili',
    '(+05:00) Asia/Ashgabat',
    '(+01:00) Africa/Tunis',
    '(+13:00) Pacific/Tongatapu',
    '(+02:00) Europe/Istanbul',
    '(-04:00) America/Port_of_Spain',
    '(+12:00) Pacific/Funafuti',
    '(+08:00) Asia/Taipei',
    '(+02:00) Europe/Kiev',
    '(+02:00) Europe/Uzhgorod',
    '(+02:00) Europe/Zaporozhye',
    '(+12:00) Pacific/Wake',
    '(-05:00) America/New_York',
    '(-05:00) America/Detroit',
    '(-05:00) America/Kentucky/Louisville',
    '(-05:00) America/Kentucky/Monticello',
    '(-05:00) America/Indiana/Indianapolis',
    '(-05:00) America/Indiana/Vincennes',
    '(-05:00) America/Indiana/Winamac',
    '(-05:00) America/Indiana/Marengo',
    '(-05:00) America/Indiana/Petersburg',
    '(-05:00) America/Indiana/Vevay',
    '(-06:00) America/Chicago',
    '(-06:00) America/Indiana/Tell_City',
    '(-06:00) America/Indiana/Knox',
    '(-06:00) America/Menominee',
    '(-06:00) America/North_Dakota/Center',
    '(-06:00) America/North_Dakota/New_Salem',
    '(-06:00) America/North_Dakota/Beulah',
    '(-07:00) America/Denver',
    '(-07:00) America/Boise',
    '(-07:00) America/Phoenix',
    '(-08:00) America/Los_Angeles',
    '(-08:00) America/Metlakatla',
    '(-09:00) America/Anchorage',
    '(-09:00) America/Juneau',
    '(-09:00) America/Sitka',
    '(-09:00) America/Yakutat',
    '(-09:00) America/Nome',
    '(-10:00) America/Adak',
    '(-10:00) Pacific/Honolulu',
    '(-03:00) America/Montevideo',
    '(+05:00) Asia/Samarkand',
    '(+05:00) Asia/Tashkent',
    '(-04:30) America/Caracas',
    '(+07:00) Asia/Ho_Chi_Minh',
    '(+11:00) Pacific/Efate',
    '(+12:00) Pacific/Wallis',
    '(+14:00) Pacific/Apia',
    '(+02:00) Africa/Johannesburg'
  ];

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void populateExistingEvent(eventData) {
    add(PopulateExistingEvent(eventData: eventData));
  }

  void selectedTabChange(index) {
    add(SelectedTabChange(index: index));
  }

  void eventNameInput(eventName) {
    add(EventNameInput(eventName: eventName));
  }

  void eventTypeInput(eventType) {
    add(EventTypeInput(eventType: eventType));
  }

  void eventTimeZoneInput(eventTimeZone) {
    add(EventTimeZoneInput(eventTimeZone: eventTimeZone));
  }

  void eventTagsInput(eventTag) {
    add(EventTagsInput(eventTag: eventTag));
  }

  void eventRemoveTag(eventTag) {
    add(EventRemoveTag(eventTag: eventTag));
  }

  void eventStartDateInput(eventStartDate) {
    add(EventStartDateInput(eventStartDate: eventStartDate));
  }

  void eventStartTimeInput(eventStartTime) {
    add(EventStartTimeInput(eventStartTime: eventStartTime));
  }

  void eventEndDateInput(eventEndDate) {
    add(EventEndDateInput(eventEndDate: eventEndDate));
  }

  void eventEndTimeInput(eventEndTime) {
    add(EventEndTimeInput(eventEndTime: eventEndTime));
  }

  void eventWeekdayInput(eventWeekday) {
    add(EventWeekdayInput(eventWeekday: eventWeekday));
  }

  void eventAddCustomDate() {
    add(EventAddCustomDate());
  }

  void eventRemoveCustomDate(eventCustomDate) {
    add(EventRemoveCustomDate(eventCustomDate: eventCustomDate));
  }

  void eventLocationInput(eventLocation) {
    add(EventLocationInput(eventLocation: eventLocation));
  }

  void eventStateInput(eventState) {
    add(EventStateInput(eventState: eventState));
  }

  void eventCityInput(eventCity) {
    add(EventCityInput(eventCity: eventCity));
  }

  void eventPostalCodeInput(eventPostalCode) {
    add(EventPostalCodeInput(eventPostalCode: eventPostalCode));
  }

  void eventDescriptionInput(eventDescription) {
    add(EventDescriptionInput(eventDescription: eventDescription));
  }

  void basic(callback) {
    add(Basic(callback: callback));
  }

  void selectEventFrequency(eventFreq) {
    add(SelectEventFrequency(eventFreq: eventFreq));
  }

  void selectPostType(postType) {
    add(SelectEventPrivacy(eventPrivacy: postType));
  }

  void carnival() {
    add(Carnival());
  }

  @override
  BasicState get initialState => BasicState.initial();

  @override
  Stream<BasicState> mapEventToState(BasicEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }
    if (event is PopulateExistingEvent) {
      final existingData = event.eventData;

      final String eventFrequency = state.eventFreqList
          .firstWhere(
              (frequency) => frequency.value == existingData.eventFrequency,
          orElse: () => state.eventFreqList[0])
          .name;
      String eventPrivacy = state.eventPrivacyList
          .firstWhere((privacy) => privacy.value == state.eventPrivacy,
          orElse: () => state.eventPrivacyList[0])
          .name;

      final String eventName = existingData.title;
      final String eventType = existingData.type;
      final String eventTimeZone = existingData.timeZone;
      final List<String> eventTags = existingData.tags;

      DateTime eventStartDate;
      TimeOfDay eventStartTime;
      if (isValid(existingData.startDateTime)) {
        final startDateTime = DateTime.parse(existingData.startDateTime);
        eventStartDate = DateTime(
            startDateTime.year, startDateTime.month, startDateTime.day);
        eventStartTime =
            TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute);
      }

      DateTime eventEndDate;
      TimeOfDay eventEndTime;
      if (isValid(existingData.endDateTime)) {
        final endDateTime = DateTime.parse(existingData.endDateTime);
        eventEndDate =
            DateTime(endDateTime.year, endDateTime.month, endDateTime.day);
        eventEndTime =
            TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute);
      }

      final String eventWeekday = existingData.weekly?.day;
      final String eventLocation = existingData.place?.address;
      final String eventState = existingData.place?.state;
      final String eventCity = existingData.place?.city;
      final String eventPostalCode = existingData.place?.pincode;
      final String eventDescription = existingData.description;

      List<EventCustomDate> eventCustomDateTimeList;
      if (existingData.custom?.selectedDays != null &&
          (existingData.custom?.selectedDays?.length ?? 0) > 0) {
        eventCustomDateTimeList
            .addAll(existingData.custom.selectedDays.map((eventCustomDateTime) {
          return EventCustomDate(
            eventStartDateTime: isValid(eventCustomDateTime.startDateTime)
                ? DateTime.parse(eventCustomDateTime.startDateTime)
                : null,
            eventEndDateTime: isValid(eventCustomDateTime.endDateTime)
                ? DateTime.parse(eventCustomDateTime.endDateTime)
                : null,
          );
        }).toList());
      }

      yield state.copyWith(
        eventFrequency: eventFrequency,
        eventPrivacy: eventPrivacy,
        eventName: eventName,
        eventType: eventType,
        eventTimeZone: eventTimeZone,
        eventTags: eventTags,
        eventStartDate: eventStartDate,
        eventStartTime: eventStartTime,
        eventEndDate: eventEndDate,
        eventEndTime: eventEndTime,
        eventWeekday: eventWeekday,
        eventLocation: eventLocation,
        eventState: eventState,
        eventCity: eventCity,
        eventPostalCode: eventPostalCode,
        eventDescription: eventDescription,
        eventCustomDateTimeList: eventCustomDateTimeList,
        fullRefresh: true,
      );
    }
    if (event is SelectedTabChange) {
      yield state.copyWith(selectedTab: event.index);
    }
    if (event is EventNameInput) {
      yield state.copyWith(
        eventName: event.eventName,
        uploadRequired: true,
      );
    }
    if (event is EventTimeZoneInput) {
      yield state.copyWith(
        eventTimeZone: event.eventTimeZone,
        uploadRequired: true,
      );
    }
    if (event is EventTypeInput) {
      yield state.copyWith(
        eventType: event.eventType,
        uploadRequired: true,
      );
    }
    if (event is EventTagsInput) {
      if (!state.eventTags.contains(event.eventTag)) {
        state.eventTags.add(event.eventTag);
        final List<String> eventTagList = [];
        eventTagList.addAll(state.eventTags);
        yield state.copyWith(
          eventTags: eventTagList,
          uploadRequired: true,
        );
      } else {
        yield state.copyWith(uiMsg: ERR_DUPLICATE_TAG);
      }
    }
    if (event is EventRemoveTag) {
      state.eventTags.remove(event.eventTag);
      final List<String> eventTagList = [];
      eventTagList.addAll(state.eventTags);
      yield state.copyWith(
        eventTags: eventTagList,
        uploadRequired: true,
      );
    }
    if (event is EventStartDateInput) {
      yield state.copyWith(
        eventStartDate: event.eventStartDate,
        uploadRequired: true,
      );
    }
    if (event is EventStartTimeInput) {
      yield state.copyWith(
        eventStartTime: event.eventStartTime,
        uploadRequired: true,
      );
    }
    if (event is EventEndDateInput) {
      yield state.copyWith(
        eventEndDate: event.eventEndDate,
        uploadRequired: true,
      );
      print('${event.eventEndDate}');
    }
    if (event is EventEndTimeInput) {
      yield state.copyWith(
        eventEndTime: event.eventEndTime,
        uploadRequired: true,
      );
      print('${event.eventEndTime}');
    }
    if (event is EventWeekdayInput) {
      yield state.copyWith(
        eventWeekday: event.eventWeekday,
        uploadRequired: true,
      );
    }
    if (event is EventAddCustomDate) {
      if (state.eventStartDate == null) {
        yield state.copyWith(uiMsg: ERR_START_DATE);
        return;
      }

      if (state.eventStartTime == null) {
        yield state.copyWith(uiMsg: ERR_START_TIME);
        return;
      }

      if (state.eventEndDate == null) {
        yield state.copyWith(uiMsg: ERR_END_DATE);
        return;
      }

      if (state.eventEndTime == null) {
        yield state.copyWith(uiMsg: ERR_END_TIME);
        return;
      }

      if (startDateTime.isAfter(endDateTime)) {
        yield state.copyWith(uiMsg: ERR_END_TIME_LESS);
        return;
      }

      List<EventCustomDate> eventCustomDateTimeList = [];
      eventCustomDateTimeList.addAll(state.eventCustomDateTimeList);
      eventCustomDateTimeList.add(EventCustomDate(
        eventStartDateTime: startDateTime,
        eventEndDateTime: endDateTime,
      ));

      yield state.copyWith(
        eventCustomDateTimeList: eventCustomDateTimeList,
        uploadRequired: true,
      );
    }
    if (event is EventRemoveCustomDate) {
      state.eventCustomDateTimeList.remove(event.eventCustomDate);

      final List<EventCustomDate> eventCustomDateTimeList = [];
      eventCustomDateTimeList.addAll(state.eventCustomDateTimeList);

      yield state.copyWith(
        eventCustomDateTimeList: eventCustomDateTimeList,
        uploadRequired: true,
      );
    }
    if (event is EventLocationInput) {
      yield state.copyWith(
        eventLocation: event.eventLocation,
        uploadRequired: true,
      );
    }
    if (event is EventStateInput) {
      yield state.copyWith(
        eventState: event.eventState,
        uploadRequired: true,
      );
    }
    if (event is EventCityInput) {
      yield state.copyWith(
        eventCity: event.eventCity,
        uploadRequired: true,
      );
    }
    if (event is EventPostalCodeInput) {
      yield state.copyWith(
        eventPostalCode: event.eventPostalCode,
        uploadRequired: true,
      );
    }
    if (event is EventDescriptionInput) {
      yield state.copyWith(
        eventDescription: event.eventDescription,
        uploadRequired: true,
      );
    }
    if (event is Carnival) {
      yield state.copyWith(loading: true);
      fetchEventTypes();
    }

    if (event is EventTypeAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        eventTypeList: event.success ? event.carnivalList : null,
      );
    }

    if (event is Basic) {
      yield* uploadEventBasicInfo(event);
    }

    if (event is EventBasicInfoUploadResult) {
      yield state.copyWith(
        loading: false,
        uiMsg: event.uiMsg,
      );
    }

    if (event is SelectEventPrivacy) {
      yield state.copyWith(eventPrivacy: event.eventPrivacy);

      int id = state.eventPrivacyList
          .indexWhere((item) => item.name == state.eventPrivacy);

      state.eventPrivacyList.forEach((element) => element.isSelected = false);
      state.eventPrivacyList[id].isSelected = true;

      yield state.copyWith(postTypeList: state.eventPrivacyList);
    }

    if (event is SelectEventFrequency) {
      yield state.copyWith(eventFrequency: event.eventFreq);

      int id = state.eventFreqList
          .indexWhere((item) => item.name == state.eventFreqName);

      state.eventFreqList.forEach((element) => element.isSelected = false);
      state.eventFreqList[id].isSelected = true;

      yield state.copyWith(eventFreqList: state.eventFreqList);
    }
  }

  void fetchEventTypes() {
    apiProvider.getEventTypes().then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var carnivalResponse =
        networkServiceResponse.response as CarnivalResonse;
        if (carnivalResponse.code == apiCodeSuccess)
          add(EventTypeAvailable(true,
              carnivalList: carnivalResponse.carnivalList));
        else
          add(EventTypeAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      } else {
        add(EventTypeAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
    }).catchError((error) {
      print('Error in fetchEventTypes--->$error');
      add(EventTypeAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
    });
  }

  Stream<BasicState> uploadEventBasicInfo(Basic event) async* {
    int errorCode = validateBasicInfo();

    if (errorCode > 0) {
      yield state.copyWith(uiMsg: errorCode);
      event.callback(null);
      return;
    }

    apiProvider
        .getBasic(state.authToken, eventDataToUpload, eventDataId: eventDataId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var basicResponse = networkServiceResponse.response as BasicResponse;
        if (basicResponse.code == apiCodeSuccess) {
          state.uploadRequired = false;
          if (basicResponse.id != null) eventDataId = basicResponse.id;

          add(EventBasicInfoUploadResult(true, uiMsg: basicResponse.message));
          event.callback(basicResponse);
        } else {
          add(EventBasicInfoUploadResult(false,
              uiMsg: basicResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(basicResponse.message);
        }
      } else {
        add(EventBasicInfoUploadResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in uploadEventBasicInfo--->$error');
      add(EventBasicInfoUploadResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(error);
    });
  }

  int validateBasicInfo() {
    if (!isValid(state.eventName)) return ERR_EVENT_NAME;
    if (!isValid(state.eventType)) return ERR_EVENT_TYPE;
    if (!isValid(state.eventTimeZone)) return ERR_EVENT_TIMEZONE;

    final menuList = state.eventFreqList;
    if (state.eventFreqName == menuList[0].name) {
      if (state.eventStartDate == null) return ERR_START_DATE;
      if (state.eventStartTime == null) return ERR_START_TIME;
      if (state.eventEndDate == null) return ERR_END_DATE;
      if (state.eventEndTime == null) return ERR_END_TIME;

      if (startDateTime.isAfter(endDateTime)) return ERR_END_TIME_LESS;
    } else if (state.eventFreqName == menuList[1].name) {
      if (state.eventStartDate == null) return ERR_START_DATE;
      if (state.eventStartTime == null) return ERR_START_TIME;
      if (state.eventEndDate == null) return ERR_END_DATE;
      if (state.eventEndTime == null) return ERR_END_TIME;

      if (startDateTime.isAfter(endDateTime)) return ERR_END_TIME_LESS;
    } else if (state.eventFreqName == menuList[2].name) {
      if (state.eventStartDate == null) return ERR_START_DATE;
      if (state.eventStartTime == null) return ERR_START_TIME;
      if (state.eventEndDate == null) return ERR_END_DATE;
      if (state.eventEndTime == null) return ERR_END_TIME;

      if (!isValid(state.eventWeekday))
        return ERR_WEEK_DAY;
      else {
        final startDateWeekday =
        DateFormat('EEEE').format(state.eventStartDate);

        if (startDateWeekday != state.eventWeekday)
          return ERR_START_DATE_WEEK_DAY;

        final endDateWeekday = DateFormat('EEEE').format(state.eventEndDate);
        if (endDateWeekday != state.eventWeekday) return ERR_END_DATE_WEEK_DAY;

        if (startDateTime.isAfter(endDateTime)) return ERR_END_TIME_LESS;
      }
    } else if (state.eventFreqName == menuList[3].name) {
      if (state.eventCustomDateTimeList.length < 2) return ERR_TWO_DATES_REQ;
    }

    if (!isValid(state.eventLocation)) return ERR_EVENT_ADDRESS;
    if (!isValid(state.eventState)) return ERR_EVENT_STATE;
    if (!isValid(state.eventCity)) return ERR_EVENT_CITY;
    if (!isValid(state.eventPostalCode)) return ERR_EVENT_POSTAL;

    if (!isValid(state.eventDescription))
      return ERR_EVENT_DESC;
    else
      return 0;
  }

  DateTime get startDateTime {
    if (state.eventStartDate == null && state.eventStartTime == null)
      return DateTime.now();
    else {
      final currentTime = DateTime.now();
      return DateTime(
        state.eventStartDate?.year ?? currentTime.year,
        state.eventStartDate?.month ?? currentTime.month,
        state.eventStartDate?.day ?? currentTime.day,
        state.eventStartTime?.hour ?? 0,
        state.eventStartTime?.minute ?? 0,
      );
    }
  }

  DateTime get endDateTime {
    if (state.eventEndDate == null && state.eventEndTime == null)
      return DateTime.now();
    else {
      final currentTime = DateTime.now();
      return DateTime(
        state.eventEndDate?.year ?? currentTime.year,
        state.eventEndDate?.month ?? currentTime.month,
        state.eventEndDate?.day ?? currentTime.day,
        state.eventEndTime?.hour ?? 0,
        state.eventEndTime?.minute ?? 0,
      );
    }
  }

  List<CustomDateTime> get customSelectedDates {
    List<CustomDateTime> customSelectedDateTime = [];
    customSelectedDateTime
        .addAll(state.eventCustomDateTimeList.map((eventCustomDateTime) {
      return CustomDateTime(
        startDateTime: eventCustomDateTime.eventStartDateTime.toIso8601String(),
        endDateTime: eventCustomDateTime.eventEndDateTime.toIso8601String(),
      );
    }));
    return customSelectedDateTime;
  }

  EventData get eventDataToUpload {
    return EventData(
        title: state.eventName,
        type: state.eventType,
        timeZone: state.eventTimeZone,
        tags: state.eventTags,
        eventFrequency: state.eventFreqList
            .firstWhere((frequency) => frequency.name == state.eventFreqName,
            orElse: () => state.eventFreqList[0])
            .value,
        eventPrivacy: state.eventPrivacyList
            .firstWhere((privacy) => privacy.name == state.eventPrivacy,
            orElse: () => state.eventPrivacyList[0])
            .value,
        startDateTime: startDateTime.toIso8601String(),
        endDateTime: endDateTime.toIso8601String(),
        description: state.eventDescription,
        status: mainEventData?.status ?? 'DRAFT',
        place: Place(
          name: '',
          address: state.eventLocation,
          state: state.eventState,
          city: state.eventCity,
          pincode: state.eventPostalCode,
        ),
        daily: Daily(
          endDate: '',
          endTime: '',
          startDate: '',
          startTime: '',
        ),
        weekly: Weekly(
          startTime: '',
          startDate: '',
          endTime: '',
          endDate: '',
          day: state.eventWeekday,
        ),
        custom: Custom(
          endTime: '',
          startTime: '',
          selectedDays: customSelectedDates,
        ));
  }
}
