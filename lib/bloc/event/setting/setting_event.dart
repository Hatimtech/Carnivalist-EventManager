abstract class SettingEvent {}

class PaymentType extends SettingEvent {
}

class SelectPaymentTypeName extends SettingEvent {
  final String paymentTypeName;
  SelectPaymentTypeName({this.paymentTypeName});
}

