import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';
import 'package:eventmanagement/service/di/dependency_injection.dart';

import '../network_service_response.dart';

class ApiProvider {
  APIService apiService = new Injector().flavor;

  Future<NetworkServiceResponse> getLogin(Map<String, dynamic> param,
      bool staffLogin) async {
    return await apiService.login(param, staffLogin);
  }

  Future<NetworkServiceResponse> getLoginDetail(String authToken) async {
    return await apiService.loginDetail(authToken);
  }

  Future<NetworkServiceResponse> getSignUp(Map<String, dynamic> param) async {
    return await apiService.signUp(param);
  }

  Future<NetworkServiceResponse> getForgotPassword(
      Map<String, dynamic> param) async {
    return await apiService.forgotPassword(param);
  }

  Future<NetworkServiceResponse> getBasic(String authToken, EventData basicJson,
      {String eventDataId}) async {
    return await apiService.basic(authToken, basicJson,
        eventDataId: eventDataId);
  }

  Future<NetworkServiceResponse> getEventTypes() async {
    NetworkServiceResponse result = await apiService.carnivals();
    return result;
  }

  Future<NetworkServiceResponse> getTickets(String authToken) async {
    return await apiService.tickets(authToken);
  }

  Future<NetworkServiceResponse> getCreateTickets(String authToken,
      Map<String, dynamic> param,
      {String ticketId}) async {
    return await apiService.createTicket(authToken, param, ticketId: ticketId);
  }

  Future<NetworkServiceResponse> activeInactiveTickets(String authToken,
      bool active, String ticketId) async {
    return await apiService.activeInactiveTicket(authToken, active, ticketId);
  }

  Future<NetworkServiceResponse> deleteTicket(String authToken,
      String ticketId) async {
    return await apiService.deleteTicket(authToken, ticketId);
  }

  Future<NetworkServiceResponse> createNewFormFields(String authToken,
      EventData eventData,
      {String eventDataId}) async {
    return await apiService.createNewFormField(authToken, eventData,
        eventDataId: eventDataId);
  }

  Future<NetworkServiceResponse> uploadMedia(String authToken,
      String mediaPath) async {
    return await apiService.uploadGalleryMedia(authToken, mediaPath);
  }

  Future<NetworkServiceResponse> createGalleryData(String authToken,
      EventData eventData,
      {String eventDataId}) async {
    return await apiService.createGalleryData(authToken, eventData,
        eventDataId: eventDataId);
  }

  Future<NetworkServiceResponse> uploadSettings(String authToken,
      SettingData settingData,
      {String eventDataId}) async {
    return await apiService.uploadSetting(authToken, settingData,
        eventDataId: eventDataId);
  }

  Future<NetworkServiceResponse> getAllEvents(String authToken) async {
    return await apiService.getAllEvents(authToken);
  }

  Future<NetworkServiceResponse> getAllEventsForStaff(String authToken) async {
    return await apiService.getAllEventsForStaff(authToken);
  }

  Future<NetworkServiceResponse> deleteEvent(String authToken,
      String eventId) async {
    return await apiService.deleteEvent(authToken, eventId);
  }

  Future<NetworkServiceResponse> activeInactiveEvent(String authToken,
      Map<String, dynamic> param, String eventId) async {
    return await apiService.activeInactiveEvent(authToken, param, eventId);
  }

  Future<NetworkServiceResponse> getAllAddons(String authToken,
      bool assigning) async {
    return await apiService.getAllAddons(authToken, assigning);
  }

  Future<NetworkServiceResponse> uploadAddon(String authToken,
      Addon addon) async {
    return await apiService.uploadAddon(authToken, addon);
  }

  Future<NetworkServiceResponse> assignAddon(String authToken, Ticket ticket,
      {String ticketId}) async {
    return await apiService.assignAddon(authToken, ticket, ticketId: ticketId);
  }

  Future<NetworkServiceResponse> getAllCoupons(String authToken) async {
    return await apiService.getAllCoupons(authToken);
  }

  Future<NetworkServiceResponse> activeInactiveCoupons(String authToken,
      String couponId) async {
    return await apiService.activeInactiveCoupons(authToken, couponId);
  }

  Future<NetworkServiceResponse> uploadCoupon(String authToken,
      Coupon coupon) async {
    return await apiService.uploadCoupon(authToken, coupon);
  }

  Future<NetworkServiceResponse> getEventDetail(String authToken,
      String eventId) async {
    return await apiService.getEventDetail(authToken, eventId);
  }

  Future<NetworkServiceResponse> attendeesResendTicket(String authToken,
      Map<String, dynamic> param) async {
    return await apiService.attendeesResendTicket(authToken, param);
  }

  Future<NetworkServiceResponse> attendeesSendMail(String authToken,
      Map<String, dynamic> param) async {
    return await apiService.attendeesSendMail(authToken, param);
  }

  Future<NetworkServiceResponse> uploadProfilePic(String authToken,
      String mediaPath) async {
    return await apiService.uploadProfilePic(authToken, mediaPath);
  }

  Future<NetworkServiceResponse> updateUserDetails(String authToken,
      Map<String, dynamic> param) async {
    return await apiService.updateUserDetails(authToken, param);
  }

  Future<NetworkServiceResponse> uploadTagScanned(String authToken,
      Map<String, dynamic> param, bool isNFC) async {
    return await apiService.uploadTagScanned(authToken, param, isNFC);
  }

  Future<NetworkServiceResponse> getAllStaffs(String authToken) async {
    return await apiService.getAllStaffs(authToken);
  }

  Future<NetworkServiceResponse> activeInactiveStaff(String authToken,
      String staffId, bool enable) async {
    return await apiService.activeInactiveStaff(authToken, staffId, enable);
  }

  Future<NetworkServiceResponse> createUpdateStaff(String authToken,
      Map<String, dynamic> staff, {String staffId}) async {
    return await apiService.createStaff(authToken, staff, staffId: staffId);
  }
}
