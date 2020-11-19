import 'dart:io';

import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/ui/page/webview_page.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as Path;

class EventInfoPage extends StatefulWidget {
  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  Future _futureSystemPath;
  EventDetailBloc _eventDetailBloc;
  EventData _eventData;

  @override
  void initState() {
    super.initState();
    _eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);
    initSelectedEventData();
    _futureSystemPath = getSystemDirPath();
  }

  void initSelectedEventData() {
    _eventData = BlocProvider
        .of<EventBloc>(context)
        .state
        .eventDataList
        .firstWhere(
            (eventData) => eventData.id == _eventDetailBloc.selectedEventId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildBannerImage(),
        Expanded(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildEventTitle(),
                      const SizedBox(height: 4.0),
                      _buildEventTags(),
                      const Divider(),
                      _buildPriceAndDateRow(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(child: _buildDescriptionHead()),
                            _buildExpandIcon(),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Expanded(child: _buildDescriptionText()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBannerImage() =>
      FutureBuilder(
          future: _futureSystemPath,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SizedBox.shrink();
            else
              return isValid(_eventData.banner)
                  ? FadeInImage(
                width: double.infinity,
                height: 184,
                fit: BoxFit.cover,
                placeholder: AssetImage(placeholderImage),
                image: NetworkToFileImage(
                  url: _eventData.banner,
                  file: File(Path.join(
                      snapshot.data,
                      'Pictures',
                      _eventData.banner.substring(
                          _eventData.banner.lastIndexOf('/') + 1))),
                  debug: true,
                ),
              )
                  : Image.asset(
                placeholderImage,
                width: double.infinity,
                height: 224,
                fit: BoxFit.cover,
              );
          });

  Widget _buildEventTitle() {
    return Text(
      _eventData.title,
      style: Theme
          .of(context)
          .textTheme
          .title,
    );
  }

  Widget _buildEventTags() {
    return (_eventData.tags?.length ?? 0) > 0
        ? Wrap(
      spacing: 8.0,
      children: _eventData.tags.map((tag) {
        return Text(
          '# $tag',
          style:
          Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(fontSize: 12.0),
        );
      }).toList(),
    )
        : SizedBox.shrink();
  }

  Widget _buildPriceAndDateRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 1, child: _buildPriceOnwardsText()),
          const SizedBox(
              width: 56.0,
              height: 32.0,
              child: const VerticalDivider(
                color: Colors.black,
                indent: 4.0,
              )),
          Expanded(
            flex: 2,
            child: _buildStartEndDateText(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceOnwardsText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations
              .of(context)
              .ticketPrice,
          style: Theme
              .of(context)
              .textTheme
              .subtitle1
              .copyWith(fontSize: 14.0),
        ),
        Text(
          getMinTicketPrice(),
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  String getMinTicketPrice() {
    if ((_eventData.tickets?.length ?? 0) > 0) {
      Ticket minPriceTicket = _eventData.tickets[0];
      _eventData.tickets.forEach((ticket) {
        if ((ticket.price ?? 0) < (minPriceTicket.price ?? 0))
          minPriceTicket = ticket;
      });

      final currencyFormat = NumberFormat.simpleCurrency(
          name: isValid(minPriceTicket.currency)
              ? minPriceTicket.currency
              : 'USD',
          decimalDigits: (minPriceTicket.price?.isInt ?? false) ? 0 : null);
      return '${currencyFormat.format(
          minPriceTicket.price ?? 0)}\n${AppLocalizations
          .of(context)
          .labelPriceOnwards}';
    }
    return AppLocalizations
        .of(context)
        .notAvailable;
  }

  Widget _buildStartEndDateText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations
              .of(context)
              .startDateToEndDate,
          style: Theme
              .of(context)
              .textTheme
              .subtitle1
              .copyWith(fontSize: 14.0),
        ),
        Text(
          getStartEndDateText(),
          style: Theme
              .of(context)
              .textTheme
              .body1,
        ),
      ],
    );
  }

  String getStartEndDateText() {
    try {
      return '${DateFormat.yMMMd().add_jm().format(
          DateTime.parse(_eventData.startDateTime).toLocal())} - ${DateFormat
          .yMMMd().add_jm().format(
          DateTime.parse(_eventData.endDateTime).toLocal())}';
    } on Exception catch (e) {
      return AppLocalizations
          .of(context)
          .notAvailable;
    }
  }

  Widget _buildDescriptionHead() {
    return Text(
      AppLocalizations
          .of(context)
          .labelDescription,
      style: Theme
          .of(context)
          .textTheme
          .title,
    );
  }

  Widget _buildExpandIcon() {
    return IconButton(
      icon: Icon(Icons.zoom_out_map),
      onPressed: () {
        _showDescriptionDialog();
      },
    );
  }

  Widget _buildDescriptionText() {
    return WebViewPage(
      _eventData.description,
      raw: true,
    );
//      Html(
//      data: _eventData.description,
//      blacklistedElements: ['table'],
//    );
//      WebViewPage(
//      _eventData.description,
//      raw: true,
//      applyContentHeight: true,
//      mockNativeView: true,
//    );
  }

  void _showDescriptionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .9,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .9,
              child: WebViewPage(
                _eventData.description,
                raw: true,
              ),
            ),
          );
        });
  }
}
