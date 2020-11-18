import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/basic/basic_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/ui/widget/custom_dropdown.dart' as CustomDD;
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventDateTimeInfoPage extends StatefulWidget {
  @override
  _EventDateTimeInfoPageState createState() => _EventDateTimeInfoPageState();
}

class _EventDateTimeInfoPageState extends State<EventDateTimeInfoPage> {
  BasicBloc _basicBloc;
  final _weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  void initState() {
    super.initState();
    _basicBloc = BlocProvider.of<BasicBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventDateTimeInfo();
  }

  Widget _buildEventDateTimeInfo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).titleEventDate,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.title),
          Container(
              child: BlocBuilder<BasicBloc, BasicState>(
                buildWhen: (prevState, newState) =>
            prevState.eventFreqName != newState.eventFreqName,
                cubit: _basicBloc,
            builder: (context, BasicState state) => Column(
              children: <Widget>[
                _buildEventDateTypeSelector(
                    state.eventFreqName, state.eventFreqList),
                if (state.eventFreqName == 'Once') _buildEventDateTypeOnce(),
                if (state.eventFreqName == 'Daily') _buildEventDateTypeDaily(),
                if (state.eventFreqName == 'Weekly')
                  _buildEventDateTypeWeekly(),
                if (state.eventFreqName == 'Custom')
                  _buildEventDateTypeCustom(),
              ],
            ),
          )),
        ]);
  }

  Widget _buildEventDateTypeSelector(
      String selectedMenu, List<MenuCustom> eventDateMenus) {
    return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: HexColor('#EEEEEF'),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Row(
            children: eventDateMenus.map((data) {
          return Expanded(
              child: GestureDetector(
                  onTap: () {
                    _basicBloc.selectEventFrequency(data.name);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: selectedMenu == data.name
                              ? bgColorButton
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(8),
                      child: Text(uiValueEventDate(data.name),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontSize: 12.0)))));
        }).toList()));
  }

  String uiValueEventDate(String value) {
    switch (value) {
      case 'Once':
        return AppLocalizations.of(context).labelEventOnce;
      case 'Daily':
        return AppLocalizations.of(context).labelEventDaily;
      case 'Weekly':
        return AppLocalizations.of(context).labelEventWeekly;
      case 'Custom':
        return AppLocalizations.of(context).labelEventCustom;
    }
  }

  Widget _buildEventDateTypeOnce() {
    return _buildEventStartEndDate();
  }

  Widget _buildEventDateTypeDaily() {
    return _buildEventStartEndDate();
  }

  Widget _buildEventDateTypeWeekly() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(AppLocalizations.of(context).labelEventDay,
            style: Theme.of(context).textTheme.body2),
        const SizedBox(height: 4.0),
        _buildWeeklyDropdown(),
        const SizedBox(height: 10.0),
        _buildEventStartEndDate(),
      ],
    );
  }

  Widget _buildEventDateTypeCustom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildEventStartEndDate(),
        const SizedBox(height: 10.0),
        _buildAddDateButton(),
        const SizedBox(height: 10.0),
        _buildCustomDateTimeChips(),
      ],
    );
  }

  Widget _buildEventStartEndDate() {
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).labelStartDate,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body2),
                    const SizedBox(height: 4.0),
                    _eventStartDateInput(),
                  ])),
          const SizedBox(width: 10.0),
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).labelStartTime,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body2),
                    const SizedBox(height: 4.0),
                    _eventStartTimeInput(),
                  ])),
          Expanded(flex: 1, child: const SizedBox(width: 10.0))
        ]),
        const SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).labelEndDate,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body2),
                    const SizedBox(height: 4.0),
                    _eventEndDateInput(),
                  ])),
          const SizedBox(width: 10.0),
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).labelEndTime,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body2),
                    const SizedBox(height: 4.0),
                    _eventEndTimeInput(),
                  ])),
          Expanded(flex: 1, child: const SizedBox(width: 10.0))
        ])
      ],
    );
  }

  _eventStartDateInput() => BlocBuilder<BasicBloc, BasicState>(
      buildWhen: (prevState, newState) =>
          prevState.eventStartDate != newState.eventStartDate,
      cubit: _basicBloc,
      builder: (BuildContext context, BasicState state) {
        return InkWell(
          onTap: () =>
              _pickDate(DateTime.now(), _basicBloc.eventStartDateInput),
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 3.0),
            decoration: boxDecorationRectangle(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _basicBloc.state.eventStartDate != null
                    ? DateFormat.yMMMMd()
                        .format(_basicBloc.state.eventStartDate)
                    : AppLocalizations.of(context).inputHintDate,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color: _basicBloc.state.eventStartDate != null
                        ? null
                        : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
      });

  _eventStartTimeInput() => BlocBuilder<BasicBloc, BasicState>(
      buildWhen: (prevState, newState) =>
          prevState.eventStartTime != newState.eventStartTime,
      cubit: _basicBloc,
      builder: (BuildContext context, BasicState state) {
        return InkWell(
          onTap: () {
            final currentDateTime = DateTime.now();
            _pickTime(
                TimeOfDay(
                    hour: currentDateTime.hour, minute: currentDateTime.minute),
                _basicBloc.eventStartTimeInput);
          },
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 3.0),
            decoration: boxDecorationRectangle(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _basicBloc.state.eventStartTime != null
                    ? MaterialLocalizations.of(context)
                        .formatTimeOfDay(_basicBloc.state.eventStartTime)
                    : AppLocalizations.of(context).inputHintTime,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color: _basicBloc.state.eventStartTime != null
                        ? null
                        : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
//        return widget.inputFieldRectangle(context, _eventStartTimeController,
//              onChanged: _basicBloc.eventStartTimeInput,
//              hintText: AppLocalizations.of(context).inputHintTime,
//              labelStyle: Theme.of(context).textTheme.body1);
      });

  _eventEndDateInput() => BlocBuilder<BasicBloc, BasicState>(
      buildWhen: (prevState, newState) =>
          prevState.eventEndDate != newState.eventEndDate,
      cubit: _basicBloc,
      builder: (BuildContext context, BasicState state) {
        return InkWell(
          onTap: () => _pickDate(DateTime.now(), _basicBloc.eventEndDateInput),
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 3.0),
            decoration: boxDecorationRectangle(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _basicBloc.state.eventEndDate != null
                    ? DateFormat.yMMMMd().format(_basicBloc.state.eventEndDate)
                    : AppLocalizations.of(context).inputHintDate,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color: _basicBloc.state.eventEndDate != null
                        ? null
                        : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
//        return widget.inputFieldRectangle(context, _eventEventEndDateController,
//              onChanged: _basicBloc.eventEndDateInput,
//              hintText: AppLocalizations.of(context).inputHintDate,
//              labelStyle: Theme.of(context).textTheme.body1);
      });

  _eventEndTimeInput() => BlocBuilder<BasicBloc, BasicState>(
      buildWhen: (prevState, newState) =>
          prevState.eventEndTime != newState.eventEndTime,
      cubit: _basicBloc,
      builder: (BuildContext context, BasicState state) {
        return InkWell(
          onTap: () {
            final currentDateTime = DateTime.now();
            _pickTime(
                TimeOfDay(
                    hour: currentDateTime.hour, minute: currentDateTime.minute),
                _basicBloc.eventEndTimeInput);
          },
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 3.0),
            decoration: boxDecorationRectangle(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _basicBloc.state.eventEndTime != null
                    ? MaterialLocalizations.of(context)
                        .formatTimeOfDay(_basicBloc.state.eventEndTime)
                    : AppLocalizations.of(context).inputHintTime,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color: _basicBloc.state.eventEndTime != null
                        ? null
                        : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
//        return widget.inputFieldRectangle(context, _eventEventEndTimeController,
//              onChanged: _basicBloc.eventEndTimeInput,
//              hintText: AppLocalizations.of(context).inputHintTime,
//              labelStyle: Theme.of(context).textTheme.body1);
      });

  _pickDate(DateTime initialDate, Function dateHandler) async {
    DateTime pickedDate;

    if (isPlatformAndroid) {
      final currentDate = DateTime.now();

      pickedDate = await showDatePicker(
        context: context,
        firstDate:
            DateTime(currentDate.year, currentDate.month, currentDate.day),
        lastDate: DateTime(DateTime.now().year + 20),
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

  _pickTime(TimeOfDay initialTime, Function timeHandler) async {
    TimeOfDay pickedTime;

    if (isPlatformAndroid) {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
    } else {
      pickedTime = await _cupertinoPickTime(initialTime);
    }
    if (pickedTime != null) {
      timeHandler(pickedTime);
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<TimeOfDay> _cupertinoPickTime(TimeOfDay initialTime) async {
    final currentDate = DateTime.now();

    return await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          DateTime localPickedTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            initialTime.hour,
            initialTime.minute,
          );
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
                          Navigator.pop(
                              context,
                              TimeOfDay(
                                  hour: localPickedTime.hour,
                                  minute: localPickedTime.minute));
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: localPickedTime,
                      onDateTimeChanged: (DateTime date) {
                        localPickedTime = date;
                      },
                      maximumDate: DateTime(DateTime.now().year + 20),
                      minimumDate: DateTime(
                          currentDate.year, currentDate.month, currentDate.day),
                      minuteInterval: 1,
                      mode: CupertinoDatePickerMode.time,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildWeeklyDropdown() {
    return BlocBuilder<BasicBloc, BasicState>(
      buildWhen: (prevState, newState) =>
          prevState.eventWeekday != newState.eventWeekday,
      cubit: _basicBloc,
      builder: (_, state) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              child: CustomDD.DropdownButton<String>(
                iconSize: 0.0,
                underline: const SizedBox(
                  width: 0,
                  height: 0,
                ),
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppLocalizations.of(context).labelEventDay,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Theme.of(context).hintColor)),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return _weekDays.map((String value) {
                    return Text(uiLabelWeekday(value, context),
                        style: Theme.of(context).textTheme.body1);
                  }).toList();
                },
                items: _weekDays.map((String value) {
                  return CustomDD.DropdownMenuItem<String>(
                    value: value,
                    child: Text(uiLabelWeekday(value, context),
                        style: Theme.of(context).textTheme.body1),
                  );
                }).toList(),
                value: _basicBloc.state.eventWeekday,
                onChanged: (value) {
                  _basicBloc.eventWeekdayInput(value);
                },
              ),
            ),
            Positioned(
              right: 16.0,
              child: Icon(Icons.arrow_drop_down),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddDateButton() {
    return RaisedButton(
      onPressed: () {
        _basicBloc.eventAddCustomDate();
      },
      padding: EdgeInsets.all(12.0),
      child: Text(
        AppLocalizations.of(context).labelEventCustomButton,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }

  Widget _buildCustomDateTimeChips() {
    return BlocBuilder<BasicBloc, BasicState>(
        buildWhen: (prevState, newState) {
          print(
              'prevState.eventCustomDateTimeList ${prevState.eventCustomDateTimeList}');
          print(
              'newState.eventCustomDateTimeList ${newState.eventCustomDateTimeList}');
          return prevState.eventCustomDateTimeList !=
                  newState.eventCustomDateTimeList ||
              prevState.eventCustomDateTimeList.length !=
                  newState.eventCustomDateTimeList.length;
        },
        cubit: _basicBloc,
        builder: (BuildContext context, state) {
          print('_buildCustomDateTimeChips builder');
          final dateFormat = DateFormat.yMMMd().add_jm();
          return Wrap(
            children:
                state.eventCustomDateTimeList.map<Widget>((customDateTime) {
              return Chip(
                label: Text(
                  '${dateFormat.format(customDateTime.eventStartDateTime)} - ${dateFormat.format(customDateTime.eventEndDateTime)}',
                  style: Theme.of(context).textTheme.body2,
                ),
                onDeleted: () {
                  _basicBloc.eventRemoveCustomDate(customDateTime);
                },
              );
            }).toList(),
          );
        });
  }

  boxDecorationRectangle() => BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      );
}
