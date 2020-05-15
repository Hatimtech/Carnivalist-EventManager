import 'package:eventmanagement/model/event/field_data.dart';
import 'package:eventmanagement/model/event/gallery/gallery_data.dart';
import 'package:eventmanagement/model/event/settings/cancellation_policy.dart';
import 'package:eventmanagement/model/event/settings/payment_and_taxes.dart';
import 'package:eventmanagement/model/event/settings/website_setting.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';

class EventData {
  String id;
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
  List<Ticket> tickets;
  List<FieldData> formStructure;

  String banner;
  List<GalleryData> gallery;

  String status;
  CancellationPolicy cancellationPolicy;
  PaymentAndTaxes paymentAndTaxes;
  WebsiteSetting websiteSettings;

  EventData({
    this.id,
    this.title,
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
    this.timeZone,
    this.tickets,
    this.formStructure,
    this.banner,
    this.gallery,
    this.status,
    this.cancellationPolicy,
    this.paymentAndTaxes,
    this.websiteSettings,
  });

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
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
    tickets =
        (json['tickets'] as List)?.map((e) => Ticket.fromJson(e))?.toList();
    formStructure = (json['formStructure'] as List)
        ?.map((e) => FieldData.fromJson(e))
        ?.toList();
    banner = json['banner'];
    gallery = (json['gallery'] as List)
        ?.map((e) => GalleryData.fromJson(e))
        ?.toList();

    status = json['status'];
    cancellationPolicy = json['cancellationPolicy'] != null
        ? new CancellationPolicy.fromJson(json['cancellationPolicy'])
        : null;
    paymentAndTaxes = json['paymentAndTaxes'] != null
        ? new PaymentAndTaxes.fromJson(json['paymentAndTaxes'])
        : null;
    websiteSettings = json['websiteSettings'] != null
        ? new WebsiteSetting.fromJson(json['websiteSettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['_id'] = this.id;
    if (this.title != null) data['title'] = this.title;
    if (this.tags != null) data['tags'] = this.tags;
    if (this.description != null) data['description'] = this.description;
    if (this.type != null) data['type'] = this.type;
    if (this.eventFrequency != null)
      data['eventFrequency'] = this.eventFrequency;
    if (this.startDateTime != null) data['startDateTime'] = this.startDateTime;
    if (this.endDateTime != null) data['endDateTime'] = this.endDateTime;
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
    if (this.eventPrivacy != null) data['eventPrivacy'] = this.eventPrivacy;
    if (this.timeZone != null) data['timeZone'] = this.timeZone;

    if (this.tickets != null)
      data['tickets'] =
          this.tickets?.map((ticket) => ticket.toJson())?.toList();
    if (this.formStructure != null)
      data['formStructure'] =
          this.formStructure?.map((formData) => formData.toJson())?.toList();

    if (this.banner != null) data['banner'] = this.banner;
    if (this.gallery != null)
      data['gallery'] =
          this.gallery?.map((formData) => formData.toJson())?.toList();

    if (this.status != null) data['status'] = this.status;
    if (this.cancellationPolicy != null) {
      data['cancellationPolicy'] = this.cancellationPolicy.toJson();
    }
    if (this.paymentAndTaxes != null) {
      data['paymentAndTaxes'] = this.paymentAndTaxes.toJson();
    }
    if (this.websiteSettings != null) {
      data['websiteSettings'] = this.websiteSettings.toJson();
    }

    return data;
  }

  @override
  String toString() {
    return 'EventData{id: $id, title: $title, tags: $tags, description: $description, type: $type, eventFrequency: $eventFrequency, startDateTime: $startDateTime, endDateTime: $endDateTime, daily: $daily, weekly: $weekly, custom: $custom, place: $place, eventPrivacy: $eventPrivacy, timeZone: $timeZone, tickets: $tickets, formStructure: $formStructure, banner: $banner, gallery: $gallery, status: $status, cancellationPolicy: $cancellationPolicy, paymentAndTaxes: $paymentAndTaxes, websiteSettings: $websiteSettings}';
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
  List<CustomDateTime> selectedDays;
  String startTime;
  String endTime;

  Custom({this.selectedDays, this.startTime, this.endTime});

  Custom.fromJson(Map<String, dynamic> json) {
    selectedDays = (json['selectedDays'] as List)
        ?.map((e) => CustomDateTime.fromJson(e))
        ?.toList();
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedDays'] = this
        .selectedDays
        ?.map((customDateTime) => customDateTime.toJson())
        ?.toList();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}

class CustomDateTime {
  String startDateTime;
  String endDateTime;

  CustomDateTime({this.startDateTime, this.endDateTime});

  CustomDateTime.fromJson(Map<String, dynamic> json) {
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
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
