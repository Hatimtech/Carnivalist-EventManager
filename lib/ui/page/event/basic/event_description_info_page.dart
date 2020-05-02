import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDescriptionInfoPage extends StatefulWidget {
  @override
  _EventDescriptionInfoPageState createState() =>
      _EventDescriptionInfoPageState();
}

class _EventDescriptionInfoPageState extends State<EventDescriptionInfoPage> {
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  BasicBloc _basicBloc;

  @override
  void initState() {
    super.initState();
    print('_EventDescriptionInfoPageState: initState');
    _basicBloc = BlocProvider.of<BasicBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventDescriptionInfo();
  }

  Widget _buildEventDescriptionInfo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).titleDescription,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.title),
          const SizedBox(height: 20.0),
          _eventDescriptionInput(),
          const SizedBox(height: 10.0),
          Container(
              child: BlocBuilder<BasicBloc, BasicState>(
                  condition: (prevState, newState) =>
                      prevState.postType != newState.postType,
                  bloc: _basicBloc,
                  builder: (context, BasicState state) => Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: HexColor('#EEEEEF'),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                          children: state.postTypeList.map((data) {
                        return Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  _basicBloc.selectPostType(data.name);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: state.postType == data.name
                                            ? HexColor('#8c3ee9')
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(8),
                                    child: Text(uiValueEventPost(data.name),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .copyWith(
                                              fontSize: 12.0,
                                            )))));
                      }).toList()))))
        ]);
  }

  _eventDescriptionInput() => widget.inputFieldRectangle(
        _eventDescriptionController,
        initialValue: _basicBloc.state.eventDescription,
        onChanged: _basicBloc.eventDescriptionInput,
        hintText: AppLocalizations.of(context).inputHintDescription,
        labelStyle: Theme.of(context).textTheme.body1,
        maxLines: 10,
      );

  String uiValueEventPost(String value) {
    switch (value) {
      case 'Public':
        return AppLocalizations.of(context).labelEventPublic;
      case 'Private':
        return AppLocalizations.of(context).labelEventPrivate;
    }
  }
}
