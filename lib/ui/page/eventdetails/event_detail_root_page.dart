import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/page/eventdetails/attendee_list_page.dart';
import 'package:eventmanagement/ui/page/eventdetails/event_info_page.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventDetailRootPage extends StatefulWidget {
  @override
  _EventDetailRootPageState createState() => _EventDetailRootPageState();
}

class _EventDetailRootPageState extends State<EventDetailRootPage> {
  PageController _pageController;
  bool _showAttendee = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildTopBgContainer(),
          _buildDetailTypeRadioButton(),
          Expanded(child: _buildRootPageView()),
        ],
      ),
    );
  }

  Widget _buildTopBgContainer() {
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
                AppLocalizations.of(context).titleEventDetails,
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
                  onTap: () => setState(() {
                    _showAttendee = true;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        AppLocalizations.of(context).labelAddonTypePublic,
                        style: Theme.of(context)
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
                  onTap: () => setState(() {
                    _showAttendee = false;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        AppLocalizations.of(context).labelAddonTypePrivate,
                        style: Theme.of(context)
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
        controller: _pageController,
        onPageChanged: onPageChanged,
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (_, pos) {
          if (pos == 0)
            return AttendeeListPage();
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