import 'package:eventmanagement/model/event/basic/basic_json.dart';

abstract class APIService {
  login(Map<String, dynamic> param);
  loginDetail(String authToken);
  signUp(Map<String, dynamic> param);
  forgotPassword(Map<String, dynamic> param);
  tickets(String authToken);
  createTicket(String authToken, Map<String, dynamic> param);
  basic(String authToken, BasicJson basicJson);
  carnivals();

}
