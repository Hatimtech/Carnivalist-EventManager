import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';

class MockService implements APIService {
  @override
  login(Map<String, dynamic> param, bool staffLogin) {
    return null;
  }

  @override
  loginDetail(String authToken) {
    return null;
  }

  @override
  signUp(Map<String, dynamic> param) {
    return null;
  }

  @override
  forgotPassword(Map<String, dynamic> param) {
    return null;
  }

  @override
  tickets(String authToken) {
    return null;
  }

  @override
  createTicket(String authToken, Map<String, dynamic> param,
      {String ticketId}) {
    return null;
  }

  @override
  basic(String authToken, EventData basicJson, {String eventDataId}) {
    return null;
  }

  @override
  carnivals() {
    return null;
  }

  @override
  activeInactiveTicket(String authToken, bool isActive, String ticketId) {
    return null;
  }

  @override
  deleteTicket(String authToken, String ticketId) {
    return null;
  }

  @override
  createNewFormField(String authToken, EventData basicJson,
      {String eventDataId}) {
    return null;
  }

  @override
  createGalleryData(String authToken, EventData eventData,
      {String eventDataId}) {
    return null;
  }

  @override
  uploadGalleryMedia(String authToken, String mediaPath) {
    return null;
  }

  @override
  uploadSetting(String authToken, SettingData settingData,
      {String eventDataId}) {
    return null;
  }

  @override
  getAllEvents(String authToken) {
    return null;
  }

  @override
  getAllEventsForStaff(String authToken) {
    return null;
  }

  @override
  activeInactiveEvent(String authToken, Map<String, dynamic> param,
      String eventId) {
    return null;
  }

  @override
  deleteEvent(String authToken, String eventId) {
    return null;
  }

  @override
  getAllAddons(String authToken, bool assigning) {
    return null;
  }

  @override
  uploadAddon(String authToken, Addon addon) {
    return null;
  }

  @override
  assignAddon(String authToken, Ticket ticket, {String ticketId}) {
    return null;
  }

  @override
  getAllCoupons(String authToken) {
    return null;
  }

  @override
  activeInactiveCoupons(String authToken, String couponId) {
    return null;
  }

  @override
  uploadCoupon(String authToken, Coupon coupon) {
    return null;
  }

  @override
  getEventDetail(String authToken, String eventId) {
    return null;
  }

  @override
  attendeesResendTicket(String authToken, Map<String, dynamic> param) {
    return null;
  }

  @override
  attendeesSendMail(String authToken, Map<String, dynamic> param) {
    return null;
  }

  @override
  uploadProfilePic(String authToken, String mediaPath) {
    return null;
  }

  @override
  updateUserDetails(String authToken, Map<String, dynamic> param) {
    return null;
  }

  @override
  uploadTagScanned(String authToken, Map<String, dynamic> param, bool isNFC) {
    throw null;
  }
}
