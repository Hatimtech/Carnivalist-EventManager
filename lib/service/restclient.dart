import 'dart:convert';

import 'package:eventmanagement/model/api_response.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:http/http.dart' as http;

import 'network_service_response.dart';

class RestClient {
  Future<MappedNetworkServiceResponse<T>> get<T>(String url,
      Map headers) async {
    print('Get Url--->$url');

    try {
      var response = await http.get(url, headers: headers);
      print('Response Body--->${response.body}');
      return processResponse<T>(response);
    } catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              errorMessage: e.toString().contains('SocketException')
                  ? 'No internet'
                  : e.toString()));
    }
  }

  Future<MappedNetworkServiceResponse<T>> getwithoutHeader<T>(
      String url) async {
    print('Post Url--->$url');

    try {
      var response = await http.get(url);
      print('Response Body--->${response.body}');
      return processResponse<T>(response);
    } catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              errorMessage: e.toString().contains('SocketException')
                  ? 'No internet'
                  : e.toString()));
    }
  }

  post<T>(String url, {Map headers, body, encoding}) async {
    print('Post Url--->$url');
    printWrapped('Json to upload--->$body');

    try {
      var response = await http.post(url,
          headers: headers, body: body, encoding: encoding);
      print('Response Body--->${response.body}');
      return processResponse<T>(response);
    } catch (e) {
      print(e.toString());
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              errorMessage: e.toString().contains('SocketException')
                  ? 'Please check your internet.'
                  : e.toString()));
    }
  }

  processResponse<T>(http.Response response) {
    if (response.statusCode > ok200) {
      if (response.body != null && response.body.isNotEmpty) {
        try {
          var parsedResponse = json.decode(response.body);
          return new MappedNetworkServiceResponse<T>(
              networkServiceResponse: new NetworkServiceResponse<T>(
                  errorMessage:
                  ApiResponse
                      .fromJson(parsedResponse)
                      .responseMessage,
                  responseCode: response.statusCode));
        } on FormatException catch (e) {
          print('FormatException parsing response data--->$e');
        }
      }
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              errorMessage: 'Something went wrong',
              responseCode: response.statusCode));
    } else {
      return new MappedNetworkServiceResponse<T>(
          mappedResult: response.body,
          networkServiceResponse:
          NetworkServiceResponse<T>(responseCode: response.statusCode));
    }
  }
}
