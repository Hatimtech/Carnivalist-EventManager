class WebsiteSetting {
  bool bookingCancellation;
  bool bookingUpgradation;
  bool remaningTickets;
  bool showDateTime;
  bool showPrice;
  bool showLocation;
  bool transferBooking;

  String facebookLink;
  String twitterLink;
  String linkdinLink;
  String websiteLink;
  String paymentGatewayPayPerson;
  String bookButtonLabel;

  WebsiteSetting({
    this.bookingCancellation,
    this.bookingUpgradation,
    this.remaningTickets,
    this.showDateTime,
    this.showPrice,
    this.showLocation,
    this.transferBooking,
    this.facebookLink,
    this.twitterLink,
    this.linkdinLink,
    this.websiteLink,
    this.paymentGatewayPayPerson,
    this.bookButtonLabel,
  });

  WebsiteSetting.fromJson(Map<String, dynamic> json) {
    bookingCancellation = json['bookingCancellation'];
    bookingUpgradation = json['bookingUpgradation'];
    remaningTickets = json['remaningTickets'];
    showDateTime = json['showDateTime'];
    showPrice = json['showPrice'];
    showLocation = json['showLocation'];
    transferBooking = json['transferBooking'];

    facebookLink = json['facebookLink'];
    twitterLink = json['twitterLink'];
    linkdinLink = json['linkdinLink'];
    websiteLink = json['websiteLink'];
    paymentGatewayPayPerson = json['paymentGatewayPayPerson'];
    bookButtonLabel = json['bookButtonLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingCancellation != null)
      data['bookingCancellation'] = this.bookingCancellation;
    if (this.bookingUpgradation != null)
      data['bookingUpgradation'] = this.bookingUpgradation;
    if (this.remaningTickets != null)
      data['remaningTickets'] = this.remaningTickets;
    if (this.showDateTime != null) data['showDateTime'] = this.showDateTime;
    if (this.showPrice != null) data['showPrice'] = this.showPrice;
    if (this.showLocation != null) data['showLocation'] = this.showLocation;
    if (this.transferBooking != null)
      data['transferBooking'] = this.transferBooking;
    if (this.facebookLink != null) data['facebookLink'] = this.facebookLink;
    if (this.twitterLink != null) data['twitterLink'] = this.twitterLink;
    if (this.linkdinLink != null) data['linkdinLink'] = this.linkdinLink;
    if (this.websiteLink != null) data['websiteLink'] = this.websiteLink;
    if (this.paymentGatewayPayPerson != null)
      data['paymentGatewayPayPerson'] = this.paymentGatewayPayPerson;
    if (this.bookButtonLabel != null)
      data['bookButtonLabel'] = this.bookButtonLabel;
    return data;
  }
}
