import 'dart:async';

import 'package:eventmanagement/bloc/event/event/event_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/event_detail_state.dart';
import 'package:eventmanagement/bloc/event/eventdetail/send_mail_bloc.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/eventdetails/event_detail.dart';
import 'package:eventmanagement/model/eventdetails/user_detail.dart';
import 'package:eventmanagement/ui/page/eventdetails/send_mail_dialog.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendeeListPage extends StatefulWidget {
  final bool isEventStarted;

  const AttendeeListPage(this.isEventStarted);

  @override
  _AttendeeListPageState createState() => _AttendeeListPageState();
}

class _AttendeeListPageState extends State<AttendeeListPage>
    with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;
  UserBloc _userBloc;
  EventDetailBloc _eventDetailBloc;
  EventData _eventData;

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
    _userBloc = BlocProvider.of<UserBloc>(context);
    _eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);
    initSelectedEventData();
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
    return BlocBuilder<EventDetailBloc, EventDetailState>(
        cubit: _eventDetailBloc,
        buildWhen: (prevState, newState) {
          return (prevState.loading != newState.loading) ||
              (prevState.eventDetailList != newState.eventDetailList ||
                  prevState.eventDetailList.length !=
                      newState.eventDetailList.length ||
                  prevState.currentFilter != newState.currentFilter);
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _attendeesList(state.eventDetailListByFilter),
              if (state.loading) const PlatformProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ScaleTransition(
                    scale: _hideFabAnimation,
                    child: FloatingActionButton(
                        child: Icon(Icons.filter_list, color: Colors.white),
                        onPressed: _showFilterBottomSheet),
                  ),
                ),
              )
            ],
          );
        });
  }

  _attendeesList(List<EventDetail> eventDetailList) =>
      PlatformScrollbar(
        child: RefreshIndicator(
          onRefresh: () async {
            Completer<bool> downloadCompleter = Completer();
            _eventDetailBloc.getEventDetail(
                downloadCompleter: downloadCompleter);
            return downloadCompleter.future;
          },
          child: NotificationListener(
              onNotification: _handleScrollNotification,
              child: _buildEventDetailList(eventDetailList)),
        ),
      );

  Widget _buildEventDetailList(List<EventDetail> eventDetailList) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        itemCount: eventDetailList.length,
        itemBuilder: (context, position) {
          return _buildEventDetailListItem(eventDetailList[position]);
        });
  }

  Widget _buildEventDetailListItem(EventDetail eventDetail) {
    final user =
    (eventDetail.user?.length ?? 0) > 0 ? eventDetail.user[0] : null;
    final paymentResponse = eventDetail.paymentResponse;
    int ticketCount = 0;
    eventDetail.tickets?.forEach((ticket) {
      ticketCount += (ticket.noOfTicket ?? 0);
    });
    String paymentStatus;
    String txnAmount = AppLocalizations
        .of(context)
        .notAvailable;
    if (paymentResponse?.txnStatus == 'TXN_SUCCESS') {
      paymentStatus =
          AppLocalizations
              .of(context)
              .labelEventDetailStatusSuccess;

      if (paymentResponse.txnAmount != null)
        txnAmount = paymentResponse.txnAmount.toString();
    } else {
      paymentStatus = AppLocalizations
          .of(context)
          .labelEventDetailStatusFailed;
    }
    String date = eventDetail.createdAt != null
        ? DateFormat.yMMMd().format(eventDetail.createdAt)
        : AppLocalizations
        .of(context)
        .notAvailable;
    return GestureDetector(
      onTap: () => showAttendeesActions(eventDetail),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 84.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VerticalDivider(
                thickness: 6,
                width: 6,
                color: (eventDetail.isEventAttended ?? false)
                    ? colorActive
                    : Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: _buildUserInfoView(user),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: _buildEventInfoView(
                    ticketCount, paymentStatus, txnAmount, date),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoView(UserDetail user) {
    if (user != null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user?.name ?? AppLocalizations
                .of(context)
                .notAvailable,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            user?.username ?? AppLocalizations
                .of(context)
                .notAvailable,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            user?.mobileNumber ?? AppLocalizations
                .of(context)
                .notAvailable,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(
              fontSize: 12.0,
            ),
          ),
        ],
      );
    else
      return SizedBox.shrink();
  }

  Widget _buildEventInfoView(int ticketCount, String paymentStatus,
      String txnAmount, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          '\$$txnAmount',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '${AppLocalizations
              .of(context)
              .labelEventDetailTicket} $ticketCount',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(
            fontSize: 12.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          children: <Widget>[
            Text(
              date,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              paymentStatus,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: paymentStatus ==
                    AppLocalizations
                        .of(context)
                        .labelEventDetailStatusSuccess
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> showAttendeesActions(EventDetail eventDetail) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          builder: (context) {
            return _buildMaterialAttendeesActionSheet(eventDetail);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoAttendessActionSheet(eventDetail),
      );
    }
  }

  Widget _buildMaterialAttendeesActionSheet(EventDetail eventDetail) =>
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildMaterialFieldAction(
            AppLocalizations
                .of(context)
                .labelAttendeesResendTicket,
                () =>
                _resendTicket(
                    eventDetail.id ?? '',
                    (eventDetail.user?.length ?? 0) > 0
                        ? eventDetail.user[0].username
                        : ''),
            showDivider: true,
          ),
          _buildMaterialFieldAction(
            AppLocalizations
                .of(context)
                .labelAttendeesSendMail,
                () {
              final userDetail = (eventDetail.user?.length ?? 0) > 0
                  ? eventDetail.user[0]
                  : null;
              _sendMail(
                _eventData?.title ?? '',
                userDetail?.username ?? '',
                _userBloc.state.userName,
                _userBloc.state.email,
              );
            },
            showDivider: widget.isEventStarted &&
                (eventDetail.isEventAttended != null
                    ? !eventDetail.isEventAttended
                    : true),
          ),
          if (widget.isEventStarted &&
              (eventDetail.isEventAttended != null
                  ? !eventDetail.isEventAttended
                  : true))
            _buildMaterialFieldAction(
              AppLocalizations
                  .of(context)
                  .labelAttendeesMarkAttended,
                  () {
                context.showProgress(context);
                _eventDetailBloc.uploadNewScannedTag(eventDetail.id, false,
                        (response) {
                      context.hideProgress(context);
                    });
              },
              showDivider: false,
            ),
        ],
      );

  Widget _buildMaterialFieldAction(String name, Function handler,
      {bool showDivider = true}) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler();
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
                name,
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
            if (showDivider) const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoAttendessActionSheet(EventDetail eventDetail) {
    return CupertinoActionSheet(
      actions: [
        _buildCupertinoCouponAction(
          AppLocalizations
              .of(context)
              .labelAttendeesResendTicket,
              () =>
              () =>
              _resendTicket(
                  eventDetail.id ?? '',
                  (eventDetail.user?.length ?? 0) > 0
                      ? eventDetail.user[0].username
                      : ''),
        ),
        _buildCupertinoCouponAction(
            AppLocalizations
                .of(context)
                .labelAttendeesSendMail, () {
          final userDetail =
          (eventDetail.user?.length ?? 0) > 0 ? eventDetail.user[0] : null;
          _sendMail(
            _eventData?.title ?? '',
            userDetail?.username ?? '',
            _userBloc.state.userName,
            _userBloc.state.email,
          );
        }),
        if (eventDetail.isEventAttended != null
            ? !eventDetail.isEventAttended
            : true)
          _buildCupertinoCouponAction(
              AppLocalizations
                  .of(context)
                  .labelAttendeesMarkAttended, () {
            context.showProgress(context);
            _eventDetailBloc.uploadNewScannedTag(eventDetail.id, false,
                    (response) {
                  context.hideProgress(context);
                });
          }),
      ],
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
    );
  }

  Widget _buildCupertinoCouponAction(String name, Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler();
      },
      child: Text(
        name,
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
  }

  void _resendTicket(String orderId, String email) {
    context.showProgress(context);
    _eventDetailBloc.attendeesResendTicket(orderId, email, (response) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context.hideProgress(context);
      });
    });
  }

  void _sendMail(String eventName, String email, String fromName,
      String replyTo) {
    final announcementForLabel =
        AppLocalizations
            .of(context)
            .labelAnnouncementFor;
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          BlocProvider(
            create: (context) =>
                SendMailBloc(
                  announcement: false,
                  eventName: eventName,
                  emails: email.split(''),
                  subject: '$announcementForLabel $eventName',
                  fromName: fromName,
                  replyTo: replyTo,
                ),
            child: SendMailDialog(),
          ),
    );
  }

  void _showFilterBottomSheet() {
    if (isPlatformAndroid)
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          builder: (context) {
            return _buildFilterView();
          });
    else
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: _buildFilterView());
          });
  }

  Widget _buildFilterView() {
    int selectedFilter = 0;

    if (_eventDetailBloc.state.currentFilter.value ==
        _eventDetailBloc.state.attendeesFilterType[0].value)
      selectedFilter = 1;
    else if (_eventDetailBloc.state.currentFilter.value ==
        _eventDetailBloc.state.attendeesFilterType[1].value)
      selectedFilter = 2;
    else if (_eventDetailBloc.state.currentFilter.value ==
        _eventDetailBloc.state.attendeesFilterType[2].value) selectedFilter = 3;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppLocalizations
                .of(context)
                .labelAttendeesFilter,
            style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.w500),
          ),
          _buildFilterItem(
            AppLocalizations
                .of(context)
                .labelAttendeesFilterAll,
            selectedFilter == 1,
                () {
              Navigator.pop(context);
              _eventDetailBloc.updateCurrentAttendeesFilter(
                  _eventDetailBloc.state.attendeesFilterType[0]);
            },
          ),
          _buildFilterItem(
            AppLocalizations
                .of(context)
                .labelAttendeesFilterAttended,
            selectedFilter == 2,
                () {
              Navigator.pop(context);
              _eventDetailBloc.updateCurrentAttendeesFilter(
                  _eventDetailBloc.state.attendeesFilterType[1]);
            },
          ),
          _buildFilterItem(
            AppLocalizations
                .of(context)
                .labelAttendeesFilterPending,
            selectedFilter == 3,
                () {
              Navigator.pop(context);
              _eventDetailBloc.updateCurrentAttendeesFilter(
                  _eventDetailBloc.state.attendeesFilterType[2]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String label, bool isSelected, Function handler) {
    return GestureDetector(
      onTap: handler,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme
                    .of(context)
                    .textTheme
                    .body1
                    .copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                    color: isSelected ? colorActive : null),
              ),
            ),
            Icon(
              Icons.check,
              color: isSelected ? colorActive : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
