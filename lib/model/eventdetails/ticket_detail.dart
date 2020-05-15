class TicketDetail {
  int noOfTicket;

  TicketDetail(this.noOfTicket);

  TicketDetail.fromJson(Map<String, dynamic> json) {
    noOfTicket = json['noOfTicket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.noOfTicket != null) data['noOfTicket'] = this.noOfTicket;
    return data;
  }
}
