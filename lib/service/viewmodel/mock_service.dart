import 'package:eventmanagement/model/event/basic/basic_json.dart';
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
  createTicket(String authToken, Map<String, dynamic> param) {
    return null;
  }

  @override
  basic(String authToken, BasicJson basicJson) {
    return null;
  }

  @override
  carnivals() {
    // TODO: implement carnivals
    return null;
  }

}
