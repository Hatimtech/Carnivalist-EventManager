class NetworkServiceResponse<T> {
  T response;
  dynamic error;
  int responseCode;

  NetworkServiceResponse({this.response, this.responseCode, this.error});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}
