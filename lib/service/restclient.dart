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
//      printWrapped('Response Body--->${response.body}');
      return processResponse<T>(response);
    } catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              error: e.toString().contains('SocketException')
                  ? ERR_NO_INTERNET
                  : ERR_SOMETHING_WENT_WRONG));
    }
  }

  Future<MappedNetworkServiceResponse<T>> getwithoutHeader<T>(
      String url) async {
    print('Post Url--->$url');

    try {
      var response = await http.get(url);
//      printWrapped('Response Body--->${response.body}');
      return processResponse<T>(response);
    } catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              error: e.toString().contains('SocketException')
                  ? ERR_NO_INTERNET
                  : ERR_SOMETHING_WENT_WRONG));
    }
  }

  post<T>(String url, {Map headers, body, encoding}) async {
    print('Post Url--->$url');
    printWrapped('Json to upload--->$body');

    try {
      var response = await http.post(url,
          headers: headers, body: body, encoding: encoding);
//      print('Response Body--->${response.body}');
      return processResponse<T>(response);
    } catch (e) {
      print(e.toString());
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              error: e.toString().contains('SocketException')
                  ? ERR_NO_INTERNET
                  : ERR_SOMETHING_WENT_WRONG));
    }
  }

  multipartUpload<T>(http.MultipartRequest multipartRequest) async {
    try {
      var response = await multipartRequest.send();

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print('Media Upload Response--->$responseString');

      if (response.statusCode > ok200) {
        if (responseString != null && responseString.isNotEmpty) {
          try {
            var parsedResponse = json.decode(responseString);
            return new MappedNetworkServiceResponse<T>(
                networkServiceResponse: new NetworkServiceResponse<T>(
                    error:
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
                error: ERR_SOMETHING_WENT_WRONG,
                responseCode: response.statusCode));
      } else {
        return new MappedNetworkServiceResponse<T>(
            mappedResult: responseString,
            networkServiceResponse:
            NetworkServiceResponse<T>(responseCode: response.statusCode));
      }
    } catch (e) {
      print(e.toString());
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0,
              error: e.toString().contains('SocketException')
                  ? ERR_NO_INTERNET
                  : ERR_SOMETHING_WENT_WRONG));
    }
  }

  processResponse<T>(http.Response response) {
    if (response.statusCode > ok200) {
      if (response.body != null && response.body.isNotEmpty) {
        try {
          var parsedResponse = json.decode(response.body);
          return new MappedNetworkServiceResponse<T>(
              networkServiceResponse: new NetworkServiceResponse<T>(
                  error:
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
              error: ERR_SOMETHING_WENT_WRONG,
              responseCode: response.statusCode));
    } else {
      return new MappedNetworkServiceResponse<T>(
          mappedResult: response.body,
          networkServiceResponse:
          NetworkServiceResponse<T>(responseCode: response.statusCode));
    }
  }
}
