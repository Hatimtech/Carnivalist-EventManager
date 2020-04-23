import 'package:eventmanagement/bloc/event/tickets/tickets_bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_state.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dialog/create_tickets_dialog.dart';

class TicketsPage extends StatefulWidget {
  @override
  createState() => _TicketsState();
}

class _TicketsState extends State<TicketsPage> {
  TicketsBloc _ticketsBloc;

  @override
  void initState() {
    super.initState();
    _ticketsBloc = BlocProvider.of<TicketsBloc>(context);
    _ticketsBloc.authTokenSave('s');
    _ticketsBloc.tickets();
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
        body: Container(
            margin: EdgeInsets.all(5),
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      color: HexColor(colorCreateEventBg),
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(5.0),
                      splashColor: Colors.black.withOpacity(0.2),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CreateTicketsDialog()),
                      child: Text(btnCreateTicket,
                          style: TextStyle(color: Colors.white)))),
              Expanded(
                  child: Container(
                      child: BlocBuilder(
                          bloc: _ticketsBloc,
                          builder: (context, TicketsState snapshot) => snapshot
                                  .loading
                              ? Container(
                                  alignment: FractionalOffset.center,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          HexColor(colorProgressBar))))
                              : ticketsList(snapshot.ticketsList))))
            ])));
  }

  ticketsList(List<Tickets> ticketsList) => ListView.builder(
      itemCount: ticketsList.length,
      itemBuilder: (context, position) {
        return GestureDetector(
            child: Card(
                margin: EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 5),
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(ticketsList[position].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 5),
                                  Text('Coupon: 3 Add ons: ' + ticketsList[position].addons.length.toString(),
                                      style: TextStyle(fontSize: 12))
                                ])),
                        Expanded(
                            flex: 0,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 2),
                                  Text(ticketsList[position].price.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  Text('Sales end',
                                      style: TextStyle(fontSize: 10)),
                                  Text(ticketsList[position].sellingEndDate.split('T')[0],
                                      style: TextStyle(fontSize: 10))
                                ]))
                      ])
                    ]))));
      });
}
