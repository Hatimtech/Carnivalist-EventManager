import 'package:eventmanagement/model/event/settings/cancellation_option.dart';
import 'package:eventmanagement/model/menu_custom.dart';

class SettingState {
  final String authToken;
  bool loading;
  List<MenuCustom> paymentTypeList;

  bool precentage;
  String percentValue;
  String convenienceAmount;
  bool convenienceFee;

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
  MenuCustom paymentGatewayPayPerson;
  String bookButtonLabel;

  String cancellationPolicyDesc;
  List<CancellationOption> cancellationOptions;

  bool tnc;

  int errorCode;

  SettingState({
    this.authToken,
    this.loading,
    this.paymentTypeList,
    this.precentage,
    this.percentValue,
    this.convenienceAmount,
    this.convenienceFee,
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
    this.cancellationPolicyDesc,
    this.cancellationOptions,
    this.tnc,
    this.errorCode,
  });

  factory SettingState.initial() {
    return SettingState(
      authToken: '',
      loading: false,
      paymentTypeList: List(),
      precentage: false,
      percentValue: '',
      convenienceAmount: '',
      convenienceFee: true,
      bookingCancellation: false,
      bookingUpgradation: false,
      remaningTickets: true,
      showDateTime: true,
      showPrice: true,
      showLocation: true,
      transferBooking: true,
      facebookLink: '',
      twitterLink: '',
      linkdinLink: '',
      websiteLink: '',
      paymentGatewayPayPerson: null,
      bookButtonLabel: '',
      cancellationPolicyDesc: '',
      cancellationOptions: [
        CancellationOption(refundType: 'amount', refundValue: '0')
      ],
      tnc: false,
      errorCode: null,
    );
  }

  SettingState copyWith({
    String authToken,
    bool loading,
    List<MenuCustom> paymentTypeList,
    bool precentage,
    String percentValue,
    String convenienceAmount,
    bool convenienceFee,
    bool bookingCancellation,
    bool bookingUpgradation,
    bool remaningTickets,
    bool showDateTime,
    bool showPrice,
    bool showLocation,
    bool transferBooking,
    String facebookLink,
    String twitterLink,
    String linkdinLink,
    String websiteLink,
    MenuCustom paymentGatewayPayPerson,
    String bookButtonLabel,
    String cancellationPolicyDesc,
    List<CancellationOption> cancellationOptions,
    bool tnc,
    int errorCode = null,
  }) {
    return SettingState(
      authToken: authToken ?? this.authToken,
      loading: loading ?? this.loading,
      paymentTypeList: paymentTypeList ?? this.paymentTypeList,
      precentage: precentage ?? this.precentage,
      percentValue: percentValue ?? this.percentValue,
      convenienceAmount: convenienceAmount ?? this.convenienceAmount,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      bookingCancellation: bookingCancellation ?? this.bookingCancellation,
      bookingUpgradation: bookingUpgradation ?? this.bookingUpgradation,
      remaningTickets: remaningTickets ?? this.remaningTickets,
      showDateTime: showDateTime ?? this.showDateTime,
      showPrice: showPrice ?? this.showPrice,
      showLocation: showLocation ?? this.showLocation,
      transferBooking: transferBooking ?? this.transferBooking,
      facebookLink: facebookLink ?? this.facebookLink,
      twitterLink: twitterLink ?? this.twitterLink,
      linkdinLink: linkdinLink ?? this.linkdinLink,
      websiteLink: websiteLink ?? this.websiteLink,
      paymentGatewayPayPerson:
      paymentGatewayPayPerson ?? this.paymentGatewayPayPerson,
      bookButtonLabel: bookButtonLabel ?? this.bookButtonLabel,
      cancellationPolicyDesc:
      cancellationPolicyDesc ?? this.cancellationPolicyDesc,
      cancellationOptions: cancellationOptions ?? this.cancellationOptions,
      tnc: tnc ?? this.tnc,
      errorCode: errorCode,
    );
  }
}
