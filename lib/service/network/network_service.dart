import 'dart:convert';

import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/model/event/carnivals/carnival_resonse.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/form/form_action_response.dart';
import 'package:eventmanagement/model/event/gallery/gallery_response.dart';
import 'package:eventmanagement/model/event/gallery/media_upload_response.dart';
import 'package:eventmanagement/model/event/tickets/ticket_action_response.dart';
import 'package:eventmanagement/model/event/tickets/tickets_response.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/model/logindetail/login_detail_response.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';

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
  final _updateTicketsUrl = _baseUrl + _subUrl + 'ticket';
  final _basicUrl = _baseUrl + _subUrl + 'events';
  final _carnivalListUrl =
      _baseUrl + _subUrl + 'website-settings/show-categories';

  final _activeInactiveTicketUrl =
      _baseUrl + _subUrl + 'toggle-active-tickets/';

  final _deleteTicketUrl = _baseUrl + _subUrl + 'tickets/delete-tickets/';

  final _uploadMediaUrl = _baseUrl + _subUrl + 'upload-media';

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
  basic(String authToken, EventData basicJson, {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<BasicResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(basicJson),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = BasicResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  carnivals() async {
    var result = await rest.getwithoutHeader<CarnivalResonse>(_carnivalListUrl);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CarnivalResonse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
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
  createTicket(String authToken, Map<String, dynamic> param,
      {String ticketId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CreateTicketResponse>(
        '${ticketId != null
            ? _updateTicketsUrl
            : _createTicketsUrl}${ticketId != null ? '/$ticketId' : ''}',
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    var res = CreateTicketResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  activeInactiveTicket(String authToken, bool isActive, String ticketId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<TicketActionResponse>(
        '$_activeInactiveTicketUrl$ticketId/$isActive', headers);

    var res = TicketActionResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  deleteTicket(String authToken, String ticketId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<TicketActionResponse>(
        '$_deleteTicketUrl$ticketId', headers);

    var res = TicketActionResponse.fromJson(json.decode(result.mappedResult));
    return new NetworkServiceResponse(
      response: res,
      responseCode: result.networkServiceResponse.responseCode,
    );
  }

  @override
  createNewFormField(String authToken, EventData eventDataWithForm,
      {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<FormActionResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(eventDataWithForm),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = FormActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  uploadGalleryMedia(String authToken, String mediaPath) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(_uploadMediaUrl));

    var headers = {
      'Authorization': authToken,
      "Content-Type": "multipart/form-data;"
    };

    request.headers.addAll(headers);

    String mediaName;

    if (isValid(mediaPath)) {
      mediaName = mediaPath
          .split("/")
          .last;

      //create multipart using filepath, string or bytes
      var multipartFile = await http.MultipartFile.fromPath("file", mediaPath,
          filename: mediaName, contentType: MediaType.parse('image/jpeg'));

      //add multipart to request
      request.files.add(multipartFile);
    }

    var result = await rest.multipartUpload<MediaUploadResponse>(request);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = MediaUploadResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  createGalleryData(String authToken, EventData eventData,
      {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<GalleryResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(eventData),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = GalleryResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }
}
