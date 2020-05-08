import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/ui/widget/sliver_custom_persistent_header_delegate.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventFilter extends StatefulWidget {
  @override
  _EventFilterState createState() => _EventFilterState();
}

class _EventFilterState extends State<EventFilter>
    with TickerProviderStateMixin {
  EventBloc _eventBloc;

  @override
  void initState() {
    super.initState();
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _eventBloc.selectFilterValue(getEventFilterStatus()[0].name);
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventListFilterView();
  }

  Widget _buildEventListFilterView() {
    return BlocBuilder<EventBloc, EventState>(
      condition: (prevState, newState) =>
          prevState.eventCurrentFilter != newState.eventCurrentFilter,
      bloc: _eventBloc,
      builder: (context, state) {
        return _buildEventFilterView(
            state.eventCurrentFilter, state.eventFilterItemList);
      },
    );
  }

  Widget _buildEventFilterView(
      String selectedMenu, List<MenuCustom> eventFilterItems) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomPersistentHeaderDelegate(
          minExt: 36.0,
          maxExt: 36.0,
          child: Container(
              height: 36.0,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                  color: bgColorFilterRow,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: eventFilterItems.map((data) {
                    return Expanded(
                        child: GestureDetector(
                            onTap: () {
                              _eventBloc.selectFilterValue(data.name);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: selectedMenu == data.name
                                        ? bgColorButton
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.all(8),
                                child: Text(data.name,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(fontSize: 12.0)))));
                  }).toList()))),
//        title: Container(
////            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//            decoration: BoxDecoration(
//                color: bgColorFilterRow,
//                borderRadius: BorderRadius.all(Radius.circular(5.0))),
//            child: Row(
//                children: eventFilterItems.map((data) {
//              return Expanded(
//                  child: GestureDetector(
//                      onTap: () {
//                        _eventBloc.selectFilterValue(data.name);
//                      },
//                      child: Container(
//                          decoration: BoxDecoration(
//                              color: selectedMenu == data.name
//                                  ? bgColorButton
//                                  : Colors.transparent,
//                              borderRadius: BorderRadius.circular(5)),
//                          padding: EdgeInsets.all(8),
//                          child: Text(data.name,
//                              textAlign: TextAlign.center,
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .body1
//                                  .copyWith(fontSize: 12.0)))));
//            }).toList())),
    );
  }
}
