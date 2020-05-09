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

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  EventBloc _eventBloc;

  @override
  void initState() {
    super.initState();
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _eventBloc.getAllEvents();
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
          return _buildEventSliverListView();
        }
      },
    );
  }

  Widget _buildEventSliverListView() {
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
              return _buildEventListItemCard(eventDataList[position]);
            },
            childCount: eventDataList?.length ?? 0,
          ),
        );
      },
    );
  }

  InkWell _buildEventListItemCard(EventData eventData) => InkWell(
        onTap: () => showEventActions(eventData),
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.0), top: Radius.circular(10.0)),
            ),
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.purple,
                      backgroundImage: isValid(eventData.banner)
                          ? NetworkImage(eventData.banner)
                          : AssetImage(profileImage),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            eventData.title ??
                                AppLocalizations.of(context).notAvailable,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          const SizedBox(height: 2.0),
                          Row(children: <Widget>[
                            Icon(Icons.calendar_today, size: 15.0),
                            const SizedBox(width: 3.0),
                            Text(
                              isValid(eventData.startDateTime)
                                  ? DateFormat.yMMMd().format(
                                      DateTime.parse(eventData.startDateTime))
                                  : AppLocalizations.of(context).notAvailable,
                              style: Theme.of(context).textTheme.body2.copyWith(
                                    color: colorTextSubhead,
                                  ),
                            ),
                          ]),
                          const SizedBox(height: 15.0),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: <Widget>[
                                  Icon(Icons.image_aspect_ratio, size: 15.0),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    '0/200',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                          color: colorTextSubhead,
                                        ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Icon(Icons.visibility, size: 15.0),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    '1000',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                          color: colorTextSubhead,
                                        ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Icon(Icons.visibility, size: 15.0),
                                  const SizedBox(width: 3.0),
                                  Align(
                                    child: Text(
                                      '00',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                            color: colorTextSubhead,
                                          ),
                                    ),
                                  )
                                ])
                              ])
                        ],
                      ),
                    )
                  ],
                ))),
      );

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
          _buildMaterialEventAction(AppLocalizations.of(context).labelEditEvent,
              eventData, editEvent),
          _buildMaterialEventAction(
              AppLocalizations.of(context).labelDeleteEvent,
              eventData,
              deleteEvent),
        ],
      );

  Widget _buildMaterialEventAction(
      String name, EventData eventData, Function handler) {
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

  Widget _buildCupertinoEventAction(
      String name, EventData eventData, Function handler) {
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

  Future<void> editEvent(EventData eventData) async {
    var refresh = await Navigator.pushNamed(context, eventMenuRoute,
        arguments: eventData.id);
    if (refresh ?? false) _eventBloc.getAllEvents();
  }

  void deleteEvent(EventData eventData) {
    context.showProgress(context);
    _eventBloc.deleteEvent(eventData.id, (response) {
      context.hideProgress(context);
    });
  }
}
