class BasicJson {
  String title;
  List<String> tags;
  String description;
  String type;
  String eventFrequency;
  String startDateTime;
  String endDateTime;
  Daily daily;
  Weekly weekly;
  Custom custom;
  Place place;
  String eventPrivacy;
  String timeZone;

  BasicJson(
      {this.title,
        this.tags,
        this.description,
        this.type,
        this.eventFrequency,
        this.startDateTime,
        this.endDateTime,
        this.daily,
        this.weekly,
        this.custom,
        this.place,
        this.eventPrivacy,
        this.timeZone});

  BasicJson.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    tags = json['tags'].cast<String>();
    description = json['description'];
    type = json['type'];
    eventFrequency = json['eventFrequency'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    daily = json['daily'] != null ? new Daily.fromJson(json['daily']) : null;
    weekly =
    json['weekly'] != null ? new Weekly.fromJson(json['weekly']) : null;
    custom =
    json['custom'] != null ? new Custom.fromJson(json['custom']) : null;
    place = json['place'] != null ? new Place.fromJson(json['place']) : null;
    eventPrivacy = json['eventPrivacy'];
    timeZone = json['timeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['tags'] = this.tags;
    data['description'] = this.description;
    data['type'] = this.type;
    data['eventFrequency'] = this.eventFrequency;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    if (this.daily != null) {
      data['daily'] = this.daily.toJson();
    }
    if (this.weekly != null) {
      data['weekly'] = this.weekly.toJson();
    }
    if (this.custom != null) {
      data['custom'] = this.custom.toJson();
    }
    if (this.place != null) {
      data['place'] = this.place.toJson();
    }
    data['eventPrivacy'] = this.eventPrivacy;
    data['timeZone'] = this.timeZone;
    return data;
  }
}

class Daily {
  String startDate;
  String endDate;
  String startTime;
  String endTime;

  Daily({this.startDate, this.endDate, this.startTime, this.endTime});

  Daily.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}

class Weekly {
  String day;
  String startDate;
  String endDate;
  String startTime;
  String endTime;

  Weekly(
      {this.day, this.startDate, this.endDate, this.startTime, this.endTime});

  Weekly.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}

class Custom {
  List<String> selectedDays;
  String startTime;
  String endTime;

  Custom({this.selectedDays, this.startTime, this.endTime});

  Custom.fromJson(Map<String, dynamic> json) {
    selectedDays = json['selectedDays'].cast<String>();
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedDays'] = this.selectedDays;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}

class Place {
  String lat;
  String lng;
  String address;
  String pincode;
  String city;
  String state;
  String name;

  Place(
      {this.lat,
        this.lng,
        this.address,
        this.pincode,
        this.city,
        this.state,
        this.name});

  Place.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['name'] = this.name;
    return data;
  }
}