import 'dart:async';

import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/page/dashboard/event_list_item.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventStaffHomePage extends StatefulWidget {
  @override
  _EventStaffHomePageState createState() => _EventStaffHomePageState();
}

class _EventStaffHomePageState extends State<EventStaffHomePage> {
  UserBloc _userBloc;
  EventBloc _eventBloc;
  Future _futureSystemPath;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _eventBloc.userIdSave(_userBloc.state.userId);
    _eventBloc.authTokenSave(_userBloc.state.authToken);
    _eventBloc.getAllEventsForStaff();
    _futureSystemPath = getSystemDirPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildTopBgContainer(),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBgContainer() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              AppLocalizations.of(context).titleDashboard,
              style: Theme.of(context).appBarTheme.textTheme.title,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(
                  Icons.power_settings_new,
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                ),
                onPressed: () => showLogoutConfirmationDialog()),
          ),
        ],
      ),
      height: 124,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(colorHeaderBgFilter, BlendMode.srcATop),
          image: AssetImage(headerBackgroundImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        AppLocalizations.of(context).logoutTitle,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 16.0),
      ),
      content: Text(
        AppLocalizations.of(context).logoutMsg,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).btnCancel)),
        FlatButton(
            onPressed: () {
              _eventBloc.clearState();
              _userBloc.clearLoginDetails();
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, (Route<dynamic> route) => false);
            },
            child: Text(AppLocalizations.of(context).btnLogout)),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  Widget _buildEventList() {
    return BlocBuilder<EventBloc, EventState>(
      cubit: _eventBloc,
      buildWhen: (prevState, newState) => prevState.loading != newState.loading,
      builder: (BuildContext context, state) {
        if (state.loading) {
          return Center(child: const PlatformProgressIndicator());
        } else {
          return FutureBuilder(
              future: _futureSystemPath,
              builder: (_, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const SizedBox.shrink()
                      : _buildEventListView(snapshot.data ?? fallbackPath));
        }
      },
    );
  }

  Widget _buildEventListView(String systemPath) {
    return BlocBuilder<EventBloc, EventState>(
      buildWhen: (prevState, newState) =>
          prevState.eventDataList != newState.eventDataList,
      cubit: _eventBloc,
      builder: (context, state) {
        final eventDataList = state.eventDataList;
        return RefreshIndicator(
          onRefresh: () async {
            Completer<bool> downloadCompleter = Completer();
            _eventBloc.getAllEventsForStaff(
                downloadCompleter: downloadCompleter);
            return downloadCompleter.future;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(0.0),
            itemExtent: 148.0,
            itemCount: eventDataList?.length ?? 0,
            itemBuilder: (context, position) {
              return EventListItem(
                key: ValueKey(
                    '${eventDataList[position].id} ${eventDataList[position].title} '
                    '${eventDataList[position].status} ${eventDataList[position].banner} '
                    '${eventDataList[position].startDateTime} ${eventDataList[position].type} '
                    '${eventDataList[position].place?.city} ${eventDataList[position].isApprovedBySuperAdmin} '
                    '${eventDataList[position].ticketDetailsQuantityAndPrice}'),
                id: eventDataList[position].id,
                systemPath: systemPath,
                viewOnly: true,
              );
            },
          ),
        );
      },
    );
  }
}
