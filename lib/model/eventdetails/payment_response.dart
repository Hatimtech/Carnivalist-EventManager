class PaymentResponse {
  String orderId;
  double txnAmount;
  String currency;
  String txnStatus;

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['ORDERID'];
    txnAmount = json['TXNAMOUNT']?.toDouble();
    currency = json['CURRENCY'];
    txnStatus = json['STATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderId != null) data['ORDERID'] = this.orderId;
    if (this.txnAmount != null) data['TXNAMOUNT'] = this.txnAmount;
    if (this.currency != null) data['CURRENCY'] = this.currency;
    if (this.txnStatus != null) data['STATUS'] = this.txnStatus;
    return data;
  }
}
