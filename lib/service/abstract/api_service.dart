import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';

abstract class APIService {
  login(Map<String, dynamic> param);

  loginDetail(String authToken);

  signUp(Map<String, dynamic> param);

  forgotPassword(Map<String, dynamic> param);

  basic(String authToken, EventData basicJson, {String eventDataId});

  carnivals();

  tickets(String authToken);

  createTicket(String authToken, Map<String, dynamic> param, {String ticketId});

  activeInactiveTicket(String authToken, bool active, String ticketId);

  deleteTicket(String authToken, String ticketId);

  createNewFormField(String authToken, EventData eventData,
      {String eventDataId});

  uploadGalleryMedia(String authToken, String mediaPath);

  createGalleryData(String authToken, EventData eventData,
      {String eventDataId});

  uploadSetting(String authToken, SettingData settingData,
      {String eventDataId});

  getAllEvents(String authToken);

  deleteEvent(String authToken, String eventId);

  activeInactiveEvent(String authToken, Map<String, dynamic> param,
      String eventId);
}
