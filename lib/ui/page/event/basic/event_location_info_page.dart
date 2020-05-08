import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventLocationInfoPage extends StatefulWidget {
  @override
  _EventLocationInfoPageState createState() => _EventLocationInfoPageState();
}

class _EventLocationInfoPageState extends State<EventLocationInfoPage> {
  BasicBloc _basicBloc;

  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _eventStateController = TextEditingController();
  final TextEditingController _eventCityController = TextEditingController();
  final TextEditingController _eventPostalCodeController =
      TextEditingController();

  final FocusNode _focusNodeLocation = FocusNode();
  final FocusNode _focusNodeState = FocusNode();
  final FocusNode _focusNodeCity = FocusNode();
  final FocusNode _focusNodePostal = FocusNode();

  @override
  void initState() {
    super.initState();
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    initTextEditingController();
  }

  @override
  void didUpdateWidget(EventLocationInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initTextEditingController();
  }

  void initTextEditingController() {
    _eventLocationController.text = _basicBloc.state.eventLocation;
    _eventStateController.text = _basicBloc.state.eventState;
    _eventCityController.text = _basicBloc.state.eventCity;
    _eventPostalCodeController.text = _basicBloc.state.eventPostalCode;
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventLocationInfo();
  }

  Widget _buildEventLocationInfo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).titleAddress,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.title),
          const SizedBox(height: 20.0),
          Text(AppLocalizations.of(context).labelLocation,
              style: Theme.of(context).textTheme.body2),
          const SizedBox(height: 4.0),
          _eventLocationInput(),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(AppLocalizations.of(context).labelState,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body2),
                  const SizedBox(height: 4.0),
                  _eventStateInput(),
                ])),
            const SizedBox(width: 10.0),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(AppLocalizations.of(context).labelCity,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body2),
                  const SizedBox(height: 4.0),
                  _eventCityInput(),
                ]))
          ]),
          const SizedBox(height: 10.0),
          Text(AppLocalizations.of(context).labelPostalCode,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.body2),
          const SizedBox(height: 4.0),
          _eventPostalCodeInput(),
          const SizedBox(height: 5)
        ]);
  }

  _eventLocationInput() => widget.inputFieldRectangle(
        _eventLocationController,
        onChanged: _basicBloc.eventLocationInput,
        hintText: AppLocalizations.of(context).inputHintTypeYourLocation,
        labelStyle: Theme.of(context).textTheme.body1,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodeLocation,
        nextFocusNode: _focusNodeState,
      );

  _eventStateInput() => widget.inputFieldRectangle(
        _eventStateController,
        onChanged: _basicBloc.eventStateInput,
        hintText: AppLocalizations.of(context).labelSelectState,
        labelStyle: Theme.of(context).textTheme.body1,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodeState,
        nextFocusNode: _focusNodeCity,
      );

  _eventCityInput() => widget.inputFieldRectangle(
        _eventCityController,
        onChanged: _basicBloc.eventCityInput,
        hintText: AppLocalizations.of(context).labelTypeCityName,
        labelStyle: Theme.of(context).textTheme.body1,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodeCity,
        nextFocusNode: _focusNodePostal,
      );

  _eventPostalCodeInput() => widget.inputFieldRectangle(
        _eventPostalCodeController,
        keyboardType: TextInputType.number,
        onChanged: _basicBloc.eventPostalCodeInput,
        hintText: AppLocalizations.of(context).labelTypePostalCode,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodePostal,
      );
}
