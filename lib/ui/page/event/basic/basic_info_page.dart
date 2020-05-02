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

//  String selectedCarnival, selectedTimeZone;
  List<String> timeZoneList = [
    '(+01:00) Europe/Andorra',
    '(+04:00) Asia/Dubai',
    '(+04:30) Asia/Kabul',
    '(+01:00) Europe/Tirane',
    '(+04:00) Asia/Yerevan',
    '(-03:00) Antarctica/Rothera',
    '(-03:00) Antarctica/Palmer',
    '(+05:00) Antarctica/Mawson',
    '(+07:00) Antarctica/Davis',
    '(+08:00) Antarctica/Casey',
    '(+06:00) Antarctica/Vostok',
    '(+10:00) Antarctica/DumontDUrville',
    '(+03:00) Antarctica/Syowa',
    '(+00:00) Antarctica/Troll',
    '(-03:00) America/Argentina/Buenos_Aires',
    '(-03:00) America/Argentina/Cordoba',
    '(-03:00) America/Argentina/Salta',
    '(-03:00) America/Argentina/Jujuy',
    '(-03:00) America/Argentina/Tucuman',
    '(-03:00) America/Argentina/Catamarca',
    '(-03:00) America/Argentina/La_Rioja',
    '(-03:00) America/Argentina/San_Juan',
    '(-03:00) America/Argentina/Mendoza',
    '(-03:00) America/Argentina/San_Luis',
    '(-03:00) America/Argentina/Rio_Gallegos',
    '(-03:00) America/Argentina/Ushuaia',
    '(-11:00) Pacific/Pago_Pago',
    '(+01:00) Europe/Vienna',
    '(+11:00) Australia/Lord_Howe',
    '(+11:00) Antarctica/Macquarie',
    '(+11:00) Australia/Hobart',
    '(+11:00) Australia/Currie',
    '(+11:00) Australia/Melbourne',
    '(+11:00) Australia/Sydney',
    '(+10:30) Australia/Broken_Hill',
    '(+10:00) Australia/Brisbane',
    '(+10:00) Australia/Lindeman',
    '(+10:30) Australia/Adelaide',
    '(+09:30) Australia/Darwin',
    '(+08:00) Australia/Perth',
    '(+08:45) Australia/Eucla',
    '(+04:00) Asia/Baku',
    '(-04:00) America/Barbados',
    '(+06:00) Asia/Dhaka',
    '(+01:00) Europe/Brussels',
    '(+02:00) Europe/Sofia',
    '(-04:00) Atlantic/Bermuda',
    '(+08:00) Asia/Brunei',
    '(-04:00) America/La_Paz',
    '(-02:00) America/Noronha',
    '(-03:00) America/Belem',
    '(-03:00) America/Fortaleza',
    '(-03:00) America/Recife',
    '(-03:00) America/Araguaina',
    '(-03:00) America/Maceio',
    '(-03:00) America/Bahia',
    '(-02:00) America/Sao_Paulo',
    '(-03:00) America/Campo_Grande',
    '(-03:00) America/Cuiaba',
    '(-03:00) America/Santarem',
    '(-04:00) America/Porto_Velho',
    '(-04:00) America/Boa_Vista',
    '(-04:00) America/Manaus',
    '(-05:00) America/Eirunepe',
    '(-05:00) America/Rio_Branco',
    '(-05:00) America/Nassau',
    '(+06:00) Asia/Thimphu',
    '(+03:00) Europe/Minsk',
    '(-06:00) America/Belize',
    '(-03:30) America/St_Johns',
    '(-04:00) America/Halifax',
    '(-04:00) America/Glace_Bay',
    '(-04:00) America/Moncton',
    '(-04:00) America/Goose_Bay',
    '(-04:00) America/Blanc-Sablon',
    '(-05:00) America/Toronto',
    '(-05:00) America/Nipigon',
    '(-05:00) America/Thunder_Bay',
    '(-05:00) America/Iqaluit',
    '(-05:00) America/Pangnirtung',
    '(-06:00) America/Resolute',
    '(-05:00) America/Atikokan',
    '(-06:00) America/Rankin_Inlet',
    '(-06:00) America/Winnipeg',
    '(-06:00) America/Rainy_River',
    '(-06:00) America/Regina',
    '(-06:00) America/Swift_Current',
    '(-07:00) America/Edmonton',
    '(-07:00) America/Cambridge_Bay',
    '(-07:00) America/Yellowknife',
    '(-07:00) America/Inuvik',
    '(-07:00) America/Creston',
    '(-07:00) America/Dawson_Creek',
    '(-07:00) America/Fort_Nelson',
    '(-08:00) America/Vancouver',
    '(-08:00) America/Whitehorse',
    '(-08:00) America/Dawson',
    '(+06:30) Indian/Cocos',
    '(+01:00) Europe/Zurich',
    '(+00:00) Africa/Abidjan',
    '(-10:00) Pacific/Rarotonga',
    '(-03:00) America/Santiago',
    '(-05:00) Pacific/Easter',
    '(+08:00) Asia/Shanghai',
    '(+06:00) Asia/Urumqi',
    '(-05:00) America/Bogota',
    '(-06:00) America/Costa_Rica',
    '(-05:00) America/Havana',
    '(-01:00) Atlantic/Cape_Verde',
    '(-04:00) America/Curacao',
    '(+07:00) Indian/Christmas',
    '(+02:00) Asia/Nicosia',
    '(+01:00) Europe/Prague',
    '(+01:00) Europe/Berlin',
    '(+01:00) Europe/Copenhagen',
    '(-04:00) America/Santo_Domingo',
    '(+01:00) Africa/Algiers',
    '(-05:00) America/Guayaquil',
    '(-06:00) Pacific/Galapagos',
    '(+02:00) Europe/Tallinn',
    '(+02:00) Africa/Cairo',
    '(+00:00) Africa/El_Aaiun',
    '(+01:00) Europe/Madrid',
    '(+01:00) Africa/Ceuta',
    '(+00:00) Atlantic/Canary',
    '(+02:00) Europe/Helsinki',
    '(+12:00) Pacific/Fiji',
    '(-03:00) Atlantic/Stanley',
    '(+10:00) Pacific/Chuuk',
    '(+11:00) Pacific/Pohnpei',
    '(+11:00) Pacific/Kosrae',
    '(+00:00) Atlantic/Faroe',
    '(+01:00) Europe/Paris',
    '(+00:00) Europe/London',
    '(+04:00) Asia/Tbilisi',
    '(-03:00) America/Cayenne',
    '(+00:00) Africa/Accra',
    '(+01:00) Europe/Gibraltar',
    '(-03:00) America/Godthab',
    '(+00:00) America/Danmarkshavn',
    '(-01:00) America/Scoresbysund',
    '(-04:00) America/Thule',
    '(+02:00) Europe/Athens',
    '(-02:00) Atlantic/South_Georgia',
    '(-06:00) America/Guatemala',
    '(+10:00) Pacific/Guam',
    '(+00:00) Africa/Bissau',
    '(-04:00) America/Guyana',
    '(+08:00) Asia/Hong_Kong',
    '(-06:00) America/Tegucigalpa',
    '(-05:00) America/Port-au-Prince',
    '(+01:00) Europe/Budapest',
    '(+07:00) Asia/Jakarta',
    '(+07:00) Asia/Pontianak',
    '(+08:00) Asia/Makassar',
    '(+09:00) Asia/Jayapura',
    '(+00:00) Europe/Dublin',
    '(+02:00) Asia/Jerusalem',
    '(+05:30) Asia/Kolkata',
    '(+06:00) Indian/Chagos',
    '(+03:00) Asia/Baghdad',
    '(+03:30) Asia/Tehran',
    '(+00:00) Atlantic/Reykjavik',
    '(+01:00) Europe/Rome',
    '(-05:00) America/Jamaica',
    '(+02:00) Asia/Amman',
    '(+09:00) Asia/Tokyo',
    '(+03:00) Africa/Nairobi',
    '(+06:00) Asia/Bishkek',
    '(+12:00) Pacific/Tarawa',
    '(+13:00) Pacific/Enderbury',
    '(+14:00) Pacific/Kiritimati',
    '(+08:30) Asia/Pyongyang',
    '(+09:00) Asia/Seoul',
    '(-05:00) America/Cayman',
    '(+06:00) Asia/Almaty',
    '(+06:00) Asia/Qyzylorda',
    '(+05:00) Asia/Aqtobe',
    '(+05:00) Asia/Aqtau',
    '(+05:00) Asia/Oral',
    '(+02:00) Asia/Beirut',
    '(+05:30) Asia/Colombo',
    '(+00:00) Africa/Monrovia',
    '(+02:00) Europe/Vilnius',
    '(+01:00) Europe/Luxembourg',
    '(+02:00) Europe/Riga',
    '(+02:00) Africa/Tripoli',
    '(+00:00) Africa/Casablanca',
    '(+01:00) Europe/Monaco',
    '(+02:00) Europe/Chisinau',
    '(+12:00) Pacific/Majuro',
    '(+12:00) Pacific/Kwajalein',
    '(+06:30) Asia/Rangoon',
    '(+08:00) Asia/Ulaanbaatar',
    '(+07:00) Asia/Hovd',
    '(+08:00) Asia/Choibalsan',
    '(+08:00) Asia/Macau',
    '(-04:00) America/Martinique',
    '(+01:00) Europe/Malta',
    '(+04:00) Indian/Mauritius',
    '(+05:00) Indian/Maldives',
    '(-06:00) America/Mexico_City',
    '(-05:00) America/Cancun',
    '(-06:00) America/Merida',
    '(-06:00) America/Monterrey',
    '(-06:00) America/Matamoros',
    '(-07:00) America/Mazatlan',
    '(-07:00) America/Chihuahua',
    '(-07:00) America/Ojinaga',
    '(-07:00) America/Hermosillo',
    '(-08:00) America/Tijuana',
    '(-08:00) America/Santa_Isabel',
    '(-06:00) America/Bahia_Banderas',
    '(+08:00) Asia/Kuala_Lumpur',
    '(+08:00) Asia/Kuching',
    '(+02:00) Africa/Maputo',
    '(+02:00) Africa/Windhoek',
    '(+11:00) Pacific/Noumea',
    '(+11:00) Pacific/Norfolk',
    '(+01:00) Africa/Lagos',
    '(-06:00) America/Managua',
    '(+01:00) Europe/Amsterdam',
    '(+01:00) Europe/Oslo',
    '(+05:45) Asia/Kathmandu',
    '(+12:00) Pacific/Nauru',
    '(-11:00) Pacific/Niue',
    '(+13:00) Pacific/Auckland',
    '(+13:45) Pacific/Chatham',
    '(-05:00) America/Panama',
    '(-05:00) America/Lima',
    '(-10:00) Pacific/Tahiti',
    '(-09:30) Pacific/Marquesas',
    '(-09:00) Pacific/Gambier',
    '(+10:00) Pacific/Port_Moresby',
    '(+11:00) Pacific/Bougainville',
    '(+08:00) Asia/Manila',
    '(+05:00) Asia/Karachi',
    '(+01:00) Europe/Warsaw',
    '(-03:00) America/Miquelon',
    '(-08:00) Pacific/Pitcairn',
    '(-04:00) America/Puerto_Rico',
    '(+02:00) Asia/Gaza',
    '(+02:00) Asia/Hebron',
    '(+00:00) Europe/Lisbon',
    '(+00:00) Atlantic/Madeira',
    '(-01:00) Atlantic/Azores',
    '(+09:00) Pacific/Palau',
    '(-03:00) America/Asuncion',
    '(+03:00) Asia/Qatar',
    '(+04:00) Indian/Reunion',
    '(+02:00) Europe/Bucharest',
    '(+01:00) Europe/Belgrade',
    '(+02:00) Europe/Kaliningrad',
    '(+03:00) Europe/Moscow',
    '(+03:00) Europe/Simferopol',
    '(+03:00) Europe/Volgograd',
    '(+04:00) Europe/Samara',
    '(+05:00) Asia/Yekaterinburg',
    '(+06:00) Asia/Omsk',
    '(+06:00) Asia/Novosibirsk',
    '(+07:00) Asia/Novokuznetsk',
    '(+07:00) Asia/Krasnoyarsk',
    '(+08:00) Asia/Irkutsk',
    '(+08:00) Asia/Chita',
    '(+09:00) Asia/Yakutsk',
    '(+09:00) Asia/Khandyga',
    '(+10:00) Asia/Vladivostok',
    '(+10:00) Asia/Sakhalin',
    '(+10:00) Asia/Ust-Nera',
    '(+10:00) Asia/Magadan',
    '(+11:00) Asia/Srednekolymsk',
    '(+12:00) Asia/Kamchatka',
    '(+12:00) Asia/Anadyr',
    '(+03:00) Asia/Riyadh',
    '(+11:00) Pacific/Guadalcanal',
    '(+04:00) Indian/Mahe',
    '(+03:00) Africa/Khartoum',
    '(+01:00) Europe/Stockholm',
    '(+08:00) Asia/Singapore',
    '(-03:00) America/Paramaribo',
    '(-06:00) America/El_Salvador',
    '(+02:00) Asia/Damascus',
    '(-04:00) America/Grand_Turk',
    '(+01:00) Africa/Ndjamena',
    '(+05:00) Indian/Kerguelen',
    '(+07:00) Asia/Bangkok',
    '(+05:00) Asia/Dushanbe',
    '(+13:00) Pacific/Fakaofo',
    '(+09:00) Asia/Dili',
    '(+05:00) Asia/Ashgabat',
    '(+01:00) Africa/Tunis',
    '(+13:00) Pacific/Tongatapu',
    '(+02:00) Europe/Istanbul',
    '(-04:00) America/Port_of_Spain',
    '(+12:00) Pacific/Funafuti',
    '(+08:00) Asia/Taipei',
    '(+02:00) Europe/Kiev',
    '(+02:00) Europe/Uzhgorod',
    '(+02:00) Europe/Zaporozhye',
    '(+12:00) Pacific/Wake',
    '(-05:00) America/New_York',
    '(-05:00) America/Detroit',
    '(-05:00) America/Kentucky/Louisville',
    '(-05:00) America/Kentucky/Monticello',
    '(-05:00) America/Indiana/Indianapolis',
    '(-05:00) America/Indiana/Vincennes',
    '(-05:00) America/Indiana/Winamac',
    '(-05:00) America/Indiana/Marengo',
    '(-05:00) America/Indiana/Petersburg',
    '(-05:00) America/Indiana/Vevay',
    '(-06:00) America/Chicago',
    '(-06:00) America/Indiana/Tell_City',
    '(-06:00) America/Indiana/Knox',
    '(-06:00) America/Menominee',
    '(-06:00) America/North_Dakota/Center',
    '(-06:00) America/North_Dakota/New_Salem',
    '(-06:00) America/North_Dakota/Beulah',
    '(-07:00) America/Denver',
    '(-07:00) America/Boise',
    '(-07:00) America/Phoenix',
    '(-08:00) America/Los_Angeles',
    '(-08:00) America/Metlakatla',
    '(-09:00) America/Anchorage',
    '(-09:00) America/Juneau',
    '(-09:00) America/Sitka',
    '(-09:00) America/Yakutat',
    '(-09:00) America/Nome',
    '(-10:00) America/Adak',
    '(-10:00) Pacific/Honolulu',
    '(-03:00) America/Montevideo',
    '(+05:00) Asia/Samarkand',
    '(+05:00) Asia/Tashkent',
    '(-04:30) America/Caracas',
    '(+07:00) Asia/Ho_Chi_Minh',
    '(+11:00) Pacific/Efate',
    '(+12:00) Pacific/Wallis',
    '(+14:00) Pacific/Apia',
    '(+02:00) Africa/Johannesburg'
  ];

  @override
  void initState() {
    super.initState();
    print('_BasicInfoPageState: initState');
    _basicBloc = BlocProvider.of<BasicBloc>(context);
    _basicBloc.carnival();
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
        initialValue: _basicBloc.state.eventName,
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
            return _timeZonelist(timeZoneList);
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
      actions: timeZoneList.map<Widget>((timezone) {
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
              : eventTypeList(snapshot.eventTypeList);
        });
  }

  Widget _buildCupertinoEventTypeActionSheet() {
    return BlocBuilder<BasicBloc, BasicState>(
        condition: (prevState, newState) =>
            prevState.eventTypeList != newState.eventTypeList ||
            prevState.eventTypeList.length != newState.eventTypeList.length,
        bloc: _basicBloc,
        builder: (context, BasicState snapshot) => snapshot.loading
            ? Container(
                alignment: FractionalOffset.center,
                child: CupertinoActivityIndicator())
            : CupertinoActionSheet(
                actions: snapshot.eventTypeList.map<Widget>((carnival) {
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      _basicBloc.eventTypeInput(carnival.category);
                      print(carnival.category);
                    },
                    child: Text(
                      carnival.category,
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
              ));
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
