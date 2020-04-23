class Tickets {
  List<String> addons;
  bool active;
  bool isDeleted;
  String sId;
  String sellingEndDate;
  String currency;
  int price;
  int quantity;
  int minOrderQuantity;
  int maxOrderQuantity;
  String name;
  String description;
  String event;
  String sellingStartDate;
  int iV;

  Tickets({name, sellingEndDate, price, addons});

  Tickets.fromJson(Map<String, dynamic> json) {
    addons = json['addons'].cast<String>();
    active = json['active'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    sellingEndDate = json['sellingEndDate'];
    currency = json['currency'];
    price = json['price'];
    quantity = json['quantity'];
    minOrderQuantity = json['minOrderQuantity'];
    maxOrderQuantity = json['maxOrderQuantity'];
    name = json['name'];
    description = json['description'];
    event = json['event'];
    sellingStartDate = json['sellingStartDate'];
    iV = json['__v'];
  }
}
