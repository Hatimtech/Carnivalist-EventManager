import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/ui/page/event/basic/basic_info_page.dart';
import 'package:eventmanagement/ui/page/event/basic/event_datetime_info_page.dart';
import 'package:eventmanagement/ui/page/event/basic/event_description_info_page.dart';
import 'package:eventmanagement/ui/page/event/basic/event_location_info_page.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicPage extends StatefulWidget {
  @override
  createState() => _BasicState();
}

class _BasicState extends State<BasicPage> {
  BasicBloc _basicBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    print('_BasicState: initState');
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.getLoginDetails();
    _basicBloc.authTokenSave(_userBloc.state.authToken);

    _basicBloc.eventMenu();
    _basicBloc.postType();

    _basicBloc.selectEventMenu(
      _basicBloc.state.eventMenuName.isEmpty
          ? 'Once'
          : _basicBloc.state.eventMenuName,
    );

    _basicBloc.selectPostType(
      _basicBloc.state.postType.isEmpty ? 'Public' : _basicBloc.state.postType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            _buildParentCard(child: BasicInfoPage()),
            _buildParentCard(child: EventDateTimeInfoPage()),
            _buildParentCard(child: EventLocationInfoPage()),
            _buildParentCard(child: EventDescriptionInfoPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildParentCard({Widget child}) {
    return Card(
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(7.0), top: Radius.circular(7.0)),
        ),
        child: Container(padding: EdgeInsets.all(10), child: child));
  }
}
