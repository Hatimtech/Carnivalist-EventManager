import 'package:eventmanagement/bloc/event/createticket/create_ticket_bloc.dart';
import 'package:eventmanagement/bloc/event/createticket/create_ticket_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateTicketsDialog extends StatefulWidget {
  @override
  createState() => _CreateTicketsState();
}

class _CreateTicketsState extends State<CreateTicketsDialog> {
//  final TextEditingController _ticketNameController = TextEditingController();
//  final TextEditingController _priceController = TextEditingController();
//  final TextEditingController _salesEndDateController = TextEditingController();
//  final TextEditingController _totalQuantityController =
//      TextEditingController();
//  final TextEditingController _minQuantityController = TextEditingController();
//  final TextEditingController _maxQuantityController = TextEditingController();
//  final TextEditingController _descriptionController = TextEditingController();

  CreateTicketBloc _createTicketBloc;
  UserBloc _userBloc;

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();
  final FocusNode _focusNodeTotalAva = FocusNode();
  final FocusNode _focusNodeMinBook = FocusNode();
  final FocusNode _focusNodeMaxBook = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();

  @override
  void initState() {
    super.initState();

    _createTicketBloc = BlocProvider.of<CreateTicketBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.getLoginDetails();

    _createTicketBloc.authTokenSave(_userBloc.state.authToken);

    if (!isValid(_createTicketBloc.state.ticketCurrency)) {
      final defaultCurrencyUI = _createTicketBloc.mapCurrency['USD'];
      _createTicketBloc.ticketCurrencyInput('USD', defaultCurrencyUI);
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
        child: Container(
            padding: EdgeInsets.all(10),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              BlocBuilder<CreateTicketBloc, CreateTicketState>(
                bloc: _createTicketBloc,
                condition: (prevState, newState) => newState.errorCode != null,
                builder: (context, CreateTicketState state) {
                  if (state.errorCode != null) {
                    String errorMsg = getErrorMessage(state.errorCode, context);
                    context.toast(errorMsg);
                    state.errorCode = null;
                  }

                  return SizedBox.shrink();
                },
              ),
              Text(AppLocalizations
                  .of(context)
                  .titleTicketDetails,
                  textAlign: TextAlign.left,
                  style: Theme
                      .of(context)
                      .textTheme
                      .title),
              const SizedBox(height: 20.0),
              Text(AppLocalizations
                  .of(context)
                  .labelTicketName,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2),
              const SizedBox(height: 4.0),
              ticketNameInput(),
              const SizedBox(height: 10.0),
              Text(AppLocalizations
                  .of(context)
                  .labelTicketCurrency,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2),
              const SizedBox(height: 4.0),
              ticketCurrency(),
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
                                  .labelPrice,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              SizedBox(height: 4.0),
                              ticketPriceInput(),
                            ])),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations
                                  .of(context)
                                  .labelSalesEnds,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              const SizedBox(height: 4.0),
                              saleEndDateInput(),
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
                                  .labelTotalAvailable,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              const SizedBox(height: 4.0),
                              totalAvailableInput(),
                            ])),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations
                                  .of(context)
                                  .labelMinBooking,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              const SizedBox(height: 4.0),
                              minBookingInput(),
                            ])),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations
                                  .of(context)
                                  .labelMaxBooking,
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body2),
                              const SizedBox(height: 4.0),
                              maxBookingInput(),
                            ]))
                  ]),
              const SizedBox(height: 10.0),
              Text(AppLocalizations
                  .of(context)
                  .labelDescription,
                  textAlign: TextAlign.left,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2),
              const SizedBox(height: 4.0),
              descriptionInput(),
              const SizedBox(height: 15),
              Row(children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      AppLocalizations
                          .of(context)
                          .btnClose,
                      style: Theme
                          .of(context)
                          .textTheme
                          .button,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: RaisedButton(
                    onPressed: _createTicketToApi,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      AppLocalizations
                          .of(context)
                          .btnSave,
                      style: Theme
                          .of(context)
                          .textTheme
                          .button,
                    ),
                  ),
                )
              ])
            ])));
  }

  _createTicketToApi() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _createTicketBloc.createTicket((results) {
      context.hideProgress(context);
      if (results is CreateTicketResponse) {
        var createTicketResponse = results;

        if (createTicketResponse.code == apiCodeSuccess) {
          context.toast(createTicketResponse.message);

//          _ticketNameController.clear();
//          _priceController.clear();
//          _salesEndDateController.clear();
//          _totalQuantityController.clear();
//          _minQuantityController.clear();
//          _maxQuantityController.clear();
//          _descriptionController.clear();

          Navigator.pop(context);
        } else {
          context.toast(createTicketResponse.message);
        }
      } else if (results is String) {
        context.toast(results);
      } else {
        context.toast(AppLocalizations
            .of(context)
            .errorSomethingWrong);
      }
    });
  }

  ticketNameInput() =>
      widget.inputFieldRectangle(
        null,
        initialValue: _createTicketBloc.state.ticketName,
        textInputAction: TextInputAction.next,
        onChanged: _createTicketBloc.ticketNameInput,
        maxLength: 100,
        hintText: AppLocalizations
            .of(context)
            .inputHintTicketName,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        focusNode: _focusNodeName,
        nextFocusNode: _focusNodePrice,
      );

  ticketCurrency() {
    return InkWell(
      onTap: _onTicketCurrencyButtonPressed,
      child: Container(
        height: 48,
        padding: EdgeInsets.only(left: 3.0),
        decoration: boxDecorationRectangle(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: BlocBuilder<CreateTicketBloc, CreateTicketState>(
            condition: (prevState, newState) =>
            prevState.ticketCurrencyUI != newState.ticketCurrencyUI,
            builder: (BuildContext context, state) =>
                Text(
                  isValid(state.ticketCurrencyUI)
                      ? state.ticketCurrencyUI
                      : AppLocalizations
                      .of(context)
                      .inputHintTicketCurrency,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(
                      color: isValid(state.ticketCurrencyUI)
                          ? null
                          : Theme
                          .of(context)
                          .hintColor),
                ),
            bloc: _createTicketBloc,
          ),
        ),
      ),
    );
  }

  ticketPriceInput() =>
      widget.inputFieldRectangle(
        null,
        initialValue: _createTicketBloc.state.ticketPrice,
        onChanged: _createTicketBloc.ticketPriceInput,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 6,
        hintText: AppLocalizations
            .of(context)
            .inputHintPrice,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        focusNode: _focusNodePrice,
        nextFocusNode: _focusNodeTotalAva,
      );

