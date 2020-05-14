import 'package:eventmanagement/utils/vars.dart';

class Addon {
  String id;
  String name;
  bool active;
  DateTime startDateTime;
  DateTime endDateTime;
  int quantity;
  String privacy;
  double price;
  String currency;
  String gst;
  bool chargeConvinenceFee;
  String convinenceFeeType;
  double convenienceFee;
  String description;
  String image;
  String user;
  DateTime createdAt;
  DateTime updatedAt;

  bool isSelected;

  Addon({
    this.id,
    this.name,
    this.active,
    this.startDateTime,
    this.endDateTime,
    this.quantity,
    this.price,
    this.currency,
    this.gst,
    this.chargeConvinenceFee,
    this.convinenceFeeType,
    this.convenienceFee,
    this.description,
    this.image,
    this.privacy,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.isSelected = false,
  });

  Addon.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    active = json['active'];
    startDateTime = isValid(json['Start Date'])
        ? DateTime.parse(json['Start Date'])
        : null;
    endDateTime = isValid(json['End Date'])
        ? DateTime.parse(json['End Date'])
        : null;
    quantity = json['quantity'];
    privacy = json['privacy'];
    price = json['price']?.toDouble();
    currency = json['currency'];

    gst = json['GST'];
    chargeConvinenceFee = json['Charge convinence fee'];
    convinenceFeeType = json['Convinence Fee type'];
    convenienceFee = json['Convinence Fee']?.toDouble();
    description = json['description'];
    image = json['image'];
    user = json['user'];
    createdAt = isValid(json['createdAt'])
        ? DateTime.parse(json['createdAt'])
        : null;
    updatedAt = isValid(json['updatedAt'])
        ? DateTime.parse(json['updatedAt'])
        : null;
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.name != null) data['name'] = this.name;
    if (this.active != null) data['active'] = this.active;
    if (this.description != null) data['description'] = this.description;
    if (this.startDateTime != null)
      data['Start Date'] = this.startDateTime.toIso8601String();
    if (this.endDateTime != null)
      data['End Date'] = this.endDateTime.toIso8601String();
    if (this.quantity != null) data['quantity'] = this.quantity;
    if (this.privacy != null) data['privacy'] = this.privacy;
    if (this.price != null) data['price'] = this.price;

    if (this.currency != null) data['currency'] = this.currency;
    if (this.gst != null) data['GST'] = this.gst;

    if (this.chargeConvinenceFee != null)
      data['Charge convinence fee'] = this.chargeConvinenceFee;

    if (this.convinenceFeeType != null)
      data['Convinence Fee type'] = this.convinenceFeeType;
    if (this.convenienceFee != null)
      data['Convinence Fee'] = this.convenienceFee;

    if (this.image != null) data['image'] = this.image;

    if (this.user != null) data['user'] = this.user;

    if (this.createdAt != null)
      data['createdAt'] = this.createdAt.toIso8601String();
    if (this.updatedAt != null)
      data['updatedAt'] = this.updatedAt.toIso8601String();
    if (this.isSelected != null) data['isSelected'] = this.isSelected;

    return data;
  }
}
