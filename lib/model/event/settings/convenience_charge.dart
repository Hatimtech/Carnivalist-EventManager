class ConvenienceCharge {
  bool precentage;
  String percentValue;
  String value;
  bool enable;

  ConvenienceCharge({
    this.precentage,
    this.percentValue,
    this.value,
    this.enable,
  });

  ConvenienceCharge.fromJson(Map<String, dynamic> json) {
    precentage = json['precentage'];
    percentValue = json['percentValue'];
    value = json['value'];
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.precentage != null) data['precentage'] = this.precentage;
    if (this.percentValue != null) data['percentValue'] = this.percentValue;
    if (this.value != null) data['value'] = this.value;
    if (this.enable != null) data['enable'] = this.enable;
    return data;
  }
}
