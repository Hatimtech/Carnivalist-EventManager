import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/setting/setting_bloc.dart';
import 'package:eventmanagement/bloc/event/setting/setting_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/settings/cancellation_option.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  SettingBloc _settingBloc;
  BasicBloc _basicBloc;

  ScrollController _scrollController;

  final FocusNode _focusNodePercentage = FocusNode();
  final FocusNode _focusNodeAmount = FocusNode();
  final FocusNode _focusNodeRegistration = FocusNode();
  final FocusNode _focusNodeFB = FocusNode();
  final FocusNode _focusNodeTwitter = FocusNode();
  final FocusNode _focusNodeLinkedin = FocusNode();
  final FocusNode _focusNodeWebsite = FocusNode();

  @override
  void initState() {
    super.initState();
    _settingBloc = BlocProvider.of<SettingBloc>(context);
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    if (!isPlatformAndroid) {
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScrollbar(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildErrorCodeHandleView(),
              _buildPaymentAndFeesCard(),
              _buildCustomSettingCard(context),
              _buildCustomLabelCard(context),
              _buildTnCCard(context),
            ]),
      ),
    );
  }

  Widget _buildErrorCodeHandleView() =>
      BlocBuilder<SettingBloc, SettingState>(
        cubit: _settingBloc,
        buildWhen: (prevState, newState) => newState.uiMsg != null,
        builder: (context, state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            context.toast(errorMsg);

            state.uiMsg = null;
          }

          return SizedBox.shrink();
        },
      );

  Card _buildPaymentAndFeesCard() {
    return Card(
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
                const SizedBox(height: 16.0),
                /*BlocBuilder<SettingBloc, SettingState>(
                    cubit: _settingBloc,
                    buildWhen: (prevState, newState) {
                      return prevState.convenienceFee !=
                          newState.convenienceFee;
                    },
                    builder: (BuildContext context, SettingState state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                      .body1,
                                ),
                                const SizedBox(width: 10.0),
                                Switch.adaptive(
                                  value: state.convenienceFee,
                                  onChanged: _settingBloc.convenienceFeeInput,
                                )
                              ]),
                          const SizedBox(height: 3.0),
                          if (state.convenienceFee ?? false)
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
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .body2),
                                            const SizedBox(height: 4.0),
                                            widget.inputFieldRectangle(
                                              null,
                                              hintText: AppLocalizations
                                                  .of(context)
                                                  .inputHintPercentage,
                                              labelStyle:
                                              Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1,
                                              initialValue:
                                              _settingBloc.state.percentValue,
                                              onChanged: _settingBloc
                                                  .conveniencePercentInput,
                                              textInputAction: TextInputAction
                                                  .next,
                                              keyboardType: TextInputType
                                                  .number,
                                              maxLength: 5,
                                              focusNode: _focusNodePercentage,
                                              nextFocusNode: _focusNodeAmount,
                                            )
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
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .body2),
                                            const SizedBox(height: 4.0),
                                            widget.inputFieldRectangle(
                                              null,
                                              hintText: AppLocalizations
                                                  .of(context)
                                                  .inputHintAmount,
                                              labelStyle:
                                              Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1,
                                              initialValue: _settingBloc
                                                  .state.convenienceAmount,
                                              keyboardType: TextInputType
                                                  .number,
                                              maxLength: 7,
                                              onChanged: _settingBloc
                                                  .convenienceAmountInput,
                                              focusNode: _focusNodeAmount,
                                            )
                                          ]))
                                ]),
                          if (state.convenienceFee ?? false)
                            const SizedBox(height: 18.0),
                        ],
                      );
                    }),*/
                Text(AppLocalizations
                    .of(context)
                    .labelPaymentGatewayCharge,
                    textAlign: TextAlign.left,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1),
                const SizedBox(height: 5),
                Container(
                    child: BlocBuilder<SettingBloc, SettingState>(
                        cubit: _settingBloc,
                        buildWhen: (prevState, newState) {
                          return prevState.paymentGatewayPayPerson?.name !=
                              newState.paymentGatewayPayPerson?.name;
                        },
                        builder: (context, SettingState state) {
                          return Container(
                              width: 150,
                              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: HexColor('#EEEEEF'),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: Row(
                                  children: state.paymentTypeList.map((data) {
                                    return Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              _settingBloc
                                                  .selectPaymentGatewayBy(data);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                    state
                                                        .paymentGatewayPayPerson
                                                        ?.value ==
                                                        data?.value
                                                        ? HexColor('#8c3ee9')
                                                        : Colors.transparent,
                                                    borderRadius:
                                                    BorderRadius.circular(5)),
                                                padding: EdgeInsets.all(8),
                                                child: Text(data.name,
                                                    textAlign: TextAlign.center,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .body1
                                                        .copyWith(
                                                        fontSize: 12.0)))));
                                  }).toList()));
                        }))
              ],
            )));
  }

  Card _buildCustomSettingCard(BuildContext context) {
    return Card(
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
                  BlocBuilder<SettingBloc, SettingState>(
                    cubit: _settingBloc,
                    buildWhen: (prevState, newState) {
                      return prevState.bookingCancellation !=
                          newState.bookingCancellation;
                    },
                    builder: (BuildContext context, SettingState state) {
                      return Column(
                        children: <Widget>[
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
                                Switch.adaptive(
                                  value: state.bookingCancellation,
                                  onChanged:
                                  _settingBloc.bookingCancellationInput,
                                ),
                              ]),
                          if (state.bookingCancellation)
                            _buildCancellationPolicyCard(),
                        ],
                      );
                    },
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .labelTicketResale,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body1),
                        const SizedBox(width: 10.0),
                        BlocBuilder<SettingBloc, SettingState>(
                          cubit: _settingBloc,
                          buildWhen: (prevState, newState) {
                            return prevState.transferBooking !=
                                newState.transferBooking;
                          },
                          builder: (BuildContext context, SettingState state) {
                            return Switch.adaptive(
                              value: state.transferBooking,
                              onChanged: _settingBloc.bookingTransferInput,
                            );
                          },
                        )
                      ]),
                  /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppLocalizations
                            .of(context)
                            .labelRemainingTickets,
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body1),
                        const SizedBox(width: 10.0),
                        BlocBuilder<SettingBloc, SettingState>(
                          cubit: _settingBloc,
                          buildWhen: (prevState, newState) {
                            return prevState.remaningTickets !=
                                newState.remaningTickets;
                          },
                          builder: (BuildContext context, SettingState state) {
                            return Switch.adaptive(
                                value: state.remaningTickets,
                                onChanged: _settingBloc.remainingTicketsInput);
                          },
                        )
                      ])*/
                ])));
  }

  Card _buildCustomLabelCard(BuildContext context) {
    return Card(
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
                const SizedBox(height: 16.0),
                Text(AppLocalizations
                    .of(context)
                    .labelRegistrationButton,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body2),
                const SizedBox(height: 4.0),
                widget.inputFieldRectangle(
                  null,
                  hintText: AppLocalizations
                      .of(context)
                      .inputHintBookNow,
                  labelStyle: Theme
                      .of(context)
                      .textTheme
                      .body1,
                  initialValue: _settingBloc.state.bookButtonLabel,
                  onChanged: _settingBloc.registrationLabelInput,
                  textInputAction: TextInputAction.next,
                  maxLength: 50,
                  focusNode: _focusNodeRegistration,
                  nextFocusNode: _focusNodeFB,
                ),
                const SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(AppLocalizations
                                    .of(context)
                                    .labelFacebookLink,
                                    textAlign: TextAlign.left,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .body2),
                                const SizedBox(height: 4.0),
                                widget.inputFieldRectangle(
                                  null,
                                  hintText: AppLocalizations
                                      .of(context)
                                      .inputHintFacebookLink,
                                  labelStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .body1,
                                  initialValue: _settingBloc.state.twitterLink,
                                  onChanged: _settingBloc.facebookLinkInput,
                                  textInputAction: TextInputAction.next,
                                  maxLength: 100,
                                  focusNode: _focusNodeFB,
                                  nextFocusNode: _focusNodeTwitter,
                                )
                              ])),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(AppLocalizations
                                    .of(context)
                                    .labelTwitterLink,
                                    textAlign: TextAlign.left,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .body2),
                                const SizedBox(height: 4.0),
                                widget.inputFieldRectangle(
                                  null,
                                  hintText: AppLocalizations
                                      .of(context)
                                      .inputHintTwitterLink,
                                  labelStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .body1,
                                  initialValue: _settingBloc.state.twitterLink,
                                  onChanged: _settingBloc.twitterLinkInput,
                                  textInputAction: TextInputAction.next,
                                  maxLength: 100,
                                  focusNode: _focusNodeTwitter,
                                  nextFocusNode: _focusNodeLinkedin,
                                )
                              ]))
                    ]),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations
                                  .of(context)
                                  .labelLinkedInLink,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              const SizedBox(height: 4.0),
                              widget.inputFieldRectangle(
                                null,
                                hintText: AppLocalizations
                                    .of(context)
                                    .inputHintLinkedInLink,
                                labelStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .body1,
                                initialValue: _settingBloc.state.linkdinLink,
                                onChanged: _settingBloc.linkedInLinkInput,
                                textInputAction: TextInputAction.next,
                                maxLength: 100,
                                focusNode: _focusNodeLinkedin,
                                nextFocusNode: _focusNodeWebsite,
                              )
                            ])),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations
                                  .of(context)
                                  .labelWebsiteLink,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              const SizedBox(height: 4.0),
                              widget.inputFieldRectangle(
                                null,
                                hintText: AppLocalizations
                                    .of(context)
                                    .inputHintWebsiteLink,
                                labelStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .body1,
                                initialValue: _settingBloc.state.websiteLink,
                                maxLength: 100,
                                onChanged: _settingBloc.websiteLinkInput,
                                focusNode: _focusNodeWebsite,
                              )
                            ]))
                  ],
                ),
                const SizedBox(height: 5),
              ],
            )));
  }

  Card _buildTnCCard(BuildContext context) {
    return Card(
        color: Theme
            .of(context)
            .cardColor,
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: BlocBuilder(
              cubit: _settingBloc,
              buildWhen: (prevState, newState) {
                return prevState.tnc != newState.tnc;
              },
              builder: (BuildContext context, state) {
                return CheckboxListTile(
                  title: _buildTncRichTextWithLinks(),
                  value: state.tnc,
                  onChanged: _settingBloc.tncInput,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            )));
  }

  Card _buildCancellationPolicyCard() {
    return Card(
        color: Theme
            .of(context)
            .cardColor,
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
        ),
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations
                      .of(context)
                      .subtitleCancellationPolicy,
                  textAlign: TextAlign.left,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                _cancellationPolicyDescriptionInput(),
                BlocBuilder<SettingBloc, SettingState>(
                    cubit: _settingBloc,
                    buildWhen: (prevState, newState) {
                      return prevState.cancellationOptions !=
                          newState.cancellationOptions;
                    },
                    builder: (BuildContext context, SettingState state) {
                      final currentOptionsLength =
                          state.cancellationOptions.length;
                      return Column(
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.cancellationOptions.length,
                              itemBuilder: (_, pos) {
                                return _buildCancellationOptionView(
                                    state.cancellationOptions[pos],
                                    pos,
                                    currentOptionsLength);
                              }),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              onPressed: () =>
                                  _settingBloc.addCancellationPolicyOption(),
                              color: Colors.amber,
                              child: Text(
                                AppLocalizations
                                    .of(context)
                                    .btnAddCancellationOption,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .button,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            )));
  }

  /*Widget _cancellationPolicyDescriptionInput(){
    return widget.inputFieldRectangle(
      null,
      hintText:
      AppLocalizations.of(context).inputHintCancellationDesc,
      labelStyle: Theme.of(context).textTheme.body1,
      initialValue: _settingBloc.state.cancellationPolicyDesc,
      onChanged: _settingBloc.bookingCancellationDescInput,
      maxLines: 2,
      maxLength: 500,
    );
  }*/

  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();

  Widget _cancellationPolicyDescriptionInput() {
    return InkWell(
      onTap: () =>
          widget.showHtmlEditorDialog(
              context,
              keyEditor,
              _settingBloc.state.cancellationPolicyDesc,
              AppLocalizations
                  .of(context)
                  .inputHintCancellationDesc,
              _settingBloc.bookingCancellationDescInput),
      child: BlocBuilder<SettingBloc, SettingState>(
        cubit: _settingBloc,
        buildWhen: (prevState, newState) {
          return prevState.cancellationPolicyDesc !=
              newState.cancellationPolicyDesc;
        },
        builder: (_, state) =>
            widget.hintedWebview(
                context,
                state.cancellationPolicyDesc,
                AppLocalizations
                    .of(context)
                    .inputHintCancellationDesc),
      ),
    );
  }

  Widget _buildCancellationOptionView(CancellationOption cancellationOption,
      int index, int currentOptionsLength) {
    return BlocBuilder<SettingBloc, SettingState>(
      key: ValueKey(cancellationOption.hashCode),
      cubit: _settingBloc,
      buildWhen: (prevState, newState) {
        return newState.cancellationOptions.length == currentOptionsLength &&
            (prevState.cancellationOptions[index].refundType !=
                newState.cancellationOptions[index].refundType);
      },
      builder: (BuildContext context, state) {
        final cancellationOption = state.cancellationOptions[index];
        return Column(
          children: <Widget>[
            const SizedBox(height: 8.0),
            const Divider(),
            _buildCancellationDeductionTypeView(cancellationOption, index),
            const SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              _buildCancellationAmountDeductionView(
                  cancellationOption, index, currentOptionsLength),
              const SizedBox(width: 10.0),
              _buildCancellationEndDateView(
                  cancellationOption, index, currentOptionsLength),
            ]),
          ],
        );
      },
    );
  }

  Widget _buildCancellationDeductionTypeView(
      CancellationOption cancellationOption, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            cancellationOption.refundType == 'amount'
                ? AppLocalizations
                .of(context)
                .labelCancellationDeductAmount
                : AppLocalizations
                .of(context)
                .labelCancellationDeductPercentage,
            textAlign: TextAlign.left,
            style: Theme
                .of(context)
                .textTheme
                .body1,
          ),
        ),
        Switch.adaptive(
          value: cancellationOption.refundType == 'amount' ? false : true,
          onChanged: (val) {
            _settingBloc.cancellationPolicyDeductionType(index, val);
          },
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(50), shape: BoxShape.circle),
          child: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _settingBloc.removeCancellationPolicyOption(index);
              }),
        ),
      ],
    );
  }

  Widget _buildCancellationAmountDeductionView(
      CancellationOption cancellationOption,
      int index,
      int currentOptionsLength) {
    var refundValue = _settingBloc.state.cancellationOptions[index].refundValue;
    return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  cancellationOption.refundType == 'amount'
                      ? AppLocalizations
                      .of(context)
                      .labelCancellationDeductAmountInput
                      : AppLocalizations
                      .of(context)
                      .labelCancellationDeductPercentageInput,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2),
              const SizedBox(height: 4.0),
              widget.inputFieldRectangle(
                null,
                initialValue: refundValue != null && refundValue > 0
                    ? refundValue.toString()
                    : '',
                onChanged: (value) =>
                    _settingBloc.cancellationPolicyDeductionInput(index, value),
                hintText: AppLocalizations
                    .of(context)
                    .zeroInputHint,
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .body1,
                keyboardType: TextInputType.number,
//                      focusNode: _focusNodeState,
//                      nextFocusNode: _focusNodeCity,
              ),
            ]));
  }

  Widget _buildCancellationEndDateView(CancellationOption cancellationOption,
      int index, int currentOptionsLength) {
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(AppLocalizations
                .of(context)
                .labelCancellationEndDate,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: Theme
                    .of(context)
                    .textTheme
                    .body2),
            const SizedBox(height: 4.0),
            InkWell(
              onTap: () =>
                  _pickDate(null,
                          (date) =>
                          _settingBloc.cancellationPolicyEndDate(index, date)),
              child: Container(
                height: 48,
                padding: EdgeInsets.only(left: 3.0),
                decoration: boxDecorationRectangle(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<SettingBloc, SettingState>(
                    buildWhen: (prevState, newState) {
                      return newState.cancellationOptions.length ==
                          currentOptionsLength &&
                          prevState
                              .cancellationOptions[index].cancellationEndDate !=
                              newState
                                  .cancellationOptions[index]
                                  .cancellationEndDate;
                    },
                    builder: (BuildContext context, state) {
                      return Text(
                        state.cancellationOptions[index].cancellationEndDate !=
                            null
                            ? DateFormat.yMMMd().format(state
                            .cancellationOptions[index].cancellationEndDate)
                            : AppLocalizations
                            .of(context)
                            .labelCancellationEndDateInput,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(
                            color: state.cancellationOptions[index]
                                .cancellationEndDate !=
                                null
                                ? null
                                : Theme
                                .of(context)
                                .hintColor),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  boxDecorationRectangle() =>
      BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
        ),
      );

  _pickDate(DateTime initialDate, Function dateHandler) async {
    DateTime pickedDate;

    if (isPlatformAndroid) {
      final currentTime = DateTime.now();
      final eventStartTime = _basicBloc.startDateTime;
      final eventEndTime = _basicBloc.endDateTime;
      pickedDate = await showDatePicker(
        context: context,
        firstDate:
        currentTime.isBefore(eventStartTime) ? currentTime : eventStartTime,
        lastDate: eventEndTime,
        initialDate: eventStartTime,
      );

//      TimeOfDay pickedTime = await showTimePicker(
//        context: context,
//        initialTime:
//            TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
//      );

      pickedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          23,
          59,
          59,
          999);
    } else {
      pickedDate = await _cupertinoPickDate(initialDate);
    }
    if (pickedDate != null) {
      dateHandler(pickedDate);
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<DateTime> _cupertinoPickDate(DateTime initialDate) async {
    return await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          final eventStartTime = _basicBloc.startDateTime;
          final eventEndTime = _basicBloc.endDateTime;
          DateTime localPickedTime = eventStartTime;
          final currentTime = DateTime.now();
          return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text(AppLocalizations
                            .of(context)
                            .btnCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoButton(
                        child: Text(AppLocalizations
                            .of(context)
                            .btnConfirm),
                        onPressed: () {
                          Navigator.pop(context, localPickedTime);
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      onDateTimeChanged: (DateTime date) {
                        localPickedTime = date;
                      },
                      initialDateTime: eventStartTime,
                      maximumDate: eventEndTime,
                      minimumDate: currentTime.isBefore(eventStartTime)
                          ? currentTime
                          : eventStartTime,
                      mode: CupertinoDatePickerMode.dateAndTime,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTncRichTextWithLinks() {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'I accept the ',
            style: Theme
                .of(context)
                .textTheme
                .body1,
          ),
          TextSpan(
              text: 'Terms of Use',
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(
                  color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchURL('https://google.com/')),
          TextSpan(
            text: ' and ',
            style: Theme
                .of(context)
                .textTheme
                .body1,
          ),
          TextSpan(
              text: 'Privacy Policy.',
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(
                  color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchURL('https://google.com/')),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
