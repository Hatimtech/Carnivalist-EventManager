import 'package:eventmanagement/model/event/event_data.dart';

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

  createNewFormField(String authToken, EventData basicJson,
      {String eventDataId});
}
