class ApiResponse {
  final String responseCode;
  final String responseMessage;

  ApiResponse({this.responseCode, this.responseMessage});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return new  ApiResponse(
      responseCode: json['RESPONSECODE'],
      responseMessage: json['RESPONSEMESSAGE'],
    );
  }
}
