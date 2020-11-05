class Ticket {
  List<String> addons;
  bool active;
  bool isDeleted;
  String sId;
  String sellingEndDate;
  String currency;
  double price;
  int quantity;
  int initialOriginalQuantity;
  int minOrderQuantity;
  int maxOrderQuantity;
  String name;
  String description;
  String event;
  String sellingStartDate;
  int iV;

  Ticket({name, sellingEndDate, price, addons});

  Ticket.fromJson(Map<String, dynamic> json) {
    addons = json['addons']?.cast<String>();
    active = json['active'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    sellingEndDate = json['sellingEndDate'];
    currency = json['currency'];
    price = json['price']?.toDouble();
    quantity = json['quantity'];
    initialOriginalQuantity = json['initialOriginalQuantity'];
    minOrderQuantity = json['minOrderQuantity'];
    maxOrderQuantity = json['maxOrderQuantity'];
    name = json['name'];
    description = json['description'];
    event = json['event'];
    sellingStartDate = json['sellingStartDate'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addons'] = this.addons;
    data['active'] = this.active;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['sellingEndDate'] = this.sellingEndDate;
    data['currency'] = this.currency;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['initialOriginalQuantity'] = this.initialOriginalQuantity;
    data['minOrderQuantity'] = this.minOrderQuantity;
    data['maxOrderQuantity'] = this.maxOrderQuantity;
    data['name'] = this.name;
    data['description'] = this.description;
    data['event'] = this.event;
    data['sellingStartDate'] = this.sellingStartDate;
    data['iV'] = this.iV;
    return data;
  }
}
