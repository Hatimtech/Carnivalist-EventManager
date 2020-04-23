import 'carnivals.dart';

class CarnivalResonse{
  int code;
  List<Carnivals> carnivalList;

  CarnivalResonse({this.code, this.carnivalList});

  CarnivalResonse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['message'] != null) {
      carnivalList = new List<Carnivals>();
      json['message'].forEach((v) {
        carnivalList.add(new Carnivals.fromJson(v));
      });
    }
  }
}