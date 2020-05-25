import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/carnivals/carnivals.dart';
import 'package:eventmanagement/ui/widget/width_aware_text_field.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicInfoPage extends StatefulWidget {
  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  BasicBloc _basicBloc;

//  UserBloc _userBloc;

  final TextEditingController _eventNameController = TextEditingController();
  final FocusNode _focusNodeName = FocusNode();

  @override
  void initState() {
    super.initState();
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    _eventNameController.text = _basicBloc.state.eventName;
  }

  @override
  void didUpdateWidget(BasicInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _eventNameController.text = _basicBloc.state.eventName;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBasicInfo();
  }

  Widget _buildBasicInfo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).titleBasicInfo,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.title),
          const SizedBox(height: 20.0),
          Text(AppLocalizations.of(context).labelEventName,
              style: Theme.of(context).textTheme.body2),
          const SizedBox(height: 4.0),
          _eventNameInput(),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(AppLocalizations.of(context).labelEventType,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body2),
                  const SizedBox(height: 4.0),
                  InkWell(
                    onTap: _onEventTypeButtonPressed,
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.only(left: 3.0),
                      decoration: boxDecorationRectangle(),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: BlocBuilder<BasicBloc, BasicState>(
                          condition: (prevState, newState) =>
                              prevState.eventType != newState.eventType,
                          builder: (BuildContext context, state) {
                            return Text(
                              isValid(state.eventType)
                                  ? state.eventType
                                  : AppLocalizations.of(context)
                                      .inputHintEventType,
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  color: isValid(state.eventType)
                                      ? null
                                      : Theme.of(context).hintColor),
                            );
                          },
                          bloc: _basicBloc,
                        ),
                      ),
                    ),
                  ),
                  // _eventCarnivalNameInput(),
                ])),
            const SizedBox(width: 10.0),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(AppLocalizations.of(context).labelTimeZone,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.body2),
                  const SizedBox(height: 4.0),
                  InkWell(
                    onTap: () {
                      _onTimeZoneButtonPressed();
                    },
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.only(left: 3.0),
                      decoration: boxDecorationRectangle(),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: BlocBuilder<BasicBloc, BasicState>(
                          condition: (prevState, newState) =>
                              prevState.eventTimeZone != newState.eventTimeZone,
                          builder: (BuildContext context, state) => Text(
                            isValid(state.eventTimeZone)
                                ? state.eventTimeZone
                                : AppLocalizations.of(context)
                                    .inputHintTimeZone,
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: isValid(state.eventTimeZone)
                                    ? null
                                    : Theme.of(context).hintColor),
                          ),
                          bloc: _basicBloc,
                        ),
                      ),
                    ),
                  ),
                ]))
          ]),
          const SizedBox(height: 10.0),
          Text(AppLocalizations.of(context).labelTags,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.body2),
          const SizedBox(height: 4.0),
//          _eventTagInput(),
//          const SizedBox(height: 5),
          _eventTagChipInput(),
        ]);
  }

  _eventNameInput() => widget.inputFieldRectangle(
        _eventNameController,
//        initialValue: _basicBloc.state.eventName,
    maxLength: 250,
        onChanged: _basicBloc.eventNameInput,
        hintText: AppLocalizations.of(context).inputHintEventName,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeName,
      );

  Widget eventTypeList(List<Carnivals> carnivalList) {
    return ListView.builder(
        itemCount: carnivalList.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          Carnivals carnivals = carnivalList[position];
          return InkWell(
              onTap: () {
                Navigator.pop(context);
                _basicBloc.eventTypeInput(carnivals.category);
                print(carnivals.category);
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
                      carnivals.category,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: colorTextAction,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const Divider(),
                ],
              ));
        });
  }

  Future<void> _onEventTypeButtonPressed() async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _eventTypeSelect();
