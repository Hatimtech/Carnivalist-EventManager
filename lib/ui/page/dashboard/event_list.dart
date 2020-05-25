import 'dart:io';

import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as Path;

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  EventBloc _eventBloc;
  Future _futureSystemPath;

  @override
  void initState() {
    super.initState();
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _futureSystemPath = getSystemDirPath();
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventSliverList();
  }

  Widget _buildEventSliverList() {
    return BlocBuilder<EventBloc, EventState>(
      bloc: _eventBloc,
      condition: (prevState, newState) => prevState.loading != newState.loading,
      builder: (BuildContext context, state) {
        if (state.loading) {
          return SliverFillRemaining(
            child: Center(child: const PlatformProgressIndicator()),
          );
        } else {
          return FutureBuilder(
              future: _futureSystemPath,
              builder: (_, snapshot) =>
              snapshot.connectionState ==
                  ConnectionState.waiting
                  ? SliverToBoxAdapter(child: const SizedBox.shrink())
                  : _buildEventSliverListView(snapshot.data ?? fallbackPath));
        }
      },
    );
  }

  Widget _buildEventSliverListView(String systemPath) {
    return BlocBuilder<EventBloc, EventState>(
      condition: (prevState, newState) =>
      prevState.eventCurrentFilter != newState.eventCurrentFilter ||
          prevState.eventDataList != newState.eventDataList,
      bloc: _eventBloc,
      builder: (context, state) {
        final eventDataList = state.data;
        return SliverFixedExtentList(
          itemExtent: 124.0,
          delegate: SliverChildBuilderDelegate(
                (context, position) {
              return _buildEventListItemCard(
                  eventDataList[position], systemPath);
            },
            childCount: eventDataList?.length ?? 0,
          ),
        );
      },
    );
  }

  InkWell _buildEventListItemCard(EventData eventData, String systemPath) =>
      InkWell(
        onTap: () => showEventActions(eventData),
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
                  color: eventData.status == 'ACTIVE'
                      ? colorActive
                      : colorInactive,
                ),
                const SizedBox(width: 8.0),
                _buildBannerImage(eventData, systemPath),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        eventData.title ??
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
                      const SizedBox(height: 2.0),
                      Row(children: <Widget>[
                        Icon(Icons.event, size: 15.0, color: colorIcon),
                        const SizedBox(width: 3.0),
                        Text(
                          isValid(eventData.startDateTime)
                              ? DateFormat.yMMMd().format(
                              DateTime.parse(eventData.startDateTime))
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
                      const SizedBox(height: 15.0),
                      Row(children: [
                        Expanded(
                          child: Row(children: <Widget>[
                            Icon(Icons.event_seat,
                                size: 15.0, color: colorIcon),
                            const SizedBox(width: 4.0),
                            Text(
                              '0/${getTotalTicketCountByEvent(eventData)}',
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
                              '1000',
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
                      ])
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  int getTotalTicketCountByEvent(EventData _eventData) {
    int ticketsCount = 0;
    if ((_eventData.tickets?.length ?? 0) > 0) {
      _eventData.tickets.forEach((ticket) {
        ticketsCount += (ticket.quantity ?? 0);
      });
    }
    return ticketsCount;
  }

  Widget _buildBannerImage(EventData eventData, String systemPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(42.0),
      child: isValid(eventData.banner)
          ? FadeInImage(
        width: 84,
        height: 84,
        fit: BoxFit.cover,
        placeholder: AssetImage(placeholderImage),
        image: NetworkToFileImage(
          url: eventData.banner,
          file: File(Path.join(
              systemPath,
              'Pictures',
              eventData.banner
                  .substring(eventData.banner.lastIndexOf('/') + 1))),
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

  Future<void> showEventActions(EventData eventData) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _buildMaterialTicketActionSheet(eventData);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoEventActionSheet(eventData),
      );
    }
  }

  Widget _buildMaterialTicketActionSheet(EventData eventData) => ListView(
    shrinkWrap: true,
    children: <Widget>[
      if (_eventBloc.state.eventCurrentFilter ==
          getEventFilterStatus()[0].name)
        _buildMaterialEventAction(
            eventData.status == 'ACTIVE'
                ? AppLocalizations.of(context).labelInactiveEvent
                : AppLocalizations.of(context).labelActiveEvent,
            eventData,
            inactiveActiveEvent),
      _buildMaterialEventAction(AppLocalizations
          .of(context)
          .labelViewEvent,
          eventData, viewEvent),
      _buildMaterialEventAction(AppLocalizations.of(context).labelEditEvent,
          eventData, editEvent),
      _buildMaterialEventAction(
          AppLocalizations.of(context).labelDeleteEvent,
          eventData,
          deleteEvent),
    ],
  );

  Widget _buildMaterialEventAction(String name, EventData eventData, Function handler) {
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
                name,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: colorTextAction,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoEventActionSheet(EventData eventData) {
    return CupertinoActionSheet(
      actions: [
        if (_eventBloc.state.eventCurrentFilter ==
            getEventFilterStatus()[0].name)
          _buildCupertinoEventAction(
              eventData.status == 'ACTIVE'
                  ? AppLocalizations.of(context).labelInactiveEvent
                  : AppLocalizations.of(context).labelActiveEvent,
              eventData,
              inactiveActiveEvent),
        _buildCupertinoEventAction(
            AppLocalizations
                .of(context)
                .labelViewEvent, eventData, viewEvent),
        _buildCupertinoEventAction(
            AppLocalizations.of(context).labelEditEvent, eventData, editEvent),
        _buildCupertinoEventAction(
            AppLocalizations.of(context).labelDeleteEvent,
            eventData,
            deleteEvent),
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

  Widget _buildCupertinoEventAction(String name, EventData eventData, Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler(eventData);
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

  void inactiveActiveEvent(EventData eventData) {
    context.showProgress(context);
    _eventBloc.activeInactiveEvent(
        eventData.id, eventData.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE',
            (response) {
          context.hideProgress(context);
        });
  }

  void viewEvent(EventData eventData) async {
    Navigator.pushNamed(context, eventDetailRoute, arguments: eventData.id);
  }

  Future<void> editEvent(EventData eventData) async {
    var refresh = await Navigator.pushNamed(context, eventMenuRoute,
        arguments: eventData.id);
    if (refresh ?? false) _eventBloc.getAllEvents();
  }

  Future<void> deleteEvent(EventData eventData) async {
    bool delete = await context.showConfirmationDialog(
        AppLocalizations
            .of(context)
            .eventDeleteTitle,
        AppLocalizations
            .of(context)
            .eventDeleteMsg,
        posText: AppLocalizations
            .of(context)
            .deleteButton,
        negText: AppLocalizations
            .of(context)
            .btnCancel);

    if (delete ?? false) {
      context.showProgress(context);
      _eventBloc.deleteEvent(eventData.id, (response) {
        context.hideProgress(context);
      });
    }
  }
}
