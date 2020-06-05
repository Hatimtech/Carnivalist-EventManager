import 'package:eventmanagement/bloc/coupon/create/create_coupon_bloc.dart';
import 'package:eventmanagement/bloc/coupon/create/create_coupon_state.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/coupons/coupon_response.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/ui/widget/labeled_checkbox.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateCouponDialog extends StatefulWidget {
  @override
  createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCouponDialog> {
  CreateCouponBloc _createCouponBloc;

  ScrollController _scrollController;

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeQuantity = FocusNode();
  final FocusNode _focusNodeCodeAffiliateMin = FocusNode();
  final FocusNode _focusNodeDiscountValue = FocusNode();

  final FocusNode _focusNodeMaxTicketNo = FocusNode();

  final List<MenuCustom> couponTypeList = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _createCouponBloc = BlocProvider.of<CreateCouponBloc>(context);
    final _userBloc = BlocProvider.of<UserBloc>(context);
    _createCouponBloc.authTokenSave(_userBloc.state.authToken);
    _createCouponBloc.createCouponDefault();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      couponTypeList.addAll(getCouponType(context: context));
      loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context));
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildErrorReceiverEmptyBloc(),
            BlocBuilder(
              bloc: _createCouponBloc,
              condition: (prevState, newState) =>
              prevState.couponType != newState.couponType,
              builder: (_, state) {
                return Text(titleText,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.title);
              },
            ),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context).labelDiscountName,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            discountNameInput(),
            const SizedBox(height: 10.0),
            _buildAvailStartAndEndDates(),
            const SizedBox(height: 10.0),
            _buildQuantityAndCodeInput(),
            if (isGroupDiscount) const SizedBox(height: 10.0),
            if (isGroupDiscount) _buildMinAndMaxQuantityInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelCouponDiscountValue,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            _buildCouponDiscountType(),
            const SizedBox(height: 10.0),
            _buildEventSelectionInput(),
            if (isLoyaltyDiscount) const SizedBox(height: 10.0),
            if (isLoyaltyDiscount) _buildPastEventSelectionInput(),
            const SizedBox(height: 12.0),
            Row(children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnClose,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RaisedButton(
                  onPressed: _createUpdateCoupon,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnSave,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  String get titleText {
    String title = '';
    couponTypeList.forEach((menu) {
      if (_createCouponBloc.state.couponType == menu.value) title = menu.name;
    });
    return title;
  }

  bool get isCodeDiscount {
    return couponTypeList[0].value == _createCouponBloc.state.couponType;
  }

  bool get isGroupDiscount {
    return couponTypeList[1].value == _createCouponBloc.state.couponType;
  }

  bool get isLoyaltyDiscount {
    return couponTypeList[3].value == _createCouponBloc.state.couponType;
  }

  bool get isAffiliateDiscount {
    return couponTypeList[4].value == _createCouponBloc.state.couponType;
  }

  Widget _buildCouponDiscountType() {
    return BlocBuilder<CreateCouponBloc, CreateCouponState>(
      bloc: _createCouponBloc,
      condition: (prevState, newState) =>
          prevState.discountTypeList != newState.discountTypeList,
      builder: (_, state) {
        return Row(
          children: <Widget>[
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: HexColor('EEEEEE'),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: state.discountTypeList.map<Widget>((data) {
                    return Expanded(
                      child: GestureDetector(
                          onTap: () {
                            _createCouponBloc.discountTypeInput(data);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: data.isSelected
                                      ? bgColorButton
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(8),
                              child: Text(uiValueCouponDiscountType(data.value),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontSize: 12.0)))),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 96.0, maxHeight: 36.0),
              child: couponDiscountValueInput(state.discountTypeList
                      .firstWhere((menu) => menu.isSelected, orElse: () => null)
                      ?.name ??
                  ''),
            ),
          ],
        );
      },
    );
  }

  Row _buildQuantityAndCodeInput() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).labelCouponNoOfDiscounts,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              noOfDiscountInput(),
            ],
          ),
        ),
        if (isCodeDiscount || isAffiliateDiscount) const SizedBox(width: 10.0),
        if (isCodeDiscount)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(AppLocalizations.of(context).labelCouponCode,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.body2),
                const SizedBox(height: 4.0),
                couponCodeInput(),
              ],
            ),
          ),
        if (isAffiliateDiscount)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(AppLocalizations.of(context).labelCouponAffiliateEmail,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.body2),
                const SizedBox(height: 4.0),
                affiliateEmailInput(),
              ],
            ),
          ),
      ],
    );
  }

  Row _buildMinAndMaxQuantityInput() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).labelCouponMinTicketNo,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              minQuantityInput(),
            ],
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).labelCouponMaxTicketNo,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              SizedBox(height: 4.0),
              maxQuantityInput(),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildAvailStartAndEndDates() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelDiscountAvailFrom,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              _couponAvailStartDateInput(),
            ])),
        const SizedBox(width: 10.0),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelDiscountAvailTill,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              _couponAvailEndDateInput(),
            ])),
      ],
    );
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<CreateCouponBloc, CreateCouponState>(
        bloc: _createCouponBloc,
        condition: (prevState, newState) => newState.uiMsg != null,
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

  Widget _couponAvailStartDateInput() =>
      BlocBuilder<CreateCouponBloc, CreateCouponState>(
          condition: (prevState, newState) =>
              prevState.startDateTime != newState.startDateTime,
          bloc: _createCouponBloc,
          builder: (BuildContext context, state) {
            return InkWell(
              onTap: () => _pickDate(
                  DateTime.now(), _createCouponBloc.startDateTimeInput),
              child: Container(
                height: 48,
                padding: EdgeInsets.only(left: 3.0),
                decoration: boxDecorationRectangle(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.startDateTime != null
                        ? DateFormat.yMMMMd().format(state.startDateTime)
                        : AppLocalizations.of(context).inputHintDate,
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: state.startDateTime != null
                            ? null
                            : Theme.of(context).hintColor),
                  ),
                ),
              ),
            );
          });

  Widget _couponAvailEndDateInput() =>
      BlocBuilder<CreateCouponBloc, CreateCouponState>(
          condition: (prevState, newState) =>
              prevState.endDateTime != newState.endDateTime,
          bloc: _createCouponBloc,
          builder: (BuildContext context, state) {
            return InkWell(
              onTap: () =>
                  _pickDate(DateTime.now(), _createCouponBloc.endDateTimeInput),
              child: Container(
                height: 48,
                padding: EdgeInsets.only(left: 3.0),
                decoration: boxDecorationRectangle(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.endDateTime != null
                        ? DateFormat.yMMMMd().format(state.endDateTime)
                        : AppLocalizations.of(context).inputHintDate,
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: state.endDateTime != null
                            ? null
                            : Theme.of(context).hintColor),
                  ),
                ),
              ),
            );
          });

  Widget _buildEventSelectionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppLocalizations.of(context).labelCouponChooseEvent,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.body2),
        const SizedBox(height: 4.0),
        BlocBuilder<CreateCouponBloc, CreateCouponState>(
            bloc: _createCouponBloc,
            condition: (prevState, newState) {
              return prevState.selectedEvent != newState.selectedEvent;
            },
            builder: (BuildContext context, state) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => _showEventsBottomSheet(
                      true,
                      (eventData) =>
                          _createCouponBloc.selectEventInput(eventData),
                    ),
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.only(left: 3.0),
                      decoration: boxDecorationRectangle(),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isValid(state.selectedEvent?.title)
                              ? state.selectedEvent.title
                              : AppLocalizations.of(context)
                                  .inputHintSelectEvent,
                          style: Theme.of(context).textTheme.body1.copyWith(
                              color: isValid(state.selectedEvent?.title)
                                  ? null
                                  : Theme.of(context).hintColor),
                        ),
                      ),
                    ),
                  ),
                  (state.selectedEvent?.tickets?.length ?? 0) > 0
                      ? BlocBuilder<CreateCouponBloc, CreateCouponState>(
                          bloc: _createCouponBloc,
                          condition: (prevState, newState) {
                            return prevState.checkedTicket !=
                                newState.checkedTicket;
                          },
                          builder: (_, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                    AppLocalizations.of(context)
                                        .labelCouponSelectTicket,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.body2)
                              ]..addAll(
                                  state.selectedEvent.tickets.map((ticket) {
                                    return LabeledCheckbox(
                                      onChanged: (value) {
                                        if (value)
                                          _createCouponBloc
                                              .addEventTicketInput(ticket.sId);
                                        else
                                          _createCouponBloc
                                              .removeEventTicketInput(
                                                  ticket.sId);
                                      },
                                      value: state.checkedTicket
                                              ?.contains(ticket.sId) ??
                                          false,
                                      label: ticket.name,
                                    );
                                  }),
                                ),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ],
              );
            }),
        // _eventCarnivalNameInput(),
      ],
    );
  }

  Widget _buildPastEventSelectionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppLocalizations.of(context).labelCouponChoosePastEvent,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.body2),
        const SizedBox(height: 4.0),
        BlocBuilder<CreateCouponBloc, CreateCouponState>(
            bloc: _createCouponBloc,
            condition: (prevState, newState) {
              return prevState.selectedPastEvent != newState.selectedPastEvent;
            },
            builder: (BuildContext context, state) {
              return InkWell(
                onTap: () => _showEventsBottomSheet(
                  false,
                  (eventData) =>
                      _createCouponBloc.selectPastEventInput(eventData),
                ),
                child: Container(
                  height: 48,
                  padding: EdgeInsets.only(left: 3.0),
                  decoration: boxDecorationRectangle(),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isValid(state.selectedPastEvent?.title)
                          ? state.selectedPastEvent.title
                          : AppLocalizations.of(context)
                              .inputHintSelectPastEvent,
                      style: Theme.of(context).textTheme.body1.copyWith(
                          color: isValid(state.selectedPastEvent?.title)
                              ? null
                              : Theme.of(context).hintColor),
                    ),
                  ),
                ),
              );
            }),
        // _eventCarnivalNameInput(),
      ],
    );
  }

  String uiValueCouponDiscountType(String value) {
    var discountType = '';
    (getCouponDiscountType(context: context) as List<MenuCustom>)
        .forEach((menu) {
      if (menu.value == value) discountType = menu.name;
    });
    return discountType;
  }

  _createUpdateCoupon() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _createCouponBloc.uploadNewCoupon((results) {
      context.hideProgress(context);
      if (results is CouponResponse) {
        if (results.code == apiCodeSuccess) {
          Navigator.pop(context);
        }
      }
    });
  }

  Widget discountNameInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createCouponBloc.state.discountName,
        textInputAction: TextInputAction.next,
        onChanged: _createCouponBloc.discountNameInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintDiscountName,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeName,
        nextFocusNode: _focusNodeQuantity,
      );

  Widget noOfDiscountInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createCouponBloc.state.noOfDiscount,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        onChanged: _createCouponBloc.noOfDiscountInput,
        hintText: AppLocalizations.of(context).inputHintCouponNoOfDiscount,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeQuantity,
        nextFocusNode: isCodeDiscount || isAffiliateDiscount || isGroupDiscount
            ? _focusNodeCodeAffiliateMin
            : _focusNodeDiscountValue,
      );

  Widget couponCodeInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createCouponBloc.state.code,
        onChanged: _createCouponBloc.codeInput,
        textInputAction: TextInputAction.next,
        maxLength: 6,
        hintText: AppLocalizations.of(context).inputHintCouponCode,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeCodeAffiliateMin,
        nextFocusNode: _focusNodeDiscountValue,
      );

  Widget affiliateEmailInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createCouponBloc.state.affiliateEmailId,
        onChanged: _createCouponBloc.affiliateEmailInput,
        textInputAction: TextInputAction.next,
        maxLength: 50,
        hintText: AppLocalizations.of(context).inputHintAffiliateEmailId,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeCodeAffiliateMin,
        nextFocusNode: _focusNodeDiscountValue,
      );

  Widget minQuantityInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createCouponBloc.state.minQuantity,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        onChanged: _createCouponBloc.minQuantityInput,
        hintText: AppLocalizations.of(context).inputHintCouponMinTicketNo,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeCodeAffiliateMin,
        nextFocusNode: _focusNodeMaxTicketNo,
      );

  Widget maxQuantityInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createCouponBloc.state.maxQuantity,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        onChanged: _createCouponBloc.maxQuantityInput,
        hintText: AppLocalizations.of(context).inputHintCouponMaxTicketNo,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeMaxTicketNo,
        nextFocusNode: _focusNodeDiscountValue,
      );

  Widget couponDiscountValueInput(String hint) {
    return widget.inputFieldRectangle(
      null,
      initialValue: _createCouponBloc.state.discountValue,
      onChanged: _createCouponBloc.discountValueInput,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      maxLength: 6,
      hintText: hint,
      labelStyle: Theme.of(context).textTheme.body1,
      focusNode: _focusNodeDiscountValue,
    );
  }

  _pickDate(DateTime initialDate, Function dateHandler) async {
    DateTime pickedDate;

    if (isPlatformAndroid) {
      final currentDate = DateTime.now();

      pickedDate = await showDatePicker(
        context: context,
        firstDate:
            DateTime(currentDate.year, currentDate.month, currentDate.day),
        lastDate: DateTime(DateTime.now().year + 20),
        initialDate: initialDate,
      );
    } else {
      pickedDate = await _cupertinoPickDate(initialDate);
    }
    if (pickedDate != null) {
      dateHandler(pickedDate);
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<DateTime> _cupertinoPickDate(DateTime initialDate) async {
    final currentDate = DateTime.now();

    return await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          DateTime localPickedTime = initialDate;
          return SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text(AppLocalizations.of(context).btnCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoButton(
                        child: Text(AppLocalizations.of(context).btnConfirm),
                        onPressed: () {
                          Navigator.pop(context, localPickedTime);
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: initialDate,
                      onDateTimeChanged: (DateTime date) {
                        localPickedTime = date;
                      },
                      maximumDate: DateTime(DateTime.now().year + 20),
                      minimumDate: DateTime(
                          currentDate.year, currentDate.month, currentDate.day),
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  boxDecorationRectangle() => BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      );

  Future<void> _showEventsBottomSheet(
      bool showUpcoming, Function handler) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          builder: (context) {
            return _buildMaterialSelectEventSheet(showUpcoming, handler);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoSelectEventActionSheet(showUpcoming, handler),
      );
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _buildMaterialSelectEventSheet(bool showUpcoming, Function handler) {
    final eventBloc = BlocProvider.of<EventBloc>(context);
    return BlocBuilder<EventBloc, EventState>(
        condition: (prevState, newState) =>
            prevState.eventDataList != newState.eventDataList,
        bloc: eventBloc,
        builder: (context, state) {
          if (state.loading)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorProgressBar)));
          else {
            final events =
                showUpcoming ? state.upcomingEvents : state.pastEvents;
            return events.length > 0
                ? eventList(events, handler)
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 8.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context).errorCouponNoEventAvailable,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: colorTextAction,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  );
          }
        });
  }

  Widget eventList(List<EventData> eventDataList, Function handler) {
    return ListView.builder(
        itemCount: eventDataList.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          final eventData = eventDataList[position];
          return _buildEventListItem(
              eventData, handler, position != eventDataList.length - 1);
        });
  }

  Widget _buildEventListItem(EventData eventData, Function handler,
      bool showDivider) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler(eventData);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              child: Text(
                eventData.title,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle
                    .copyWith(
                  color: colorTextAction,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showDivider) const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoSelectEventActionSheet(
      bool showUpcoming, Function handler) {
    final eventBloc = BlocProvider.of<EventBloc>(context);
    return BlocBuilder<EventBloc, EventState>(
      condition: (prevState, newState) =>
          prevState.eventDataList != newState.eventDataList,
      bloc: eventBloc,
      builder: (context, state) {
        if (state.loading)
          return Container(
              alignment: FractionalOffset.center,
              child: CupertinoActivityIndicator());
        else {
          final events = showUpcoming ? state.upcomingEvents : state.pastEvents;
          return events.length > 0
              ? CupertinoActionSheet(
                  actions: events.map<Widget>((eventData) {
                    return CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                        handler(eventData);
                      },
                      child: Text(
                        eventData.title,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              color: colorTextAction,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    );
                  }).toList(),
                  cancelButton: CupertinoActionSheetAction(
                    child: Text(
                      AppLocalizations.of(context).btnCancel,
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: colorTextAction,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              : CupertinoActionSheet(
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)
                            .errorCouponNoEventAvailable,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              color: colorTextAction,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                );
        }
      },
    );
  }
}
