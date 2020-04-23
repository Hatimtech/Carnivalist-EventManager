class NetworkServiceResponse<T> {
  T response;
  String errorMessage;
  int responseCode;

  NetworkServiceResponse({this.response, this.responseCode, this.errorMessage});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}
