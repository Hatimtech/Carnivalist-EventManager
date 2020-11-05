class Carnivals {

  String id;
  bool isCarnivalActive;
  String category;
  String slug;
  String location;
  String startDate;
  String endDate;
  String imageLink;
  int selectedColorIndex;
  int iV;
  List<String> color;

  Carnivals({id, category, location});

  Carnivals.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    isCarnivalActive = json['isCarnivalActive'];
    category = json['category'];
    slug = json['slug'];
    location = json['location'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    imageLink = json['imageLink'];
    selectedColorIndex = json['selectedColorIndex'];
    iV = json['__v'];
  }
}
