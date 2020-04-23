import 'package:eventmanagement/model/event/basic/basic_json.dart';
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

  getLoginDetail(String authToken) async{
    NetworkServiceResponse result = await apiService.loginDetail(authToken);
    this.apiResult = result;
  }

  getSignUp(Map<String, dynamic> param) async {
    NetworkServiceResponse result = await apiService.signUp(param);
    this.apiResult = result;
  }

  getForgotPassword(Map<String, dynamic> param) async{
    NetworkServiceResponse result = await apiService.forgotPassword(param);
    this.apiResult = result;
  }

  getTickets(String authToken) async{
    NetworkServiceResponse result = await apiService.tickets(authToken);
    this.apiResult = result;
  }

  getCreateTickets(String authToken, Map<String, dynamic> param) async{
    NetworkServiceResponse result = await apiService.createTicket(authToken, param);
    this.apiResult = result;
  }

  getBasic(String authToken, BasicJson basicJson) async{
    NetworkServiceResponse result = await apiService.basic(authToken, basicJson);
    this.apiResult = result;
  }
  getCarnival() async{
    NetworkServiceResponse result = await apiService.carnivals();
    this.apiResult = result;
  }

}
