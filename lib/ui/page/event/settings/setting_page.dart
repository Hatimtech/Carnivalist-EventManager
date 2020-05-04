import 'package:eventmanagement/bloc/event/setting/setting_bloc.dart';
import 'package:eventmanagement/bloc/event/setting/setting_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  @override
  createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  bool ConvenienceFeesValue = true;
  bool BookingCancelValue = true;
  bool TicketResaleValue = true;
  bool RemainingTicketValue = true;

  SettingBloc _settingBloc;

  final TextEditingController _percentageValueController =
  TextEditingController();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _twitterLinkController = TextEditingController();
  final TextEditingController _linkedInLinkController = TextEditingController();
  final TextEditingController _websiteLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _settingBloc = BlocProvider.of<SettingBloc>(context);
    _settingBloc.paymentType();
    _settingBloc.selectPaymentTypeName('Me');
  }

  onSwitchConvenienceFeeValueChanged(bool newVal) {
    setState(() {
      ConvenienceFeesValue = newVal;
    });
  }

  onSwitchBookingCancelationChanged(bool newVal) {
    setState(() {
      BookingCancelValue = newVal;
    });
  }

  onSwitchTicketResaleChanged(bool newVal) {
    setState(() {
      TicketResaleValue = newVal;
    });
  }

  onSwitchRemainingTicketsChanged(bool newVal) {
    setState(() {
      RemainingTicketValue = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScrollbar(
      child: ListView(
          shrinkWrap: true, padding: EdgeInsets.all(0), children: <Widget>[
        Card(
            color: Theme
                .of(context)
                .cardColor,
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7.0), top: Radius.circular(7.0))),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations
                          .of(context)
                          .titlePaymentAndFees,
                          textAlign: TextAlign.left,
                          style: Theme
                              .of(context)
                              .textTheme
                              .title),
                      const SizedBox(height: 7.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                AppLocalizations
                                    .of(context)
                                    .labelConvenienceFee,
                                textAlign: TextAlign.left,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1),
                            const SizedBox(width: 10.0),
                            Switch(
                                value: ConvenienceFeesValue,
                                onChanged: (newVal) {
                                  onSwitchConvenienceFeeValueChanged(newVal);
                                })
                          ]),
                      const SizedBox(height: 3.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelPercentageValue,
                                          textAlign: TextAlign.left,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      widget.inputFieldRectangle(
                                          _percentageValueController,
                                          hintText: AppLocalizations
                                              .of(context)
                                              .inputHintAmount,
                                          labelStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body1)
                                    ])),
                            const SizedBox(width: 10.0),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelAmountValue,
                                          textAlign: TextAlign.left,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      widget.inputFieldRectangle(
                                          _ticketNameController,
                                          hintText: AppLocalizations
                                              .of(context)
                                              .inputHintPercentage,
                                          labelStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body1)
                                    ]))
                          ]),
                      const SizedBox(height: 7.0),
                      Text(
                          AppLocalizations
                              .of(context)
                              .labelPaymentGatewayCharge,
                          textAlign: TextAlign.left,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1),
                      const SizedBox(height: 5),
                      Container(
                          child: BlocBuilder(
                              bloc: _settingBloc,
                              builder: (context, SettingState state) =>
                                  Container(
                                      width: 150,
                                      margin: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          color: HexColor('#EEEEEF'),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Row(
                                          children: state.paymentTypeList
                                              .map((data) {
                                            return Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      _settingBloc
                                                          .selectPaymentTypeName(
                                                          data.name);
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: state
                                                                .paymentTypeName ==
                                                                data.name
                                                                ? HexColor(
                                                                '#8c3ee9')
                                                                : Colors
                                                                .transparent,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                        padding:
                                                        EdgeInsets.all(8),
                                                        child: Text(data.name,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .body1
                                                                .copyWith(
                                                                fontSize: 12.0)))));
                                          }).toList()))))
                    ]))),
        const SizedBox(height: 10),
        Card(
            color: Theme
                .of(context)
                .cardColor,
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations
                          .of(context)
                          .titleCustomSettings,
                          textAlign: TextAlign.left,
                          style: Theme
                              .of(context)
                              .textTheme
                              .title),
                      const SizedBox(height: 7.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                AppLocalizations
                                    .of(context)
                                    .labelBookingCancel,
                                textAlign: TextAlign.left,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1),
                            const SizedBox(width: 10.0),
                            Switch(
                                value: BookingCancelValue,
                                onChanged: (newVal) {
                                  onSwitchBookingCancelationChanged(newVal);
                                })
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                AppLocalizations
                                    .of(context)
                                    .labelTicketResale,
                                textAlign: TextAlign.left,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1),
                            const SizedBox(width: 10.0),
                            Switch(
                                value: TicketResaleValue,
                                onChanged: (newVal) {
                                  onSwitchTicketResaleChanged(newVal);
                                })
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                AppLocalizations
                                    .of(context)
                                    .labelRemainingTickets,
                                textAlign: TextAlign.left,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1),
                            const SizedBox(width: 10.0),
                            Switch(
                                value: RemainingTicketValue,
                                onChanged: (newVal) {
                                  onSwitchRemainingTicketsChanged(newVal);
                                })
                          ])
                    ]))),
        const SizedBox(height: 10),
        Card(
            color: Theme
                .of(context)
                .cardColor,
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations
                          .of(context)
                          .titleCustomLabels,
                          textAlign: TextAlign.left,
                          style: Theme
                              .of(context)
                              .textTheme
                              .title),
                      const SizedBox(height: 12.0),
                      Text(
                          AppLocalizations
                              .of(context)
                              .labelRegistrationButton,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body2),
                      const SizedBox(height: 4.0),
                      widget.inputFieldRectangle(_registrationController,
                          hintText:
                          AppLocalizations
                              .of(context)
                              .inputHintBookNow,
                          labelStyle: Theme
                              .of(context)
                              .textTheme
                              .body1),
                      const SizedBox(height: 10.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelFacebookLink,
                                          textAlign: TextAlign.left,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      widget.inputFieldRectangle(
                                          _facebookLinkController,
                                          hintText: AppLocalizations
                                              .of(context)
                                              .inputHintFacebookLink,
                                          labelStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body1)
                                    ])),
                            const SizedBox(width: 10.0),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelTwitterLink,
                                          textAlign: TextAlign.left,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      widget.inputFieldRectangle(
                                          _twitterLinkController,
                                          hintText: AppLocalizations
                                              .of(context)
                                              .inputHintTwitterLink,
                                          labelStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body1)
                                    ]))
                          ]),
                      const SizedBox(height: 10.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelLinkedInLink,
                                          textAlign: TextAlign.left,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      widget.inputFieldRectangle(
                                          _linkedInLinkController,
                                          hintText: AppLocalizations
                                              .of(context)
                                              .inputHintLinkedInLink,
                                          labelStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body1)
                                    ])),
                            const SizedBox(width: 10.0),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelWebsiteLink,
                                          textAlign: TextAlign.left,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      widget.inputFieldRectangle(
                                          _websiteLinkController,
                                          hintText: AppLocalizations
                                              .of(context)
                                              .inputHintWebsiteLink,
                                          labelStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body1)
                                    ]))
                          ]),
                      const SizedBox(height: 5)
                    ])))
      ]),
    );
  }
}
