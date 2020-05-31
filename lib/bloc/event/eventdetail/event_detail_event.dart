import 'dart:async';

import 'package:eventmanagement/model/eventdetails/event_detail.dart';

abstract class EventDetailEvent {}

class AuthTokenSave extends EventDetailEvent {
  final String authToken;

  AuthTokenSave({this.authToken});
}

class DeleteCoupon extends EventDetailEvent {
  final String id;

  DeleteCoupon(this.id);
}

class GetEventDetail extends EventDetailEvent {
  Completer<bool> downloadCompleter;

  GetEventDetail({this.downloadCompleter});
}

class EventDetailAvailable extends EventDetailEvent {
  final bool success;
  final dynamic error;
  final List<EventDetail> couponList;

  EventDetailAvailable(this.success, {this.error, this.couponList});
}

class ResendTicketEvent extends EventDetailEvent {
  final String orderId;
  final String email;
  final Function callback;

  ResendTicketEvent({this.orderId, this.email, this.callback});
}

class ResendTicketEventResult extends EventDetailEvent {
  final bool success;
  final dynamic uiMsg;

  ResendTicketEventResult(this.success, {this.uiMsg});
}

class TagScannedEvent extends EventDetailEvent {
  final String tag;
  final bool isNFC;
  final Function callback;

  TagScannedEvent({this.tag, this.isNFC, this.callback});
}

class TagScannedEventResult extends EventDetailEvent {
  final bool success;
  final dynamic uiMsg;
  final String eventDetailId;

  TagScannedEventResult(this.success, {this.uiMsg, this.eventDetailId});
}
