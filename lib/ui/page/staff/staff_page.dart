import 'dart:async';

import 'package:eventmanagement/bloc/staff/create/create_staff_bloc.dart';
import 'package:eventmanagement/bloc/staff/staff_bloc.dart';
import 'package:eventmanagement/bloc/staff/staff_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/staff/staff.dart';
import 'package:eventmanagement/ui/page/staff/create_staff_dialog.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({Key key}) : super(key: key);

  @override
  createState() => _StaffState();
}

class _StaffState extends State<StaffPage> with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;
  StaffBloc _staffBloc;

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hideFabAnimation = AnimationController(
        vsync: this, duration: kThemeAnimationDuration, value: 1.0);
    _staffBloc = BlocProvider.of<StaffBloc>(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScaleTransition(
        scale: _hideFabAnimation,
        child: FloatingActionButton(
          heroTag: "FAB",
          backgroundColor: bgColorFAB,
          onPressed: _onCreateStaffButtonClicked,
          child: Icon(
            Icons.add,
            size: 48.0,
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: _handleScrollNotification,
        child: Column(children: <Widget>[
          _buildErrorReceiverEmptyBloc(),
          Expanded(
              child: BlocBuilder<StaffBloc, StaffState>(
                  bloc: _staffBloc,
                  condition: (prevState, newState) {
                    return (prevState.loading != newState.loading) ||
                        (prevState.staffs != newState.staffs ||
                            prevState.staffs.length != newState.staffs.length);
                  },
                  builder: (context, StaffState state) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        staffs(state.staffs),
                        if (state.loading) const PlatformProgressIndicator(),
                      ],
                    );
                  })),
        ]),
      ),
    );
  }

  Widget _buildErrorReceiverEmptyBloc() => BlocBuilder<StaffBloc, StaffState>(
        bloc: _staffBloc,
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

  staffs(List<Staff> staffs) => PlatformScrollbar(
        child: RefreshIndicator(
          onRefresh: () async {
            Completer<bool> downloadCompleter = Completer();
            _staffBloc.getAllStaffs(downloadCompleter: downloadCompleter);
            return downloadCompleter.future;
          },
          child: _buildStaffList(staffs),
        ),
      );

  Widget _buildStaffList(List<Staff> staffs) {
    return ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: staffs.length,
        itemBuilder: (context, position) {
          Staff currentStaff = staffs[position];
          return GestureDetector(
            onTap: () {
              showStaffActions(currentStaff);
            },
            child: _buildStaffListItem(staffs[position]),
          );
        });
  }

  Widget _buildStaffListItem(Staff staff) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 78.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            VerticalDivider(
              thickness: 6,
              width: 6,
              color: (staff.isDisabled ?? false) ? colorInactive : colorActive,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0,),
                child: _buildUserInfoView(
                  staff.name ?? '--',
                  staff.username ?? '--',
                  staff.email ?? '--',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoView(String name, String username, String email) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            '${AppLocalizations
                .of(context)
                .labelStaffUsernameView}$username',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: 12.0,
            ),
          ),
          Text(
            '${AppLocalizations
                .of(context)
                .labelStaffEmailView}$email',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: 12.0,
            ),
          ),
        ]);
  }

  Future<void> showStaffActions(Staff staff) async {
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
            return _buildMaterialStaffActionSheet(staff);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoStaffActionSheet(staff),
      );
    }
  }

  Widget _buildMaterialStaffActionSheet(Staff staff) => ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildMaterialFieldAction(
            AppLocalizations.of(context).labelEditStaff,
            () {
              _onCreateStaffButtonClicked(staffId: staff.id);
            },
            showDivider: true,
          ),
          _buildMaterialFieldAction(
            (staff.isDisabled ?? false)
                ? AppLocalizations.of(context).labelActiveStaff
                : AppLocalizations.of(context).labelInActiveStaff,
            () => activeInactiveStaff(staff),
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
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: colorTextAction,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (showDivider) const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoStaffActionSheet(Staff staff) {
    return CupertinoActionSheet(
      actions: [
        _buildCupertinoStaffAction(
          AppLocalizations.of(context).labelEditStaff,
          () {
            _onCreateStaffButtonClicked(staffId: staff.id);
          },
        ),
        _buildCupertinoStaffAction(
            (staff.isDisabled ?? false)
                ? AppLocalizations.of(context).labelActiveStaff
                : AppLocalizations.of(context).labelInActiveStaff,
            () => activeInactiveStaff(staff)),
      ],
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

  Widget _buildCupertinoStaffAction(String name, Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler();
      },
      child: Text(
        name,
        style: Theme.of(context).textTheme.subtitle.copyWith(
              color: colorTextAction,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void activeInactiveStaff(Staff staff) {
    context.showProgress(context);
    _staffBloc.activeInactiveStaff(staff.id, !(staff.isDisabled ?? false),
        (response) {
      context.hideProgress(context);
    });
  }

  void _onCreateStaffButtonClicked({String staffId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => BlocProvider(
        create: (context) => CreateStaffBloc(
          _staffBloc,
          staffId: staffId,
        ),
        child: CreateStaffDialog(),
      ),
    );
  }
}
