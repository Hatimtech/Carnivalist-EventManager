import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/page/event/basic/basic_info_page.dart';
import 'package:eventmanagement/ui/page/event/basic/event_datetime_info_page.dart';
import 'package:eventmanagement/ui/page/event/basic/event_description_info_page.dart';
import 'package:eventmanagement/ui/page/event/basic/event_location_info_page.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicPage extends StatefulWidget {
  @override
  createState() => _BasicState();
}

class _BasicState extends State<BasicPage> {
  BasicBloc _basicBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _basicBloc = BlocProvider.of<BasicBloc>(context);

    if (!isPlatformAndroid) {
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScrollbar(
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            _buildFullRefreshBloc(),
            _buildErrorReceiverEmptyBloc(),
            _buildParentCard(child: BasicInfoPage()),
            _buildParentCard(child: EventDateTimeInfoPage()),
            _buildParentCard(child: EventLocationInfoPage()),
            _buildParentCard(child: EventDescriptionInfoPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildFullRefreshBloc() {
    return BlocBuilder<BasicBloc, BasicState>(
      cubit: _basicBloc,
      buildWhen: (prevState, newState) {
        bool shouldRebuild = newState.fullRefresh ?? false;
        return shouldRebuild;
      },
      builder: (_, state) {
        if (state.fullRefresh ?? false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              state.fullRefresh = false;
            });
          });
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<BasicBloc, BasicState>(
        cubit: _basicBloc,
        buildWhen: (prevState, newState) => newState.uiMsg != null,
        builder: (context, BasicState state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            if (state.uiMsg == ERR_START_DATE_WEEK_DAY ||
                state.uiMsg == ERR_END_DATE_WEEK_DAY)
              context.toast(
                  '$errorMsg${uiLabelWeekday(state.eventWeekday, context)}');
            else
              context.toast(errorMsg);

            state.uiMsg = null;
          }

          return SizedBox.shrink();
        },
      );

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
