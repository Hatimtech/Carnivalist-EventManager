import 'package:eventmanagement/bloc/event/createticket/create_ticket_bloc.dart';
import 'package:eventmanagement/bloc/event/createticket/create_ticket_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
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
    return  Dialog(
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
                  Text(titleTicketDetails,
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 18,
                          color: colorSubHeader,
                          fontWeight: FontWeight.bold,
                          fontFamily: montserratBoldFont))),
                  SizedBox(height: 20.0),
                  Text(labelTicketName,
                      style: (TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: montserratBoldFont))),
                  SizedBox(height: 4.0),
                  ticketNameInput(),
                  SizedBox(height: 10.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(labelPrice,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: montserratBoldFont))),
                              SizedBox(height: 4.0),
                              ticketPriceInput(),
                            ])),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(labelSalesEnds,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: montserratBoldFont))),
                              SizedBox(height: 4.0),
                              salesEndDateInput(),
                            ]))
                      ]),
                  SizedBox(height: 10.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(labelTotalAvailable,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: montserratBoldFont))),
                              SizedBox(height: 4.0),
                              totalAvailableInput(),
                            ])),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(labelMinBooking,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: montserratBoldFont))),
                              SizedBox(height: 4.0),
                              minBookingInput(),
                            ])),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(labelMaxBooking,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: montserratBoldFont))),
                              SizedBox(height: 4.0),
                              maxBookingInput(),
                            ]))
                      ]),
                  SizedBox(height: 10.0),
                  Text(labelDescription,
                      textAlign: TextAlign.left,
                      style: (TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: montserratBoldFont))),
                  SizedBox(height: 4.0),
                  descriptionInput(),
                  SizedBox(height: 15),
                  Row(children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: HexColor('#8c3ee9'),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(btnClose,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400))))),
                    SizedBox(width: 15),
                    Expanded(
                        child: GestureDetector(
                            onTap: () => _createTicketValidate(),
                            child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: HexColor('#8c3ee9'),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(btnSave,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)))))
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
              hintText: inputHintTicketName));

  ticketPriceInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_priceController,
              onChanged: _createTicketBloc.ticketPriceInput,
              validation: validatePrice,
              keyboardType: TextInputType.number,
              hintText: inputHintPrice));

  salesEndDateInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_salesEndDateController,
              onChanged: _createTicketBloc.salesEndDateInput,
              validation: validateSalesEndDate,
              hintText: inputHintSalesEndDate));

  totalAvailableInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_totalQuantityController,
              keyboardType: TextInputType.number,
              validation: validateQuantity,
              onChanged: _createTicketBloc.totalAvailableInput,
              hintText: inputHintQuantity));

  minBookingInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_minQuantityController,
              onChanged: _createTicketBloc.minBookingInput,
              keyboardType: TextInputType.number,
              validation: validateQuantity,
              hintText: inputHintQuantity));

  maxBookingInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_maxQuantityController,
              onChanged: _createTicketBloc.maxBookingInput,
              keyboardType: TextInputType.number,
              validation: validateQuantity,
              hintText: inputHintQuantity));

  descriptionInput() => BlocBuilder(
      bloc: _createTicketBloc,
      builder: (BuildContext context, CreateTicketState state) =>
          widget.inputFieldRectangle(_descriptionController,
              onChanged: _createTicketBloc.descriptionInput,
              hintText: inputHintDescription));
}
