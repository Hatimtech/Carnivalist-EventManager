import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/createticket/create_ticket_bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    _ticketsBloc
        .authTokenSave(BlocProvider
        .of<UserBloc>(context)
        .state
        .authToken);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          BlocBuilder<TicketsBloc, TicketsState>(
            bloc: _ticketsBloc,
            condition: (prevState, newState) =>
            newState.toastMsg != null || newState.errorCode != null,
            builder: (context, TicketsState state) {
              if (state.toastMsg != null) {
                context.toast(state.toastMsg);
                state.toastMsg = null;
              } else if (state.errorCode != null) {
                String errorMsg = getErrorMessage(state.errorCode, context);
                context.toast(errorMsg);
                state.errorCode = null;
              }
              return SizedBox.shrink();
            },
          ),
          Align(
              alignment: Alignment.topRight,
              child: RaisedButton(
                  splashColor: Colors.black.withOpacity(0.2),
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  onPressed: _onCreateTicketButtonPressed,
                  child: Text(AppLocalizations
                      .of(context)
                      .btnCreateTicket,
                      style: TextStyle(color: Colors.white)))),
          Expanded(
              child: Container(
                  child: BlocBuilder<TicketsBloc, TicketsState>(
                      bloc: _ticketsBloc,
                      condition: (prevState, nextState) {
                        return prevState.ticketsList !=
                            nextState.ticketsList ||
                            prevState.ticketsList.length !=
                                nextState.ticketsList.length;
                      },
                      builder: (context, TicketsState snapshot) {
                        return snapshot.loading
                            ? Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    colorProgressBar)))
                            : ticketsList(snapshot.ticketsList);
                      })))
        ]));
  }

  Future<void> _onCreateTicketButtonPressed({String ticketId}) async {
    var basicBloc = BlocProvider.of<BasicBloc>(context);
    var ticketBloc = BlocProvider.of<TicketsBloc>(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) =>
          BlocProvider(
            create: (context) =>
                CreateTicketBloc(
                  basicBloc,
                  ticketBloc,
                  ticketId: ticketId,
                ),
            child: CreateTicketsDialog(),
          ),
    );
    basicBloc = null;
    ticketBloc = null;
  }

  ticketsList(List<Ticket> ticketsList) =>
      PlatformScrollbar(
        child: ListView.builder(
            itemCount: ticketsList.length,
            itemBuilder: (context, position) {
              final ticket = ticketsList[position];
              return GestureDetector(
                  onTap: () => showTicketActions(ticket),
                  child: Card(
                      margin: EdgeInsets.only(
                          top: 5, left: 0, right: 0, bottom: 5),
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Text(
                                          ticket.name,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${AppLocalizations
                                              .of(context)
                                              .labelTicketCoupons} ${ticket
                                              .addons?.length ??
                                              0}   ${AppLocalizations
                                              .of(context)
                                              .labelTicketAddons} ${ticket
                                              .addons?.length ?? 0}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                            fontSize: 12.0,
                                          ),
                                        )
                                      ])),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    const SizedBox(height: 2),
                                    Text(
                                      '${ticket.price}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(color: colorTextBody1),
                                    ),
                                    Text(
                                        AppLocalizations
                                            .of(context)
                                            .labelTicketSalesEnd,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .body2),
                                    Text(
                                        isValid(ticket.sellingEndDate)
                                            ? DateFormat.yMMMd().format(
                                            DateTime.parse(
                                                ticket.sellingEndDate))
                                            : '--',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .body2)
                                  ])
                            ])
                          ]))));
            }),
      );

  Future<void> showTicketActions(Ticket ticket) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _buildMaterialTicketActionSheet(ticket);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoTicketActionSheet(ticket),
      );
    }
  }

  Widget _buildMaterialTicketActionSheet(Ticket ticket) =>
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildMaterialTicketAction(
              AppLocalizations
                  .of(context)
                  .labelAssignAddon,
              ticket,
              assignAddon),
          _buildMaterialTicketAction(
              AppLocalizations
                  .of(context)
                  .labelAssignCoupon,
              ticket,
              assignCoupon),
          _buildMaterialTicketAction(
              (ticket.active ?? false)
                  ? AppLocalizations
                  .of(context)
                  .labelInactiveTicket
                  : AppLocalizations
                  .of(context)
                  .labelActiveTicket,
              ticket,
              inactiveActiveTicket),
          _buildMaterialTicketAction(
              AppLocalizations
                  .of(context)
                  .labelEditTicket, ticket, editTicket),
          _buildMaterialTicketAction(
              AppLocalizations
                  .of(context)
                  .labelDeleteTicket,
              ticket,
              deleteTicket),
        ],
      );

  Widget _buildMaterialTicketAction(String name, Ticket ticket,
      Function handler) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler(ticket);
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
                name,
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
  }

  Widget _buildCupertinoTicketActionSheet(Ticket ticket) {
    return CupertinoActionSheet(
      actions: [
        _buildCupertinoTicketAction(
            AppLocalizations
                .of(context)
                .labelAssignAddon, ticket, assignAddon),
        _buildCupertinoTicketAction(
            AppLocalizations
                .of(context)
                .labelAssignCoupon,
            ticket,
            assignCoupon),
        _buildCupertinoTicketAction(
            (ticket.active ?? false)
                ? AppLocalizations
                .of(context)
                .labelInactiveTicket
                : AppLocalizations
                .of(context)
                .labelActiveTicket,
            ticket,
            inactiveActiveTicket),
        _buildCupertinoTicketAction(
            AppLocalizations
                .of(context)
                .labelEditTicket, ticket, editTicket),
        _buildCupertinoTicketAction(
            AppLocalizations
                .of(context)
                .labelDeleteTicket,
            ticket,
            deleteTicket),
      ],
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

  Widget _buildCupertinoTicketAction(String name, Ticket ticket,
      Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler(ticket);
      },
      child: Text(
        name,
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
  }

  void assignAddon(Ticket ticket) {}

  void assignCoupon(Ticket ticket) {}

  void inactiveActiveTicket(Ticket ticket) {
    context.showProgress(context);
    _ticketsBloc.activeInactiveTicket(ticket.sId, !(ticket.active ?? false),
            (response) {
          context.hideProgress(context);
        });
  }

  void editTicket(Ticket ticket) {
    _onCreateTicketButtonPressed(ticketId: ticket.sId);
  }

  void deleteTicket(Ticket ticket) {
    context.showProgress(context);
    _ticketsBloc.deleteTicket(ticket.sId, (response) {
      context.hideProgress(context);
    });
  }
}
