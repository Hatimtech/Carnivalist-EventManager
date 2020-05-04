import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';

class MockService implements APIService {
  @override
  login(Map<String, dynamic> param) {
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

}
