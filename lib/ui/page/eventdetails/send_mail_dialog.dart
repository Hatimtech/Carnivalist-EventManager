import 'package:eventmanagement/bloc/event/eventdetail/send_mail_bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/send_mail_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/coupons/coupon_response.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMailDialog extends StatefulWidget {
  @override
  createState() => _SendMailState();
}

class _SendMailState extends State<SendMailDialog> {
  SendMailBloc _sendMailBloc;

  final FocusNode _focusNodeSubject = FocusNode();
  final FocusNode _focusNodeFromName = FocusNode();
  final FocusNode _focusNodeCodeReplyTo = FocusNode();
  final FocusNode _focusNodeMessageBody = FocusNode();

  @override
  void initState() {
    super.initState();
    _sendMailBloc = BlocProvider.of<SendMailBloc>(context);
    _sendMailBloc
        .authTokenSave(BlocProvider.of<UserBloc>(context).state.authToken);
//    _sendMailBloc.createCouponDefault();
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
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildErrorReceiverEmptyBloc(),
            Text(AppLocalizations.of(context).labelSendAnnouncement,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.title),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context).labelSendAnnouncementSubject,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            mailSubjectInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelSendAnnouncementFromName,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            fromNameInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelSendAnnouncementReplyTo,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            replyToInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelSendAnnouncementMessage,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            mailMessageInput(),
            const SizedBox(height: 10.0),
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
                  onPressed: _sendMail,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnSend,
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

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<SendMailBloc, SendMailState>(
        cubit: _sendMailBloc,
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

  _sendMail() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);
    _sendMailBloc.sendMail((results) {
      context.hideProgress(context);
      if (results is CouponResponse) {
        if (results.code == apiCodeSuccess) {
          Navigator.pop(context);
        }
      }
    });
  }

  Widget mailSubjectInput() => widget.inputFieldRectangle(
        null,
        initialValue: _sendMailBloc.state.subject,
        textInputAction: TextInputAction.next,
        onChanged: _sendMailBloc.subjectInput,
        maxLength: 250,
        hintText: AppLocalizations.of(context).inputSendAnnouncementSubject,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeSubject,
        nextFocusNode: _focusNodeFromName,
      );

  Widget fromNameInput() => widget.inputFieldRectangle(
        null,
        initialValue: _sendMailBloc.state.fromName,
        textInputAction: TextInputAction.next,
        onChanged: _sendMailBloc.fromNameInput,
        maxLength: 250,
        hintText: AppLocalizations.of(context).inputSendAnnouncementFromName,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeFromName,
        nextFocusNode: _focusNodeCodeReplyTo,
      );

  Widget replyToInput() => widget.inputFieldRectangle(
        null,
        initialValue: _sendMailBloc.state.replyTo,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: _sendMailBloc.replyToInput,
        maxLength: 250,
        hintText: AppLocalizations.of(context).inputSendAnnouncementReplyTo,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeCodeReplyTo,
        nextFocusNode: _focusNodeMessageBody,
      );

  Widget mailMessageInput() => widget.inputFieldRectangle(
        null,
        initialValue: _sendMailBloc.state.message,
        onChanged: _sendMailBloc.messageInput,
        maxLength: 1500,
        maxLines: 5,
        hintText: AppLocalizations.of(context).inputSendAnnouncementMessage,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeMessageBody,
      );
}
