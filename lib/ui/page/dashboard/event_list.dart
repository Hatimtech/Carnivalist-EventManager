import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/page/dashboard/event_list_item.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      cubit: _eventBloc,
      buildWhen: (prevState, newState) => prevState.loading != newState.loading,
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
      buildWhen: (prevState, newState) =>
      prevState.eventCurrentFilter != newState.eventCurrentFilter ||
          prevState.eventDataList != newState.eventDataList,
      cubit: _eventBloc,
      builder: (context, state) {
        final eventDataList = state.data;
        if (eventDataList?.isNotEmpty ?? false)
          return SliverFixedExtentList(
            itemExtent: 148.0,
            delegate: SliverChildBuilderDelegate(
                  (context, position) {
                return EventListItem(
                    key: ValueKey(eventDataList[position].id),
                    id: eventDataList[position].id,
                    systemPath: systemPath);
              },
              childCount: eventDataList?.length ?? 0,
            ),
          );
        else
          return SliverFillRemaining(
              child: !state.loading
                  ? buildNoDataView(
                context,
                getNoDataToShowMsg(state.eventCurrentFilter),
                    () => _eventBloc.getAllEvents(),
              )
                  : SizedBox.shrink());
      },
    );
  }

  String getNoDataToShowMsg(String filter) {
    var eventFilterItemList = _eventBloc.state.eventFilterItemList;
    if (filter == eventFilterItemList[0].name)
      return AppLocalizations
          .of(context)
          .noCurrentEventsToShow;
    else if (filter == eventFilterItemList[1].name)
      return AppLocalizations
          .of(context)
          .noDraftEventsToShow;
    else
      return AppLocalizations
          .of(context)
          .noPastEventsToShow;
  }
}
