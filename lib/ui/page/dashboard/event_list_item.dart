import 'dart:io';

import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as Path;

class EventListItem extends StatefulWidget {
  final String id;
  final String systemPath;
  final bool viewOnly;

  const EventListItem({
    Key key,
    this.id,
    this.systemPath,
    this.viewOnly = false,
  }) : super(key: key);

  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  EventBloc _eventBloc;
  EventData _eventData;

  @override
  void initState() {
    super.initState();
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _eventData = _eventBloc.state.eventDataList
        .firstWhere((element) => element.id == widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventListItemCard(widget.systemPath);
  }

  InkWell _buildEventListItemCard(String systemPath) {
    var ticketCountAndPriceByEvent = getTicketCountAndPriceByEvent(_eventData);
    return InkWell(
      onTap: () => widget.viewOnly ? viewEvent() : showEventActions(),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0),
            top: Radius.circular(10.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(right: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              VerticalDivider(
                thickness: 6,
                width: 6,
                color:
                _eventData.status == 'ACTIVE' ? colorActive : colorInactive,
              ),
              const SizedBox(width: 8.0),
              _buildBannerImage(systemPath),
              const SizedBox(width: 4.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _eventData.title ??
                                AppLocalizations
                                    .of(context)
                                    .notAvailable,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle,
                          ),
                        ),
                        Text(
                          _eventData.status,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body2
                              .copyWith(
                            color: _eventData.status == 'ACTIVE'
                                ? colorActive
                                : colorInactive,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Row(children: <Widget>[
                      Icon(Icons.event, size: 15.0, color: colorIcon),
                      const SizedBox(width: 3.0),
                      Text(
                        isValid(_eventData.startDateTime)
                            ? DateFormat.yMMMd().format(
                            DateTime.parse(_eventData.startDateTime)
                                .toLocal())
                            : AppLocalizations
                            .of(context)
                            .notAvailable,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2
                            .copyWith(
                          color: colorTextSubhead,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8.0),
                    Row(children: [
                      Expanded(
                        child: Row(children: <Widget>[
                          Icon(Icons.event_seat, size: 15.0, color: colorIcon),
                          const SizedBox(width: 4.0),
                          Text(
                            '${ticketCountAndPriceByEvent[1]}/${ticketCountAndPriceByEvent[0]}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2
                                .copyWith(
                              color: colorTextSubhead,
                            ),
                          )
                        ]),
                      ),
                      Expanded(
                        child: Row(children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 15.0, color: colorIcon),
                          const SizedBox(width: 4.0),
                          Text(
                            ticketCountAndPriceByEvent[2],
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2
                                .copyWith(
                              color: colorTextSubhead,
                            ),
                          )
                        ]),
                      )
                    ]),
                    const SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      Icon(Icons.local_offer, size: 15.0, color: colorIcon),
                      const SizedBox(width: 4.0),
                      Text(
                        '${AppLocalizations
                            .of(context)
                            .eventCarnival} ${_eventData.type ?? '--'}',
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2
                            .copyWith(
                          color: colorTextSubhead,
                        ),
                      )
                    ]),
                    const SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      Icon(Icons.location_city, size: 15.0, color: colorIcon),
                      const SizedBox(width: 4.0),
                      Text(
                        '${AppLocalizations
                            .of(context)
                            .eventCity} ${_eventData.place?.city ?? '--'}',
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2
                            .copyWith(
                          color: colorTextSubhead,
                        ),
                      )
                    ]),
                    const SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      Icon(Icons.approval, size: 15.0, color: colorIcon),
                      const SizedBox(width: 4.0),
                      Text(
                        (_eventData.isApprovedBySuperAdmin ?? false)
                            ? '${AppLocalizations
                            .of(context)
                            .eventApproved}'
                            : '${AppLocalizations
                            .of(context)
                            .eventPendingApproval}',
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2
                            .copyWith(
                          color: colorTextSubhead,
                        ),
                      )
                    ]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> getTicketCountAndPriceByEvent(EventData _eventData) {
    int totalTicketsCount = 0;
    int soldTicketsCount = 0;
    double minTicketPrice;
    if ((_eventData.tickets?.length ?? 0) > 0) {
      _eventData.tickets.forEach((ticket) {
        totalTicketsCount += (ticket.initialOriginalQuantity ?? 0);
        soldTicketsCount +=
            (ticket.initialOriginalQuantity ?? 0) - (ticket.quantity ?? 0);

        if ((minTicketPrice == null && ticket.price != null) ||
            (ticket.price != null && (ticket.price < (minTicketPrice ?? 0))))
          minTicketPrice = ticket.price;
      });
    }
    return List.of([
      totalTicketsCount.toString(),
      soldTicketsCount.toString(),
      (minTicketPrice ?? 0).toString()
    ]);
  }

  Widget _buildBannerImage(String systemPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(42.0),
      child: isValid(_eventData.banner)
          ? FadeInImage(
              width: 84,
              height: 84,
              fit: BoxFit.cover,
              placeholder: AssetImage(placeholderImage),
              image: NetworkToFileImage(
                url: _eventData.banner,
                file: File(Path.join(
                    systemPath,
                    'Pictures',
                    _eventData.banner
                        .substring(_eventData.banner.lastIndexOf('/') + 1))),
                debug: true,
              ),
            )
          : Image.asset(
              placeholderImage,
              width: 84,
              height: 84,
              fit: BoxFit.cover,
            ),
    );
  }

  Future<void> showEventActions() async {
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
            return _buildMaterialTicketActionSheet();
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => _buildCupertinoEventActionSheet(),
      );
    }
  }

  Widget _buildMaterialTicketActionSheet() => ListView(
        shrinkWrap: true,
        children: <Widget>[
          if (_eventBloc.state.eventCurrentFilter ==
              getEventFilterStatus()[0].name)
            _buildMaterialEventAction(
                _eventData.status == 'ACTIVE'
                    ? AppLocalizations.of(context).labelInactiveEvent
                    : AppLocalizations.of(context).labelActiveEvent,
                inactiveActiveEvent,
                true),
          _buildMaterialEventAction(
              AppLocalizations
                  .of(context)
                  .labelViewEvent, viewEvent, true),
          _buildMaterialEventAction(
              AppLocalizations
                  .of(context)
                  .labelEditEvent, editEvent, true),
          _buildMaterialEventAction(
              AppLocalizations
                  .of(context)
                  .labelDeleteEvent,
              deleteEvent,
              false),
        ],
      );

  Widget _buildMaterialEventAction(String name, Function handler,
      bool showDivider) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler();
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
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: colorTextAction,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (showDivider) const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoEventActionSheet() {
    return CupertinoActionSheet(
      actions: [
        if (_eventBloc.state.eventCurrentFilter ==
            getEventFilterStatus()[0].name)
          _buildCupertinoEventAction(
              _eventData.status == 'ACTIVE'
                  ? AppLocalizations.of(context).labelInactiveEvent
                  : AppLocalizations.of(context).labelActiveEvent,
              inactiveActiveEvent),
        _buildCupertinoEventAction(
            AppLocalizations.of(context).labelViewEvent, viewEvent),
        _buildCupertinoEventAction(
            AppLocalizations.of(context).labelEditEvent, editEvent),
        _buildCupertinoEventAction(
            AppLocalizations.of(context).labelDeleteEvent, deleteEvent),
      ],
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
    );
  }

  Widget _buildCupertinoEventAction(String name, Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler();
      },
      child: Text(
        name,
        style: Theme.of(context).textTheme.subtitle.copyWith(
              color: colorTextAction,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void inactiveActiveEvent() {
    context.showProgress(context);
    _eventBloc.activeInactiveEvent(
        _eventData.id, _eventData.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE',
        (response) {
      context.hideProgress(context);
    });
  }

  void viewEvent() async {
    Navigator.pushNamed(context, eventDetailRoute, arguments: _eventData.id);
  }

  Future<void> editEvent() async {
    var refresh = await Navigator.pushNamed(context, eventMenuRoute,
        arguments: _eventData.id);
    if (refresh ?? false) _eventBloc.getAllEvents();
  }

  Future<void> deleteEvent() async {
    bool delete = await context.showConfirmationDialog(
        AppLocalizations.of(context).eventDeleteTitle,
        AppLocalizations.of(context).eventDeleteMsg,
        posText: AppLocalizations
            .of(context)
            .eventDeleteButton,
        negText: AppLocalizations.of(context).btnCancel);

    if (delete ?? false) {
      context.showProgress(context);
      _eventBloc.deleteEvent(_eventData.id, (response) {
        context.hideProgress(context);
      });
    }
  }
}