//  salesEndDateInput() => BlocBuilder(
//      bloc: _createTicketBloc,
//      builder: (BuildContext context, CreateTicketState state) =>
//          widget.inputFieldRectangle(
//            _salesEndDateController,
//            onChanged: _createTicketBloc.salesEndDateInput,
//            validation: validateSalesEndDate,
//            hintText: AppLocalizations.of(context).inputHintSalesEndDate,
//            labelStyle: Theme.of(context).textTheme.body1,
//          ));

  saleEndDateInput() =>
      BlocBuilder<CreateTicketBloc, CreateTicketState>(
          condition: (prevState, newState) =>
          prevState.salesEndDate != newState.salesEndDate,
      bloc: _createTicketBloc,
          builder: (BuildContext context, CreateTicketState state) {
            return InkWell(
              onTap: () =>
                  _pickDate(
                      DateTime.now(), _createTicketBloc.salesEndDateInput),
              child: Container(
                height: 48,
                padding: EdgeInsets.only(left: 3.0),
                decoration: boxDecorationRectangle(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.salesEndDate != null
                        ? DateFormat.yMMMMd().format(state.salesEndDate)
                        : AppLocalizations
                        .of(context)
                        .inputHintDate,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1
                        .copyWith(
                        color: state.salesEndDate != null
                            ? null
                            : Theme
                            .of(context)
                            .hintColor),
                  ),
                ),
              ),
            );
          });

  totalAvailableInput() =>
      widget.inputFieldRectangle(
        null,
        initialValue: _createTicketBloc.state.totalAvailable,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        onChanged: _createTicketBloc.totalAvailableInput,
        hintText: AppLocalizations
            .of(context)
            .inputHintQuantity,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        focusNode: _focusNodeTotalAva,
        nextFocusNode: _focusNodeMinBook,
      );

  minBookingInput() =>
      widget.inputFieldRectangle(
        null,
        initialValue: _createTicketBloc.state.minBooking,
        onChanged: _createTicketBloc.minBookingInput,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        hintText: AppLocalizations
            .of(context)
            .inputHintQuantity,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        focusNode: _focusNodeMinBook,
        nextFocusNode: _focusNodeMaxBook,
      );

  maxBookingInput() =>
      widget.inputFieldRectangle(
        null,
        initialValue: _createTicketBloc.state.maxBooking,
        onChanged: _createTicketBloc.maxBookingInput,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        hintText: AppLocalizations
            .of(context)
            .inputHintQuantity,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        focusNode: _focusNodeMaxBook,
        nextFocusNode: _focusNodeDescription,
      );

  descriptionInput() =>
      widget.inputFieldRectangle(
        null,
        initialValue: _createTicketBloc.state.description,
        onChanged: _createTicketBloc.descriptionInput,
        hintText: AppLocalizations
            .of(context)
            .inputHintDescription,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        maxLines: 5,
        maxLength: 500,
        focusNode: _focusNodeDescription,
      );

  _pickDate(DateTime initialDate, Function dateHandler) async {
    DateTime pickedDate;

    if (isPlatformAndroid) {
      final currentDate = DateTime.now();

      pickedDate = await showDatePicker(
        context: context,
        firstDate:
        DateTime(currentDate.year, currentDate.month, currentDate.day),
        lastDate: DateTime(DateTime
            .now()
            .year + 20),
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
                      initialDateTime: initialDate,
                      onDateTimeChanged: (DateTime date) {
                        localPickedTime = date;
                      },
                      maximumDate: DateTime(DateTime
                          .now()
                          .year + 20),
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

  boxDecorationRectangle() =>
      BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
        ),
      );

  Future<void> _onTicketCurrencyButtonPressed() async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _ticketCurrencyList();
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoTicketCurrencyActionSheet(),
      );
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _ticketCurrencyList() {
    final currencies = _createTicketBloc.mapCurrency.entries.toList();
    return ListView.builder(
        itemCount: _createTicketBloc.mapCurrency.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return InkWell(
              onTap: () {
                Navigator.pop(context);
                _createTicketBloc.ticketCurrencyInput(
                    currencies[position].key, currencies[position].value);
                print(currencies[position].key);
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
                      currencies[position].value,
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
                  const Divider(),
                ],
              ));
        });
  }

  Widget _buildCupertinoTicketCurrencyActionSheet() {
    final currencies = _createTicketBloc.mapCurrency.entries.toList();
    return CupertinoActionSheet(
      actions: currencies.map<Widget>((ticketCurrencyMapEntry) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _createTicketBloc.ticketCurrencyInput(
                ticketCurrencyMapEntry.key, ticketCurrencyMapEntry.value);
            print(ticketCurrencyMapEntry.key);
          },
          child: Text(
            ticketCurrencyMapEntry.value,
            style: Theme
                .of(context)
                .textTheme
                .subtitle
                .copyWith(
              color: colorTextAction,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          AppLocalizations
              .of(context)
              .btnCancel,
          style: Theme
              .of(context)
              .textTheme
              .title
              .copyWith(
            color: colorTextAction,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
