class GSTCharge {
  bool enable;
  int gstValue;

  GSTCharge({
    this.enable,
    this.gstValue,
  });

  GSTCharge.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    gstValue = json['gstValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.enable != null) data['enable'] = this.enable;
    if (this.gstValue != null) data['gstValue'] = this.gstValue;
    return data;
  }

  factory GSTCharge.defaultInstance() {
    return GSTCharge(enable: false, gstValue: 18);
  }
}
