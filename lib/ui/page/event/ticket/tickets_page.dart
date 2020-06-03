import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/createticket/create_ticket_bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_bloc.dart';
import 'package:eventmanagement/bloc/event/tickets/tickets_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/ui/page/event/ticket/assign_addon_page.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../dialog/create_tickets_dialog.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          _buildErrorReceiverEmptyBloc(),
          Align(
              alignment: Alignment.topRight,
              child: RaisedButton(
                  splashColor: Colors.black.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
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
                        return prevState.ticketsList != nextState.ticketsList ||
                            prevState.ticketsList.length !=
                                nextState.ticketsList.length;
                      },
                      builder: (context, TicketsState snapshot) {
                        return snapshot.loading
                            ? Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colorProgressBar)))
                            : ticketsList(snapshot.ticketsList);
                      })))
        ]));
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<TicketsBloc, TicketsState>(
        bloc: _ticketsBloc,
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

  Future<void> _onCreateTicketButtonPressed({String ticketId}) async {
    var basicBloc = BlocProvider.of<BasicBloc>(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) =>
          BlocProvider(
            create: (context) =>
                CreateTicketBloc(
                  basicBloc.eventDataId,
                  _ticketsBloc,
                  ticketId: ticketId,
                ),
            child: CreateTicketsDialog(),
          ),
    );
    basicBloc = null;
  }

  ticketsList(List<Ticket> ticketsList) =>
      PlatformScrollbar(
        child: ListView.builder(
            padding: const EdgeInsets.all(0.0),
            itemCount: ticketsList.length,
            itemBuilder: (context, position) {
              final ticket = ticketsList[position];
              final currencyFormat = NumberFormat.simpleCurrency(
                  name: isValid(ticket.currency) ? ticket.currency : 'USD',
                  decimalDigits: (ticket.price?.isInt ?? false) ? 0 : null);
              return GestureDetector(
                  onTap: () {
                    return showTicketActions(ticket);
                  },
                  child: Card(
                      clipBehavior: Clip.antiAlias,
//                      margin: const EdgeInsets.all(0.0),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 72.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              VerticalDivider(
                                thickness: 6,
                                width: 6,
                                color:
                                ticket.active ? colorActive : colorInactive,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        ticket.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${AppLocalizations
                                            .of(context)
                                            .labelTicketAddons} ${ticket.addons
                                            ?.length ?? 0}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 8.0, right: 8.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      const SizedBox(height: 2),
                                      Text(
                                        '${currencyFormat.format(
                                            ticket.price != null
                                                ? ticket.price
                                                : 0)}',
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
                                                  ticket.sellingEndDate)
                                                  .toLocal())
                                              : '--',
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2)
                                    ]),
                              )
                            ],
                          ))));
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
//          _buildMaterialTicketAction(
//              AppLocalizations
//                  .of(context)
//                  .labelAssignCoupon,
//              ticket,
//              assignCoupon),
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
//        _buildCupertinoTicketAction(
//            AppLocalizations
//                .of(context)
//                .labelAssignCoupon,
//            ticket,
//            assignCoupon),
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

  Future<void> assignAddon(Ticket ticket) async {
    dynamic addonIds;

    print('Previous Ticket Addons--->${ticket.addons}');
    if (isPlatformAndroid)
      addonIds = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return BlocProvider(
              create: (BuildContext context) => AddonBloc(assigning: true),
              child: AssignAddonPage(ticket.addons),
            );
          });
    else
      addonIds = await showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (BuildContext context) => AddonBloc(assigning: true),
              child: AssignAddonPage(ticket.addons),
            );
          });

    if (addonIds != null && addonIds is List<String>) {
      context.showProgress(context);

      _ticketsBloc.assignAddon(ticket.sId, addonIds, (results) {
        context.hideProgress(context);
      });
    }
  }

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

  Future<void> deleteTicket(Ticket ticket) async {
    bool delete = await context.showConfirmationDialog(
        AppLocalizations
            .of(context)
            .ticketDeleteTitle,
        AppLocalizations
            .of(context)
            .ticketDeleteMsg,
        posText: AppLocalizations
            .of(context)
            .deleteButton,
        negText: AppLocalizations
            .of(context)
            .btnCancel);

    if (delete ?? false) {
      context.showProgress(context);
      _ticketsBloc.deleteTicket(ticket.sId, (response) {
        context.hideProgress(context);
      });
    }
  }
}
