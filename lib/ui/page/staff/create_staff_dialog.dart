import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/event/event_state.dart';
import 'package:eventmanagement/bloc/staff/create/create_staff_bloc.dart';
import 'package:eventmanagement/bloc/staff/create/create_staff_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/model/staff/create_staff_response.dart';
import 'package:eventmanagement/ui/widget/labeled_checkbox.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateStaffDialog extends StatefulWidget {
  @override
  createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaffDialog> {
  CreateStaffBloc _createStaffBloc;

  ScrollController _scrollController;

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeCity = FocusNode();
  final FocusNode _focusNodeUsername = FocusNode();
  final FocusNode _focusNodeMobileNo = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final List<MenuCustom> couponTypeList = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _createStaffBloc = BlocProvider.of<CreateStaffBloc>(context);
    final _userBloc = BlocProvider.of<UserBloc>(context);
    _createStaffBloc.authTokenSave(_userBloc.state.authToken);
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
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context));
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildErrorReceiverEmptyBloc(),
            Text(AppLocalizations.of(context).titleCreateStaff,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.title),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context).labelStaffName,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            staffNameInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelStaffEmail,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            staffEmailInput(),
            const SizedBox(height: 10.0),
            _buildDOBAndStateInput(),
            const SizedBox(height: 10.0),
            _buildCityAndUsernameInput(),
            const SizedBox(height: 10.0),
            _buildMobileNoAndPasswordInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelStaffEvents,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            eventSelectionInput(),
            const SizedBox(height: 12.0),
            Row(children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnClose,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RaisedButton(
                  onPressed: _createUpdateStaff,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnSave,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  Row _buildDOBAndStateInput() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelStaffDOB,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              _staffDOBInput(),
            ])),
        const SizedBox(width: 10.0),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelStaffState,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              _buildStateSelectionInput(),
            ])),
      ],
    );
  }

  Row _buildCityAndUsernameInput() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelStaffCity,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              staffCityInput(),
            ])),
        const SizedBox(width: 10.0),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelStaffUsername,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              staffUsernameInput(),
            ])),
      ],
    );
  }

  Row _buildMobileNoAndPasswordInput() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelStaffMobileNo,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              staffMobileNoInput(),
            ])),
        const SizedBox(width: 10.0),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelStaffPassword,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              staffPasswordInput(),
            ])),
      ],
    );
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<CreateStaffBloc, CreateStaffState>(
        bloc: _createStaffBloc,
        condition: (prevState, newState) => newState.uiMsg != null,
        builder: (context, state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            context.toast(errorMsg);

            state.uiMsg = null;
          }

          return SizedBox.shrink();
        },
      );

  Widget _staffDOBInput() => BlocBuilder<CreateStaffBloc, CreateStaffState>(
      condition: (prevState, newState) => prevState.dob != newState.dob,
      bloc: _createStaffBloc,
      builder: (BuildContext context, state) {
        return InkWell(
          onTap: () => _pickDate(DateTime.now(), _createStaffBloc.dobInput),
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 3.0),
            decoration: boxDecorationRectangle(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                state.dob != null
                    ? DateFormat.yMMMMd().format(state.dob)
                    : AppLocalizations.of(context).inputHintDate,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color:
                        state.dob != null ? null : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
      });

  Widget _buildStateSelectionInput() {
    return BlocBuilder<CreateStaffBloc, CreateStaffState>(
        bloc: _createStaffBloc,
        condition: (prevState, newState) {
          return prevState.state != newState.state;
        },
        builder: (BuildContext context, state) {
          return InkWell(
            onTap: () => _showStatesBottomSheet(
              (selectedState) => _createStaffBloc.stateInput(selectedState),
            ),
            child: Container(
              height: 48,
              padding: EdgeInsets.only(left: 3.0),
              decoration: boxDecorationRectangle(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isValid(state.state)
                      ? state.state
                      : AppLocalizations.of(context).inputHintStaffState,
                  style: Theme.of(context).textTheme.body1.copyWith(
                      color: isValid(state.state)
                          ? null
                          : Theme.of(context).hintColor),
                ),
              ),
            ),
          );
        });
  }

  _createUpdateStaff() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _createStaffBloc.uploadNewStaff((results) {
      context.hideProgress(context);
      if (results is CreateStaffResponse) {
        if (results.code == apiCodeSuccess) {
          Navigator.pop(context);
        }
      }
    });
  }

  Widget staffNameInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createStaffBloc.state.name,
        textInputAction: TextInputAction.next,
        onChanged: _createStaffBloc.nameInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintStaffName,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeName,
        nextFocusNode: _focusNodeEmail,
      );

  Widget staffEmailInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createStaffBloc.state.email,
        textInputAction: TextInputAction.next,
        onChanged: _createStaffBloc.emailInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintStaffEmail,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeEmail,
        nextFocusNode: _focusNodeCity,
      );

  Widget staffCityInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createStaffBloc.state.city,
        textInputAction: TextInputAction.next,
        onChanged: _createStaffBloc.cityInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintStaffCity,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeCity,
        nextFocusNode: _focusNodeUsername,
      );

  Widget staffUsernameInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createStaffBloc.state.username,
        textInputAction: TextInputAction.next,
        onChanged: _createStaffBloc.usernameInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintStaffUsername,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeUsername,
        nextFocusNode: _focusNodeMobileNo,
      );

  Widget staffMobileNoInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createStaffBloc.state.mobileNumber,
        textInputAction: TextInputAction.next,
        onChanged: _createStaffBloc.mobileNoInput,
        maxLength: 20,
        hintText: AppLocalizations.of(context).inputHintStaffMobileNo,
        labelStyle: Theme.of(context).textTheme.body1,
        keyboardType: TextInputType.phone,
        focusNode: _focusNodeMobileNo,
        nextFocusNode: _focusNodePassword,
      );

  Widget staffPasswordInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createStaffBloc.state.password,
        onChanged: _createStaffBloc.passwordInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintStaffPassword,
        labelStyle: Theme.of(context).textTheme.body1,
        obscureText: true,
        focusNode: _focusNodePassword,
      );

  Widget eventSelectionInput() {
    final eventBloc = BlocProvider.of<EventBloc>(context);
    return BlocBuilder<EventBloc, EventState>(
        bloc: eventBloc,
        condition: (prevState, newState) {
          return prevState.eventDataList != newState.eventDataList;
        },
        builder: (_, eventState) {
          return BlocBuilder<CreateStaffBloc, CreateStaffState>(
            bloc: _createStaffBloc,
            condition: (prevState, newState) {
              return prevState.selectedEvents != newState.selectedEvents;
            },
            builder: (_, state) {
              final events = eventState.upcomingEvents;
              return ListView.builder(
                  itemCount: events.length,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    final event = events[position];
                    return LabeledCheckbox(
                      onChanged: (value) {
                        if (value)
                          _createStaffBloc.addEventInput(event.id);
                        else
                          _createStaffBloc.removeEventInput(event.id);
                      },
                      value: state.selectedEvents?.contains(event.id) ?? false,
                      label: event.title,
                    );
                  });
            },
          );
        });
  }

  _pickDate(DateTime initialDate, Function dateHandler) async {
    DateTime pickedDate;

    if (isPlatformAndroid) {
      pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: initialDate,
        initialDate: initialDate,
      );
    } else {
      pickedDate = await _cupertinoPickDate(initialDate);
    }
    if (pickedDate != null) {
      dateHandler(pickedDate);
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<DateTime> _cupertinoPickDate(DateTime initialDate) async {
    final currentDate = DateTime.now();

    return await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          DateTime localPickedTime = initialDate;
          return SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text(AppLocalizations.of(context).btnCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoButton(
                        child: Text(AppLocalizations.of(context).btnConfirm),
                        onPressed: () {
                          Navigator.pop(context, localPickedTime);
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: initialDate,
                      onDateTimeChanged: (DateTime date) {
                        localPickedTime = date;
                      },
                      maximumDate: DateTime(DateTime.now().year + 20),
                      minimumDate: DateTime(
                          currentDate.year, currentDate.month, currentDate.day),
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  boxDecorationRectangle() => BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      );

  Future<void> _showStatesBottomSheet(Function handler) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          builder: (context) {
            return _buildMaterialSelectStateSheet(handler);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoSelectStateActionSheet(handler),
      );
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _buildMaterialSelectStateSheet(Function handler) {
    final states = _createStaffBloc.statesList;
    return statesList(states, handler);
  }

  Widget statesList(List<String> statesList, Function handler) {
    return ListView.builder(
        itemCount: statesList.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          final state = statesList[position];
          return InkWell(
              onTap: () {
                Navigator.pop(context);
                handler(state);
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
                      state,
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

  Widget _buildCupertinoSelectStateActionSheet(Function handler) {
    final states = _createStaffBloc.statesList;
    return CupertinoActionSheet(
      actions: states.map<Widget>((state) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            handler(state);
          },
          child: Text(
            state,
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
}
