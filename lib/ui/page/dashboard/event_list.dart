import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
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
              return EventListItem(
                  key: ValueKey(eventDataList[position].id),
                  id: eventDataList[position].id,
                  systemPath: systemPath);
            },
            childCount: eventDataList?.length ?? 0,
          ),
        );
      },
    );
  }
}
