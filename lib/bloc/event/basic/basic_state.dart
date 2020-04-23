import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/model/menu_custom.dart';

class BasicState {
  String authToken;
  String eventMenuName, postType;
  List<MenuCustom> eventMenuList;
  List<MenuCustom> postTypeList;
  final String eventName;
  final String eventEndDate;
  final String eventEndTime;
  final String eventCarnival;
  final String eventTimeZone;
  final String eventTags;
  final String eventStartDate;
  final String eventStartTime;
  final String eventLocation;
  final String eventState;
  final String eventCity;
  final String eventPostalCode;
  final String eventDescription;
  final List<Carnivals> carnivalList;
  bool loading;

  BasicState(
      {this.authToken,
      this.eventMenuName,
      this.eventMenuList,
      this.postType,
      this.postTypeList,
      this.eventName,
      this.eventEndDate,
      this.eventEndTime,
        this.eventCarnival,
      this.eventTimeZone,
      this.eventTags,
      this.eventStartDate,
      this.eventStartTime,
      this.eventLocation,
      this.eventState,
      this.eventCity,
      this.eventPostalCode,
      this.eventDescription,
      this.carnivalList,
      this.loading});

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
        eventEndDate: '',
        eventEndTime: '',
        eventCarnival:'',
        eventTimeZone: '',
        eventTags: '',
        eventStartDate: '',
        eventStartTime: '',
        eventLocation: '',
        eventState: '',
        eventCity: '',
        eventPostalCode: '',
        eventDescription: '',
        carnivalList: List(),
        loading: false);
  }

  BasicState copyWith(
      {String authToken,
      String eventMenuName,
      List<MenuCustom> eventMenuList,
      String postType,
      List<MenuCustom> postTypeList,
      String eventName,
      String eventEndDate,
      String eventEndTime,
        String eventCarnival,
      String eventTimeZone,
      String eventTags,
      String eventStartDate,
      String eventStartTime,
      String eventLocation,
      String eventState,
      String eventCity,
      String eventPostalCode,
      String eventDescription,
      List<Carnivals> carnivalList,
      bool loading}) {
    return BasicState(
      authToken: authToken ?? this.authToken,
      eventMenuName: eventMenuName ?? this.eventMenuName,
      eventMenuList: eventMenuList ?? this.eventMenuList,
      postType: postType ?? this.postType,
      postTypeList: postTypeList ?? this.postTypeList,
      eventName: eventName ?? this.eventName,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      eventEndTime: eventEndTime ?? this.eventEndTime,
      eventCarnival: eventCarnival ?? this.eventCarnival,
      eventTimeZone: eventTimeZone ?? this.eventTimeZone,
      eventTags: eventTags ?? this.eventTags,
      eventStartDate: eventStartDate ?? this.eventStartDate,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventLocation: eventLocation ?? this.eventLocation,
      eventState: eventState ?? this.eventState,
      eventCity: eventCity ?? this.eventCity,
      eventPostalCode: eventPostalCode ?? this.eventPostalCode,
      eventDescription: eventDescription ?? this.eventDescription,
      carnivalList: carnivalList ?? this.carnivalList,
      loading: loading ?? this.loading,
    );
  }
}
