class PaymentSummary {
  int quantity;
  double amount;

  PaymentSummary({
    this.quantity,
    this.amount,
  });

  PaymentSummary.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    amount = json['amount']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.quantity != null) data['quantity'] = this.quantity;
    if (this.amount != null) data['amount'] = this.amount;
    return data;
  }
}
