import 'package:eventmanagement/model/eventdetails/form_payload_answers.dart';
import 'package:eventmanagement/model/eventdetails/payment_response.dart';
import 'package:eventmanagement/model/eventdetails/ticket_detail.dart';
import 'package:eventmanagement/model/eventdetails/user_detail.dart';

class EventDetail {
  String id;
  DateTime createdAt;
  List<UserDetail> user;
  List<TicketDetail> tickets;
  PaymentResponse paymentResponse;
  bool isEventAttended;
  List<FormPayloadAnswers> formPayloadAnswers;

//  List<EventData> eventDetails;

  EventDetail({
    this.id,
    this.createdAt,
    this.user,
    this.paymentResponse,
    this.tickets,
    this.isEventAttended,
    this.formPayloadAnswers,
//    this.eventDetails,
  });

  EventDetail.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    user = (json['user'] as List)?.map((e) => UserDetail.fromJson(e))?.toList();
    paymentResponse = json['paymentResponse'] != null
        ? new PaymentResponse.fromJson(json['paymentResponse'])
        : null;
    tickets = (json['tickets'] as List)
        ?.map((e) => TicketDetail.fromJson(e))
        ?.toList();
    isEventAttended = json['isEventAttended'];
    formPayloadAnswers = (json['formPayloadAnswers'] as List)
        ?.map((e) => FormPayloadAnswers.fromJson(e))
        ?.toList();
//    eventDetails = (json['eventDetails'] as List)
//        ?.map((e) => EventData.fromJson(e))
//        ?.toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['_id'] = this.id;
    if (this.createdAt != null) data['createdAt'] = this.createdAt;
    if (this.user != null)
      data['user'] = this.user.map((user) => user.toJson())?.toList();
    if (this.paymentResponse != null) {
      data['paymentResponse'] = this.paymentResponse.toJson();
    }
    if (this.tickets != null)
      data['tickets'] = this.tickets.map((ticket) => ticket.toJson())?.toList();

    if (this.isEventAttended != null)
      data['isEventAttended'] = this.isEventAttended;
    if (this.formPayloadAnswers != null)
      data['formPayloadAnswers'] = this.formPayloadAnswers;
//    if (this.eventDetails != null)
//      data['eventDetails'] =
//          this.eventDetails.map((eventData) => eventData.toJson())?.toList();
    return data;
  }
}
