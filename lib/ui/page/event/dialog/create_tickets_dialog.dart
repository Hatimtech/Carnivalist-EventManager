import 'package:eventmanagement/bloc/event/createticket/create_ticket_bloc.dart';
import 'package:eventmanagement/bloc/event/createticket/create_ticket_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTicketsDialog extends StatefulWidget {
  @override
  createState() => _CreateTicketsState();
}

class _CreateTicketsState extends State<CreateTicketsDialog> {
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salesEndDateController = TextEditingController();
  final TextEditingController _totalQuantityController =
      TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _maxQuantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;
  CreateTicketBloc _createTicketBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _createTicketBloc = BlocProvider.of<CreateTicketBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.getLoginDetails();

    _createTicketBloc.authTokenSave(_userBloc.state.authToken);
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
        child: Form(
            key: _key,
            autovalidate: _validate,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelSalesEnds,
                                          textAlign: TextAlign.left,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .body2),
                                      const SizedBox(height: 4.0),
                                      salesEndDateInput(),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations
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
                            onPressed: _createTicketValidate,
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
                    ]))));
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

          _ticketNameController.clear();
          _priceController.clear();
          _salesEndDateController.clear();
          _totalQuantityController.clear();
          _minQuantityController.clear();
          _maxQuantityController.clear();
          _descriptionController.clear();
        } else {
          context.toast(createTicketResponse.message);
        }
      }
    });
  }

  _createTicketValidate() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _createTicketToApi();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  ticketNameInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_ticketNameController,
              validation: validateTicketName,
              onChanged: _createTicketBloc.ticketNameInput,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintTicketName,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));

  ticketPriceInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_priceController,
              onChanged: _createTicketBloc.ticketPriceInput,
              validation: validatePrice,
              keyboardType: TextInputType.number,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintPrice,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));

  salesEndDateInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_salesEndDateController,
              onChanged: _createTicketBloc.salesEndDateInput,
              validation: validateSalesEndDate,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintSalesEndDate,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));

  totalAvailableInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_totalQuantityController,
              keyboardType: TextInputType.number,
              validation: validateQuantity,
              onChanged: _createTicketBloc.totalAvailableInput,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintQuantity,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));

  minBookingInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_minQuantityController,
              onChanged: _createTicketBloc.minBookingInput,
              keyboardType: TextInputType.number,
              validation: validateQuantity,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintQuantity,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));

  maxBookingInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_maxQuantityController,
              onChanged: _createTicketBloc.maxBookingInput,
              keyboardType: TextInputType.number,
              validation: validateQuantity,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintQuantity,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));

  descriptionInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_descriptionController,
              onChanged: _createTicketBloc.descriptionInput,
              hintText: AppLocalizations
                  .of(context)
                  .inputHintDescription,
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .body1));
}
