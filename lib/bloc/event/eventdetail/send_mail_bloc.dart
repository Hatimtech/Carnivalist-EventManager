import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/event/eventdetail/send_mail_event.dart';
import 'package:eventmanagement/bloc/event/eventdetail/send_mail_state.dart';
import 'package:eventmanagement/model/eventdetails/send_mail_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class SendMailBloc extends Bloc<SendMailEvent, SendMailState> {
  final ApiProvider apiProvider = ApiProvider();
  final bool announcement;
  final String eventName;
  final String subject;
  final String fromName;
  final String replyTo;
  final List<String> emails;

  SendMailBloc({
    this.announcement,
    this.eventName,
    this.emails,
    this.subject,
    this.fromName,
    this.replyTo,
  });

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void subjectInput(String value) {
    add(SubjectInput(value));
  }

  void fromNameInput(String value) {
    add(FromNameInput(value));
  }

  void replyToInput(String value) {
    add(ReplyToInput(value));
  }

  void messageInput(String value) {
    add(MessageInput(value));
  }

  void sendMail(Function callback) {
    add(SendMail(callback: callback));
  }

  @override
  SendMailState get initialState => SendMailState.initial(
      subject: subject, fromName: fromName, replyTo: replyTo);

  @override
  Stream<SendMailState> mapEventToState(SendMailEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is SubjectInput) {
      state.subject = event.input;
    }

    if (event is FromNameInput) {
      state.fromName = event.input;
    }

    if (event is ReplyToInput) {
      state.replyTo = event.input;
    }

    if (event is MessageInput) {
      state.message = event.input;
    }

    if (event is SendMail) {
      yield* sendMailApi(event);
    }

    if (event is SendMailEventResult) {
      yield state.copyWith(loading: false, uiMsg: event.uiMsg);
    }
  }

  Stream<SendMailState> sendMailApi(SendMail event) async* {
    int errorCode = validateData;
    if (errorCode > 0) {
      yield state.copyWith(uiMsg: errorCode);
      event.callback(null);
      return;
    }
    yield state.copyWith(loading: true);

    Map<String, dynamic> requestBody = HashMap();
    requestBody.putIfAbsent('subject', () => state.subject);
    requestBody.putIfAbsent('fromName', () => state.fromName);
    requestBody.putIfAbsent('replyTo', () => state.replyTo);
    requestBody.putIfAbsent('message', () => state.message);
    requestBody.putIfAbsent('emails', () => emails);
    requestBody.putIfAbsent('eventName', () => eventName);
    apiProvider
        .attendeesSendMail(state.authToken, requestBody)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
            networkServiceResponse.response as SendMailResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(SendMailEventResult(
            true,
            uiMsg: eventActionResponse.message,
          ));
          event.callback(eventActionResponse);
        } else {
          add(SendMailEventResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse.message);
        }
      } else {
        add(SendMailEventResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in sendMailApi--->$error');
      add(SendMailEventResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }

  int get validateData {
    if (!isValid(state.subject)) return ERR_MAIL_SUBJECT_NAME;
    if (!isValid(state.fromName)) return ERR_MAIL_FROM_NAME;
    if (!isValid(state.replyTo)) return ERR_MAIL_REPLY_TO;
    if (!isValidEmail(state.replyTo)) return ERR_MAIL_REPLY_TO_VALID;
    if (!isValid(state.message)) return ERR_MAIL_MESSAGE_BODY;

    return 0;
  }
}
