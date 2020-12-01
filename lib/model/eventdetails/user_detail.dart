class UserDetail {
  String id;
  String name;
  String username;
  String mobileNumber;

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['_id'] = this.id;
    if (this.name != null) data['name'] = this.name;
    if (this.username != null) data['username'] = this.username;
    if (this.mobileNumber != null) data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}
