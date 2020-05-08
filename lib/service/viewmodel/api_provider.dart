import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';
import 'package:eventmanagement/service/di/dependency_injection.dart';

import '../network_service_response.dart';

class ApiProvider {
  NetworkServiceResponse apiResult;
  APIService apiService = new Injector().flavor;

  getLogin(Map<String, dynamic> param) async {
    NetworkServiceResponse result = await apiService.login(param);
    this.apiResult = result;
  }

  getLoginDetail(String authToken) async {
    NetworkServiceResponse result = await apiService.loginDetail(authToken);
    this.apiResult = result;
  }

  getSignUp(Map<String, dynamic> param) async {
    NetworkServiceResponse result = await apiService.signUp(param);
    this.apiResult = result;
  }

  getForgotPassword(Map<String, dynamic> param) async {
    NetworkServiceResponse result = await apiService.forgotPassword(param);
    this.apiResult = result;
  }

  Future<NetworkServiceResponse> getBasic(String authToken, EventData basicJson,
      {String eventDataId}) async {
    return await apiService.basic(
        authToken, basicJson, eventDataId: eventDataId);
  }

  Future<NetworkServiceResponse> getEventTypes() async {
    NetworkServiceResponse result = await apiService.carnivals();
    return result;
  }

  getTickets(String authToken) async {
    NetworkServiceResponse result = await apiService.tickets(authToken);
    this.apiResult = result;
  }

  getCreateTickets(String authToken, Map<String, dynamic> param,
      {String ticketId}) async {
    NetworkServiceResponse result =
    await apiService.createTicket(authToken, param, ticketId: ticketId);
    this.apiResult = result;
  }

  Future<NetworkServiceResponse> activeInactiveTickets(String authToken,
      bool active, String ticketId) async {
    return await apiService.activeInactiveTicket(authToken, active, ticketId);
  }

  Future<NetworkServiceResponse> deleteTicket(String authToken,
      String ticketId) async {
    return await apiService.deleteTicket(authToken, ticketId);
  }

  createNewFormFields(String authToken, EventData eventData,
      {String eventDataId}) async {
    NetworkServiceResponse result = await apiService
        .createNewFormField(authToken, eventData, eventDataId: eventDataId);
    this.apiResult = result;
  }

  uploadMedia(String authToken, String mediaPath) async {
    NetworkServiceResponse result =
    await apiService.uploadGalleryMedia(authToken, mediaPath);
    this.apiResult = result;
  }

  createGalleryData(String authToken, EventData eventData,
      {String eventDataId}) async {
    NetworkServiceResponse result = await apiService
        .createGalleryData(authToken, eventData, eventDataId: eventDataId);
    this.apiResult = result;
  }

  uploadSettings(String authToken, SettingData settingData,
      {String eventDataId}) async {
    NetworkServiceResponse result =
    await apiService.uploadSetting(
        authToken, settingData, eventDataId: eventDataId);
    this.apiResult = result;
  }

  getAllEvents(String authToken) async {
    NetworkServiceResponse result = await apiService.getAllEvents(authToken);
    this.apiResult = result;
  }

  deleteEvent(String authToken, String eventId) async {
    NetworkServiceResponse result =
    await apiService.deleteEvent(authToken, eventId);
    this.apiResult = result;
  }

  activeInactiveEvent(String authToken, Map<String, dynamic> param,
      String eventId) async {
    NetworkServiceResponse result =
    await apiService.activeInactiveEvent(authToken, param, eventId);
    this.apiResult = result;
  }
}
