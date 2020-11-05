import 'package:barcode_scan/barcode_scan.dart';
import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/carnivalist_icons_icons.dart';
import 'package:eventmanagement/ui/page/eventdetails/attendee_list_page.dart';
import 'package:eventmanagement/ui/page/eventdetails/event_info_page.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class EventDetailRootPage extends StatefulWidget {
  @override
  _EventDetailRootPageState createState() => _EventDetailRootPageState();
}

class _EventDetailRootPageState extends State<EventDetailRootPage>
    with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;
  PageController _pageController;
  bool _showAttendee = true,
      isEventStarted;
  EventDetailBloc _eventDetailBloc;

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (_hideFabAnimation.value == 0.0) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (_hideFabAnimation.value == 1.0) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _hideFabAnimation = AnimationController(
        vsync: this, duration: kThemeAnimationDuration, value: 1.0);
    _eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);
    _eventDetailBloc
        .authTokenSave(BlocProvider
        .of<UserBloc>(context)
        .state
        .authToken);
    _eventDetailBloc.getEventDetail();
    _pageController = PageController(initialPage: _showAttendee ? 0 : 1);
    initSelectedEventData();
  }

  void initSelectedEventData() {
    final eventData = BlocProvider
        .of<EventBloc>(context)
        .state
        .eventDataList
        .firstWhere(
            (eventData) => eventData.id == _eventDetailBloc.selectedEventId);

    final dateTimeNow = DateTime.now();

    print(
        'endDateTime--->${eventData.endDateTime}, startDateTime--->${eventData
            .startDateTime} ${dateTimeNow}');

    isEventStarted = isValid(eventData.endDateTime) &&
        DateTime.parse(eventData.endDateTime).isAfter(dateTimeNow) &&
        isValid(eventData.startDateTime) &&
        DateTime.parse(eventData.startDateTime).isBefore(dateTimeNow) &&
        eventData.status == 'ACTIVE';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ScaleTransition(
              scale: _hideFabAnimation, child: _buildScanQRCodeFAB()),
          const SizedBox(width: 16.0),
          ScaleTransition(
              scale: _hideFabAnimation, child: _buildScanNFCCodeFAB()),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildErrorReceiverEmptyBloc(),
              _buildTopBgContainer(),
              _buildDetailTypeRadioButton(),
              Expanded(child: _buildRootPageView()),
            ],
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildScanQRCodeFAB() {
    return FloatingActionButton(
      heroTag: 'Scan',
      child: Icon(CarnivalistIcons.qrcode, color: Colors.white),
      onPressed: () {
        if (isEventStarted)
          _scanQRCode();
        else
          context
              .toast(AppLocalizations
              .of(context)
              .labelEventDetailNotStarted);
      },
    );
  }

  FloatingActionButton _buildScanNFCCodeFAB() {
    return FloatingActionButton(
      heroTag: 'NFC',
      child: Icon(CarnivalistIcons.nfc, color: Colors.white),
      onPressed: () {
        if (isEventStarted)
          _scanNFCTag();
        else
          context
              .toast(AppLocalizations
              .of(context)
              .labelEventDetailNotStarted);
      },
    );
  }

  Future<void> _scanQRCode() async {
    try {
      String qrCode = await BarcodeScanner.scan();
      print("Scanned QR Code--->$qrCode");
      _uploadScannedTag(qrCode, false);
    } on FormatException catch (fe) {
      print(fe.message);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print("Camera Permission Denied");
      } else {
        print("Unknown Error: $ex");
      }
    } catch (ex) {
      print("Unknown Error: $ex");
    }
  }

  Future<void> _scanNFCTag() async {
    try {
      final nfcData = await FlutterNfcReader.read();
      if (nfcData.content != null && nfcData.content is String) {
        print("Scanned NFC Code--->${nfcData.content}");
        _uploadScannedTag(nfcData.content, true);
      } else {
        print("Scanned NFC Code Error--->${nfcData.error}");
        context.toast('NFC Code Scan Error--->${nfcData.error}');
      }
    } on PlatformException catch (ex) {
      print("Unknown Error: $ex");
      if (isValid(ex.message)) {
        context.toast(ex.message);
      }
    } catch (ex) {
      print("Unknown Error: $ex");
    }
  }

  void _uploadScannedTag(String tag, bool isNFC) {
    context.showProgress(context);
    _eventDetailBloc.uploadNewScannedTag(tag, isNFC, (response) {
      context.hideProgress(context);
    });
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<EventDetailBloc, EventDetailState>(
        cubit: _eventDetailBloc,
        buildWhen: (prevState, newState) => newState.uiMsg != null,
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

  Widget _buildTopBgContainer() {
    final eventData = BlocProvider
        .of<EventBloc>(context)
        .state
        .eventDataList
        .firstWhere(
            (eventData) => eventData.id == _eventDetailBloc.selectedEventId);

    return Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  icon: Icon(
                    isPlatformAndroid ? Icons.arrow_back : CupertinoIcons.back,
                    color: Theme.of(context).appBarTheme.iconTheme.color,
                  ),
                  onPressed: () async => Navigator.pop(context)),
            ),
            Center(
              child: Text(
                eventData.title,
                style: Theme.of(context).appBarTheme.textTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(headerBackgroundImage),
              fit: BoxFit.fitWidth,
            )));
  }

  Widget _buildDetailTypeRadioButton() => Container(
    decoration: BoxDecoration(
      color: bgColorButton,
      border: Border.all(
        color: bgColorButton,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    constraints: BoxConstraints(maxWidth: 208.0),
    margin: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_showAttendee) {
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);

                  setState(() {
                    _showAttendee = true;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .labelEventDetailAttendees,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                    color: _showAttendee ? colorTextButton : bgColorButton,
                    borderRadius: BorderRadius.all(
                        Radius.circular(_showAttendee ? 8.0 : 0.0))),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_showAttendee) {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);
                  setState(() {
                    _showAttendee = false;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .labelEventDetailDetails,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                    color: _showAttendee ? bgColorButton : colorTextButton,
                    borderRadius: BorderRadius.all(
                        Radius.circular(_showAttendee ? 0.0 : 4.0))),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildRootPageView() => PageView.builder(
    physics: NeverScrollableScrollPhysics(),
    controller: _pageController,
    onPageChanged: onPageChanged,
    scrollDirection: Axis.horizontal,
    itemCount: 2,
    itemBuilder: (_, pos) {
      if (pos == 0)
        return NotificationListener(
            onNotification: _handleScrollNotification,
            child: AttendeeListPage(isEventStarted));
      else
        return EventInfoPage();
    },
  );

  void onPageChanged(int page) {
    if (page == 0) {
      if (!_showAttendee)
        setState(() {
          _showAttendee = true;
        });
    } else {
      if (_showAttendee)
        setState(() {
          _showAttendee = false;
        });
    }
  }
}
