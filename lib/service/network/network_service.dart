import 'dart:convert';
import 'package:eventmanagement/model/event/basic/basic_json.dart';
import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/model/event/carnivals/carnival_resonse.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/model/event/tickets/tickets_response.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/model/logindetail/login_detail_response.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';
import '../network_service_response.dart';
import '../network_type.dart';
import '../restclient.dart';

class NetworkService extends NetworkType implements APIService {
  static final _baseUrl = 'https://backend.carnivalist.tk';
  static final _subUrl = '/api/';
  final _loginUrl = _baseUrl + _subUrl + 'user/login';
  final _loginDetailUrl = _baseUrl + _subUrl + 'user/get-user-details';
  final _signUpUrl = _baseUrl + _subUrl + 'user/register';
  final _forgotPasswordUrl = _baseUrl + _subUrl + 'user/forgot-password';

  //TODO EVENT
  final _ticketsListUrl = _baseUrl + _subUrl + 'tickets';
  final _createTicketsUrl = _baseUrl + _subUrl + 'tickets';
  final _basicUrl = _baseUrl + _subUrl + 'events';
  final _carnivalListUrl = _baseUrl + _subUrl + 'website-settings/show-categories';

  NetworkService(RestClient rest) : super(rest);

  @override
  Future login(Map<String, dynamic> param) async {
    var result = await rest.post<LoginResponse>(_loginUrl,
        body: param, encoding: Encoding.getByName("utf-8"));

    var res = LoginResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  loginDetail(String authToken) async {
    var headers = {
      'Authorization': authToken,
    };

    var result = await rest.get<LoginDetailResponse>(_loginDetailUrl, headers);
    var res = LoginDetailResponse.fromJson(json.decode(result.mappedResult));

    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  signUp(Map<String, dynamic> param) async {
    var result = await rest.post<LoginResponse>(_signUpUrl,
        body: param, encoding: Encoding.getByName("utf-8"));

    var res = LoginResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  forgotPassword(Map<String, dynamic> param) async {
    var result = await rest.post<LoginResponse>(_forgotPasswordUrl,
        body: json.encode(param));

    var res = LoginResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  tickets(String authToken) async {
    var headers = {
      'Authorization': authToken,
    };

    var result = await rest.get<TicketsResponse>(_ticketsListUrl, headers);
    var res = TicketsResponse.fromJson(json.decode(result.mappedResult));

    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  createTicket(String authToken, Map<String, dynamic> param) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CreateTicketResponse>(_createTicketsUrl,
        body: json.encode(param), encoding: Encoding.getByName("utf-8"), headers: headers);

    var res = CreateTicketResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  basic(String authToken, BasicJson basicJson) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<BasicResponse>(_basicUrl,
        body: json.encode(basicJson), encoding: Encoding.getByName("utf-8"), headers: headers);
    var res = BasicResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  carnivals() async {

    var result = await rest.getwithoutHeader<CarnivalResonse>(_carnivalListUrl);
    var res = CarnivalResonse.fromJson(json.decode(result.mappedResult));

    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

}
