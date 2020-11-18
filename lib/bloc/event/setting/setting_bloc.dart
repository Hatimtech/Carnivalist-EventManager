import 'package:bloc/bloc.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/settings/cancellation_option.dart';
import 'package:eventmanagement/model/event/settings/cancellation_policy.dart';
import 'package:eventmanagement/model/event/settings/convenience_charge.dart';
import 'package:eventmanagement/model/event/settings/gst_charge.dart';
import 'package:eventmanagement/model/event/settings/payment_and_taxes.dart';
import 'package:eventmanagement/model/event/settings/setting_response.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';
import 'package:eventmanagement/model/event/settings/website_setting.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';

import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final ApiProvider apiProvider = ApiProvider();
  String eventDataId;
  bool isUpdating = false;

  SettingBloc() : super(initialState);

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void settingDefault() {
    add(SettingDefault());
  }

  void populateExistingEvent(eventData) {
    add(PopulateExistingEvent(eventData: eventData));
  }

  void paymentType() {
    add(PaymentType());
  }

  void selectPaymentGatewayBy(paymentBy) {
    add(SelectPaymentGatewayPayBy(paymentBy: paymentBy));
  }

  void convenienceFeeInput(enable) {
    add(SelectConvenienceFee(enable: enable));
  }

  void conveniencePercentInput(input) {
    add(ConveniencePercentageInput(input: input));
  }

  void convenienceAmountInput(input) {
    add(ConvenienceAmountInput(input: input));
  }

  void bookingCancellationInput(enable) {
    add(SelectBookingCancellation(enable: enable));
  }

  void bookingCancellationDescInput(input) {
    add(BookingCancellationDescInput(input: input));
  }

  void addCancellationPolicyOption() {
    add(AddCancellationPolicyOption());
  }

  void removeCancellationPolicyOption(index) {
    add(RemoveCancellationPolicyOption(index: index));
  }

  void cancellationPolicyDeductionType(index, isPercentage) {
    add(CancellationPolicyDeductionType(
        index: index, isPercentage: isPercentage));
  }

  void cancellationPolicyDeductionInput(index, input) {
    add(CancellationPolicyDeductionInput(
        index: index, input: double.tryParse(input)));
  }

  void cancellationPolicyEndDate(index, dateTime) {
    add(CancellationPolicyEndDate(index: index, dateTime: dateTime));
  }

  void bookingTransferInput(enable) {
    add(SelectBookingTransfer(enable: enable));
  }

  void remainingTicketsInput(enable) {
    add(SelectRemainingTickets(enable: enable));
  }

  void registrationLabelInput(input) {
    add(RegistrationLabelInput(input: input));
  }

  void facebookLinkInput(input) {
    add(FacebookLinkInput(input: input));
  }

  void twitterLinkInput(input) {
    add(TwitterLinkInput(input: input));
  }

  void linkedInLinkInput(input) {
    add(LinkedInLinkInput(input: input));
  }

  void websiteLinkInput(input) {
    add(WebsiteLinkInput(input: input));
  }

  void tncInput(input) {
    add(TnCInput(input: input));
  }

  void uploadSettings(callback) {
    add(UploadSettings(callback: callback));
  }

  static SettingState get initialState => SettingState.initial();

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is SettingDefault) {
      final paymentTypeList = getPaymentType();
      yield state.copyWith(
          paymentTypeList: getPaymentType(),
          paymentGatewayPayPerson: paymentTypeList[1]);
    }

    if (event is PopulateExistingEvent) {
      this.isUpdating = true;
      EventData eventData = event.eventData;
      bool precentage =
          eventData.paymentAndTaxes?.convenienceCharge?.precentage;
      String percentValue = eventData
          .paymentAndTaxes?.convenienceCharge?.percentValue
          ?.toString();
      String convenienceAmount =
      eventData.paymentAndTaxes?.convenienceCharge?.value?.toString();
      bool convenienceFee =
          eventData.paymentAndTaxes?.convenienceCharge?.enable;

      bool bookingCancellation = eventData.websiteSettings?.bookingCancellation;
      bool bookingUpgradation = eventData.websiteSettings?.bookingUpgradation;
      bool remaningTickets = eventData.websiteSettings?.remaningTickets;
      bool showDateTime = eventData.websiteSettings?.showDateTime;
      bool showPrice = eventData.websiteSettings?.showPrice;
      bool showLocation = eventData.websiteSettings?.showLocation;
      bool transferBooking = eventData.websiteSettings?.transferBooking;

      String facebookLink = eventData.websiteSettings?.facebookLink;
      String twitterLink = eventData.websiteSettings?.twitterLink;
      String linkdinLink = eventData.websiteSettings?.linkdinLink;
      String websiteLink = eventData.websiteSettings?.websiteLink;

      String paymentGatewayPayBy =
          eventData.websiteSettings?.paymentGatewayPayPerson;

      MenuCustom paymentGatewayPayPerson;
      if (isValid(paymentGatewayPayBy)) {
        paymentGatewayPayPerson = state.paymentTypeList.firstWhere(
                (menu) => menu.value == paymentGatewayPayBy,
            orElse: () => null);
      } else {
        paymentGatewayPayPerson = state.paymentTypeList[0];
      }
      String bookButtonLabel = eventData.websiteSettings?.bookButtonLabel;

      String cancellationPolicyDesc = eventData.cancellationPolicy?.description;
      List<CancellationOption> cancellationOptions =
      eventData.cancellationPolicy?.options?.map(
            (e) {
          return CancellationOption(
              refundType: e.refundType,
              refundValue: e.refundValue,
              cancellationEndDate: e.cancellationEndDate?.toLocal());
        },
      )?.toList();

      print('eventData.userContractCheck--->${eventData.userContractCheck}');

      yield state.copyWith(
        precentage: precentage,
        percentValue: percentValue,
        convenienceAmount: convenienceAmount,
        convenienceFee: convenienceFee,
        bookingCancellation: bookingCancellation,
        bookingUpgradation: bookingUpgradation,
        remaningTickets: remaningTickets,
        showDateTime: showDateTime,
        showPrice: showPrice,
        showLocation: showLocation,
        transferBooking: transferBooking,
        facebookLink: facebookLink,
        twitterLink: twitterLink,
        linkdinLink: linkdinLink,
        websiteLink: websiteLink,
        paymentGatewayPayPerson: paymentGatewayPayPerson,
        bookButtonLabel: bookButtonLabel,
        cancellationPolicyDesc: cancellationPolicyDesc,
        cancellationOptions: cancellationOptions,
        tnc: eventData.userContractCheck,
      );
    }

    if (event is PaymentType) {
      yield state.copyWith(paymentTypeList: getPaymentType());
    }

    if (event is SelectPaymentGatewayPayBy) {
      yield state.copyWith(paymentGatewayPayPerson: event.paymentBy);

      int id = state.paymentTypeList.indexWhere(
              (item) => item.value == state.paymentGatewayPayPerson.value);

      state.paymentTypeList.forEach((element) => element.isSelected = false);
      state.paymentTypeList[id].isSelected = true;

      yield state.copyWith(
        paymentTypeList: state.paymentTypeList,
        uploadRequired: true,
      );
    }

    if (event is SelectConvenienceFee) {
      yield state.copyWith(
        convenienceFee: event.enable,
        uploadRequired: true,
      );
    }

    if (event is ConveniencePercentageInput) {
      yield state.copyWith(
        percentValue: event.input,
        uploadRequired: true,
      );
    }

    if (event is ConvenienceAmountInput) {
      yield state.copyWith(
        convenienceAmount: event.input,
        uploadRequired: true,
      );
    }

    if (event is SelectBookingCancellation) {
      yield state.copyWith(
        bookingCancellation: event.enable,
        uploadRequired: true,
      );
    }

    if (event is BookingCancellationDescInput) {
      yield state.copyWith(
        cancellationPolicyDesc: event.input,
        uploadRequired: true,
      );
    }

    if (event is AddCancellationPolicyOption) {
      final options = List.of(state.cancellationOptions);
      options.add(CancellationOption(refundType: 'amount'));
      yield state.copyWith(
        cancellationOptions: options,
        uploadRequired: true,
      );
    }

    if (event is RemoveCancellationPolicyOption) {
      final options = List.of(state.cancellationOptions);
      options.removeAt(event.index);
      yield state.copyWith(
        cancellationOptions: options,
        uploadRequired: true,
      );
    }

    if (event is CancellationPolicyDeductionType) {
      final cancellationOptions = List.of(state.cancellationOptions);
      final cancellationOption = cancellationOptions[event.index];
      final newOption =
      CancellationOption.fromJson(cancellationOption.toJson());
      newOption.refundType = event.isPercentage ? 'percentage' : 'amount';
      cancellationOptions.removeAt(event.index);
      cancellationOptions.insert(event.index, newOption);
      yield state.copyWith(
        cancellationOptions: cancellationOptions,
        uploadRequired: true,
      );
    }

    if (event is CancellationPolicyDeductionInput) {
      final cancellationOption = state.cancellationOptions[event.index];
      cancellationOption.refundValue = event.input;
      state.uploadRequired = true;
    }

    if (event is CancellationPolicyEndDate) {
      final cancellationOption = state.cancellationOptions[event.index];
      final newOption =
      CancellationOption.fromJson(cancellationOption.toJson());
      newOption.cancellationEndDate = event.dateTime;
      state.cancellationOptions.removeAt(event.index);
      state.cancellationOptions.insert(event.index, newOption);
      yield state.copyWith(
        cancellationOptions: state.cancellationOptions,
        uploadRequired: true,
      );
    }

    if (event is SelectBookingTransfer) {
      yield state.copyWith(
        transferBooking: event.enable,
        uploadRequired: true,
      );
    }

    if (event is SelectRemainingTickets) {
      yield state.copyWith(
        remaningTickets: event.enable,
        uploadRequired: true,
      );
    }

    if (event is RegistrationLabelInput) {
      yield state.copyWith(
        bookButtonLabel: event.input,
        uploadRequired: true,
      );
    }

    if (event is FacebookLinkInput) {
      yield state.copyWith(
        facebookLink: event.input,
        uploadRequired: true,
      );
    }

    if (event is TwitterLinkInput) {
      yield state.copyWith(
        twitterLink: event.input,
        uploadRequired: true,
      );
    }

    if (event is LinkedInLinkInput) {
      yield state.copyWith(
        linkdinLink: event.input,
        uploadRequired: true,
      );
    }

    if (event is WebsiteLinkInput) {
      yield state.copyWith(
        websiteLink: event.input,
        uploadRequired: true,
      );
    }

    if (event is TnCInput) {
      yield state.copyWith(tnc: event.input);
    }

    if (event is UploadSettings) {
      yield* uploadSettingsApi(event);
    }

    if (event is SettingDataUploadResult) {
      yield state.copyWith(
        loading: false,
        uiMsg: event.uiMsg,
      );
    }
  }

  Stream<SettingState> uploadSettingsApi(UploadSettings event) async* {
    int errorCode = validateSettingsInfo();

    if (errorCode > 0) {
      yield state.copyWith(uiMsg: errorCode);
      event.callback(null);
      return;
    }

    print('uploadSettingsApi: eventDataId--->$eventDataId');

    apiProvider
        .uploadSettings(state.authToken, settingDataToUpload,
        eventDataId: eventDataId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final settingResponse =
        networkServiceResponse.response as SettingResponse;
        if (settingResponse.code == apiCodeSuccess) {
          state.uploadRequired = false;
          add(SettingDataUploadResult(true,
              uiMsg: isUpdating
                  ? SUCCESS_EVENT_UPDATED
                  : SUCCESS_EVENT_CREATED));
          event.callback(settingResponse);
        } else {
          add(SettingDataUploadResult(false,
              uiMsg: settingResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(settingResponse.message);
        }
      } else {
        add(SettingDataUploadResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in uploadSettingsApi--->$error');
      add(SettingDataUploadResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }

  int validateSettingsInfo() {
//    if (state.convenienceFee) {
//      if (!isValid(state.percentValue)) return ERR_CONV_FEE_PERCENT;
//      if (double.tryParse(state.percentValue) == 0)
//        return ERR_CONV_FEE_PERCENT_VALID;
//
//      if (!isValid(state.convenienceAmount)) return ERR_CONV_FEE_AMOUNT;
//      if (double.tryParse(state.convenienceAmount) == 0)
//        return ERR_CONV_FEE_AMOUNT_VALID;
//    }
    if (state.bookingCancellation) {
      if (!isValid(state.cancellationPolicyDesc)) return ERR_CANCELLATION_DESC;
      if (state.cancellationOptions.length == 0) return ERR_CANCELLATION_OPTION;
    }
    if (!state.tnc) return ERR_TNC;
    return 0;
  }

  SettingData get settingDataToUpload =>
      SettingData(
          status: 'ACTIVE',
          userContractCheck: state.tnc,
          paymentAndTaxes: PaymentAndTaxes(
              gstCharge: GSTCharge.defaultInstance(),
              convenienceCharge: ConvenienceCharge(
                percentValue: isValid(state.percentValue)
                    ? double.tryParse(state.percentValue)
                    : null,
                value: isValid(state.convenienceAmount)
                    ? double.tryParse(state.convenienceAmount)
                    : null,
                enable: state.convenienceFee ?? false,
                precentage: false,
              )),
          cancellationPolicy: CancellationPolicy(
            description: state.cancellationPolicyDesc,
            options: state.cancellationOptions.map(
                  (e) {
                return CancellationOption(
                    refundType: e.refundType,
                    refundValue: e.refundValue,
                    cancellationEndDate: e.cancellationEndDate?.toUtc());
              },
            )?.toList(),
          ),
          websiteSettings: WebsiteSetting(
            paymentGatewayPayPerson: state.paymentGatewayPayPerson.value,
            bookingCancellation: state.bookingCancellation,
            bookingUpgradation: false,
            transferBooking: state.transferBooking,
            remaningTickets: state.remaningTickets,
            bookButtonLabel: state.bookButtonLabel,
            facebookLink: state.facebookLink,
            linkdinLink: state.linkdinLink,
            twitterLink: state.twitterLink,
            websiteLink: state.websiteLink,
            showDateTime: true,
            showLocation: true,
            showPrice: true,
          ));
}