//              Container(
//              child: _eventTypeSelect(),
//              decoration: BoxDecoration(
//                color: Theme.of(context).canvasColor,
//                borderRadius: BorderRadius.only(
//                  topLeft: const Radius.circular(10),
//                  topRight: const Radius.circular(10),
//                ),
//              ),
//            );
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoEventTypeActionSheet(),
      );
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _onTimeZoneButtonPressed() async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _timeZonelist(_basicBloc.timeZoneList);
//              Container(
//              child: _timeZonelist(timeZoneList),
//              decoration: BoxDecoration(
//                color: Theme.of(context).canvasColor,
//                borderRadius: BorderRadius.only(
//                  topLeft: const Radius.circular(10),
//                  topRight: const Radius.circular(10),
//                ),
//              ),
//            );
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => _buildCupertinoTimezoneActionSheet(),
      );
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _timeZonelist(List<String> timeZonelist) => ListView.builder(
      itemCount: timeZonelist.length,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return InkWell(
            onTap: () {
              Navigator.pop(context);
              _basicBloc.eventTimeZoneInput(timeZonelist[position]);
              print(timeZonelist[position]);
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
                    timeZonelist[position],
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          color: colorTextAction,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const Divider(),
              ],
            ));
      });

  Widget _buildCupertinoTimezoneActionSheet() {
    return CupertinoActionSheet(
      actions: _basicBloc.timeZoneList.map<Widget>((timezone) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _basicBloc.eventTimeZoneInput(timezone);
            print(timezone);
          },
          child: Text(
            timezone,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: colorTextAction,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      }).toList(),
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

  boxDecorationRectangle() => BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      );

  Widget _eventTypeSelect() {
    return BlocBuilder<BasicBloc, BasicState>(
        condition: (prevState, newState) =>
            prevState.eventTypeList != newState.eventTypeList ||
            prevState.eventTypeList.length != newState.eventTypeList.length,
        bloc: _basicBloc,
        builder: (context, BasicState snapshot) {
          return snapshot.loading
              ? Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorProgressBar)))
              : (snapshot.eventTypeList?.length ?? 0) > 0
              ? eventTypeList(snapshot.eventTypeList)
              : Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            child: Text(
              AppLocalizations
                  .of(context)
                  .errorNoEventTypesAvailable,
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle
                  .copyWith(
                color: colorTextAction,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        });
  }

  Widget _buildCupertinoEventTypeActionSheet() {
    return BlocBuilder<BasicBloc, BasicState>(
      condition: (prevState, newState) =>
      prevState.eventTypeList != newState.eventTypeList ||
          prevState.eventTypeList.length != newState.eventTypeList.length,
      bloc: _basicBloc,
      builder: (context, BasicState snapshot) =>
      snapshot.loading
          ? Container(
          alignment: FractionalOffset.center,
          child: CupertinoActivityIndicator())
          : (snapshot.eventTypeList?.length ?? 0) > 0
          ? CupertinoActionSheet(
        actions: snapshot.eventTypeList.map<Widget>((carnival) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _basicBloc.eventTypeInput(carnival.category);
              print(carnival.category);
            },
            child: Text(
              carnival.category,
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle
                  .copyWith(
                color: colorTextAction,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            AppLocalizations
                .of(context)
                .btnCancel,
            style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(
              color: colorTextAction,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      )
          : CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations
                  .of(context)
                  .errorNoEventTypesAvailable,
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle
                  .copyWith(
                color: colorTextAction,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

//  _eventTagInput() => BlocBuilder(
//      bloc: _basicBloc,
//      builder: (BuildContext context, BasicState state) =>
//          widget.inputFieldRectangle(
//            _eventTagsController,
//            onChanged: _basicBloc.eventTagsInput,
//            hintText: AppLocalizations.of(context).inputHintTag,
//            labelStyle: Theme.of(context).textTheme.body1,
//            maxLines: 5,
//          ));

  FocusNode _focusNode = FocusNode();

  _eventTagChipInput() {
//    final chips = _tagsList.map<Widget>((tag) {
//      return _buildEventTagChip(tag);
//    }).toList();
//
//    chips.add(
//      WidthAwareTextField(
//        focusNode: _focusNode,
//        showHint: _tagsList.length == 0 ? true : false,
//        onActionDone: (value) {
//          setState(() {
//            if (!_tagsList.add(value)) {
//              context.toast('Duplicate Value');
//            }
//            _focusNode.requestFocus();
//          });
//        },
//      ),
//    );

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: Colors.grey)),
          padding: const EdgeInsets.all(4.0),
          child: BlocBuilder<BasicBloc, BasicState>(
              condition: (prevState, newState) =>
                  prevState.eventTags != newState.eventTags,
              builder: (BuildContext context, state) {
                final chips = state.eventTags.map<Widget>((tag) {
                  return _buildEventTagChip(tag);
                }).toList();

                chips.add(
                  WidthAwareTextField(
                    focusNode: _focusNode,
                    showHint: state.eventTags.length == 0 ? true : false,
                    onActionDone: (value) {
                      _basicBloc.eventTagsInput(value);
                      _focusNode.requestFocus();
                    },
                  ),
                );

                return Wrap(
                  spacing: 8.0,
                  children: chips,
                );
              })),
    );
  }

  Widget _buildEventTagChip(String tag) {
    return Chip(
      label: Text(
        tag,
        style: Theme.of(context).textTheme.body2,
      ),
      onDeleted: () {
        _basicBloc.eventRemoveTag(tag);
      },
    );
  }
}
