class Staff {
  String id;
  String name;
  String username;
  String mobileNumber;
  String email;
  String city;
  String state;
  String dob;
  String password;
  bool isBlockedByAdmin;
  bool isDisabled;
  List<String> selectedEvents;

  Staff(
      {this.id,
      this.name,
      this.username,
      this.mobileNumber,
      this.email,
      this.city,
      this.state,
      this.dob,
      this.password,
      this.isBlockedByAdmin,
      this.isDisabled,
      this.selectedEvents});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    city = json['city'];
    state = json['state'];
    dob = json['dob'];
    password = json['password'];
    isBlockedByAdmin = json['isBlockedByAdmin'];
    isDisabled = json['isDisabled'];
    selectedEvents = json['selectedEvents']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['_id'] = this.id;
    if (this.name != null) data['name'] = this.name;
    if (this.username != null) data['username'] = this.username;
    if (this.mobileNumber != null) data['mobileNumber'] = this.mobileNumber;
    if (this.email != null) data['email'] = this.email;
    if (this.city != null) data['city'] = this.city;
    if (this.state != null) data['state'] = this.state;
    if (this.dob != null) data['dob'] = this.dob;
    if (this.isBlockedByAdmin != null)
      data['isBlockedByAdmin'] = this.isBlockedByAdmin;
    if (this.isDisabled != null) data['isDisabled'] = this.isDisabled;
    if (this.selectedEvents != null)
      data['selectedEvents'] = this.selectedEvents;
    return data;
  }
}
