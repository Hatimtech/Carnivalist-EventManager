import 'package:eventmanagement/bloc/event/setting/setting_bloc.dart';
import 'package:eventmanagement/bloc/event/setting/setting_state.dart';
import 'package:eventmanagement/ui/cliper/bubble_indication_painter.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';
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
    return Scaffold(
        backgroundColor: HexColor(bgColor),
        bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(children: <Widget>[
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: HexColor('#8c3ee9'),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(btnCancel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)))),
              SizedBox(width: 15),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: HexColor('#8c3ee9'),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(btnNext,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400))))
            ])),
        body: ListView(shrinkWrap: true, padding: EdgeInsets.all(0), children: <
            Widget>[
          Card(
              color: Theme.of(context).cardColor,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(7.0), top: Radius.circular(7.0))),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(titlePaymentAndFees,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 7.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(labelConvenienceFee,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 16, color: Colors.grey))),
                              SizedBox(width: 10.0),
                              Switch(
                                  value: ConvenienceFeesValue,
                                  onChanged: (newVal) {
                                    onSwitchConvenienceFeeValueChanged(newVal);
                                  })
                            ]),
                        SizedBox(height: 3.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(labelPercentageValue,
                                        textAlign: TextAlign.left,
                                        style: (TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: montserratBoldFont))),
                                    SizedBox(height: 4.0),
                                    widget.inputFieldRectangle(
                                        _percentageValueController,
                                        hintText: inputHintAmount)
                                  ])),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(labelAmountValue,
                                        textAlign: TextAlign.left,
                                        style: (TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: montserratBoldFont))),
                                    SizedBox(height: 4.0),
                                    widget.inputFieldRectangle(
                                        _ticketNameController,
                                        hintText: inputHintPercentage)
                                  ]))
                            ]),
                        SizedBox(height: 7.0),
                        Text(labelPaymentGatewayCharge,
                            textAlign: TextAlign.left,
                            style:
                                (TextStyle(fontSize: 14, color: Colors.grey))),
                        SizedBox(height: 5),
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
                                                          color: state.paymentTypeName ==
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
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  12.0)))));
                                        }).toList()))))
                      ]))),
          SizedBox(height: 10),
          Card(
              color: Theme.of(context).cardColor,
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
                        Text(titleCustomSettings,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 7.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(labelBookingCancel,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 15, color: Colors.grey))),
                              SizedBox(width: 10.0),
                              Switch(
                                  value: BookingCancelValue,
                                  onChanged: (newVal) {
                                    onSwitchBookingCancelationChanged(newVal);
                                  })
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(labelTicketResale,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 15, color: Colors.grey))),
                              SizedBox(width: 10.0),
                              Switch(
                                  value: TicketResaleValue,
                                  onChanged: (newVal) {
                                    onSwitchTicketResaleChanged(newVal);
                                  })
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(labelRemainingTickets,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 15, color: Colors.grey))),
                              SizedBox(width: 10.0),
                              Switch(
                                  value: RemainingTicketValue,
                                  onChanged: (newVal) {
                                    onSwitchRemainingTicketsChanged(newVal);
                                  })
                            ])
                      ]))),
          SizedBox(height: 10),
          Card(
              color: Theme.of(context).cardColor,
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
                        Text(titleCustomLabels,
                            textAlign: TextAlign.left,
                            style: (TextStyle(
                                fontSize: 18,
                                color: colorSubHeader,
                                fontWeight: FontWeight.bold,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 12.0),
                        Text(labelRegistrationButton,
                            style: (TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontFamily: montserratBoldFont))),
                        SizedBox(height: 4.0),
                        widget.inputFieldRectangle(_registrationController,
                            hintText: inputHintBookNow),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(labelFacebookLink,
                                        textAlign: TextAlign.left,
                                        style: (TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: montserratBoldFont))),
                                    SizedBox(height: 4.0),
                                    widget.inputFieldRectangle(
                                        _facebookLinkController,
                                        hintText: inputHintFacebookLink)
                                  ])),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(labelTwitterLink,
                                        textAlign: TextAlign.left,
                                        style: (TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: montserratBoldFont))),
                                    SizedBox(height: 4.0),
                                    widget.inputFieldRectangle(
                                        _twitterLinkController,
                                        hintText: inputHintTwitterLink)
                                  ]))
                            ]),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(labelLinkedInLink,
                                        textAlign: TextAlign.left,
                                        style: (TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: montserratBoldFont))),
                                    SizedBox(height: 4.0),
                                    widget.inputFieldRectangle(
                                        _linkedInLinkController,
                                        hintText: inputHintLinkedInLink)
                                  ])),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(labelWebsiteLink,
                                        textAlign: TextAlign.left,
                                        style: (TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: montserratBoldFont))),
                                    SizedBox(height: 4.0),
                                    widget.inputFieldRectangle(
                                        _websiteLinkController,
                                        hintText: inputHintWebsiteLink)
                                  ]))
                            ]),
                        SizedBox(height: 5)
                      ])))
        ]));
  }
}
