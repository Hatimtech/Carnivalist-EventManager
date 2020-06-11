import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/ui/page/webview_page.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/ui/widget/flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor/html_editor.dart';

import 'vars.dart';

extension ContextExtensions on BuildContext {
  double widthInPercent(BuildContext context, double percent) {
    var toDouble = percent / 100;
    return MediaQuery.of(context).size.width * toDouble;
  }

  double heightInPercent(BuildContext context, double percent) {
    var toDouble = percent / 100;
    return MediaQuery.of(context).size.height * toDouble;
  }

  showProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            WillPopScope(
              onWillPop: () async => false,
              child: Container(
                alignment: FractionalOffset.center,
                child: const PlatformProgressIndicator(),
              ),
            ));
  }

  hideProgress(BuildContext context) {
    Navigator.pop(context);
  }

  void toast(String message,
      {Duration duration = const Duration(seconds: 3)}) async {
    await Flushbar(
      boxShadows: [
        BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0)
      ],
      margin: EdgeInsets.all(0),
      borderRadius: 0,
      backgroundColor: colorAccent,
      messageText: Text(message, style: TextStyle(color: Colors.white)),
      duration: duration,
    )
      ..show(this);
  }

  Future<bool> showConfirmationDialog(String title,
      String message, {
        String posText,
        String negText,
      }) async {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        title,
        style: Theme
            .of(this)
            .textTheme
            .title
            .copyWith(fontSize: 16.0),
      ),
      content: Text(
        message,
        style: Theme
            .of(this)
            .textTheme
            .title
            .copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
      ),
      actions: <Widget>[
        if (isValid(negText))
          FlatButton(
              onPressed: () => Navigator.pop(this, false),
              child: Text(negText)),
        if (isValid(posText))
          FlatButton(
              onPressed: () {
                Navigator.pop(this, true);
              },
              child: Text(posText)),
      ],
    );

    return showDialog(context: this, builder: (context) => alertDialog);
  }
}

extension WidgetExtensions on Widget {
  padding(EdgeInsets edgeInsets) => Padding(padding: edgeInsets, child: this);

  cardView(EdgeInsets margin, EdgeInsets padding) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 0.5, // has the effect of extending the shadow
            offset: Offset(
              0, // horizontal, move right 10
              0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: this,
      margin: margin,
      padding: padding);

  marginVisible({EdgeInsets edgeInsets, bool isVisible = true}) => Visibility(
    visible: isVisible,
    child: Container(
        margin: (edgeInsets == null) ? EdgeInsets.all(0) : edgeInsets,
        child: this),
  );

  inputField(TextEditingController textEditingController, {
    ValueChanged<String> onChanged,
    int maxLength,
    TextInputType keyboardType,
    String hintText,
    String labelText,
    TextStyle labelStyle,
    bool obscureText = false,
    bool enabled = true,
    InkWell inkWell,
    TextInputAction textInputAction,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    FormFieldValidator<String> validation,
  }) =>
      TextFormField(
          controller: textEditingController,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          onChanged: onChanged,
          style: labelStyle,
          textInputAction: textInputAction,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) nextFocusNode.requestFocus();
            if (focusNode != null) focusNode.unfocus();
          },
          enabled: enabled,
          focusNode: focusNode,
          decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              labelText: labelText,
              suffix: inkWell),
          validator: validation);

  inputFieldRectangle(TextEditingController textEditingController, {
    String initialValue,
    ValueChanged<String> onChanged,
    int maxLength,
    bool enabled,
    TextInputType keyboardType,
    String hintText,
    String labelText,
    TextStyle hintStyle,
    TextStyle labelStyle,
    bool obscureText = false,
    int maxLines = 1,
    List<TextInputFormatter> inputFormatters,
    InkWell inkWell,
    Widget suffix,
    Icon suffixIcon,
    TextInputAction textInputAction,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    FormFieldValidator<String> validation,
  }) =>
      TextFormField(
          controller: textEditingController,
          obscureText: obscureText,
          initialValue: textEditingController == null ? initialValue : null,
          validator: validation,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: labelStyle,
          minLines: 1,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: (_) {
            if (focusNode != null) focusNode.unfocus();
            if (nextFocusNode != null) nextFocusNode.requestFocus();
          },
          autofocus: false,
          enabled: enabled,
          decoration: InputDecoration(
            counterText: '',
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorFocusedBorder, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1)),
            contentPadding: EdgeInsets.all(5),
            hintText: hintText,
            hintStyle: hintStyle,
            suffix: suffix,
            suffixIcon: suffixIcon,
          ));

  customFloatForm(
      {IconData icon, VoidCallback qrCallback, bool isMini = false}) =>
      FloatingActionButton(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          mini: isMini,
          onPressed: qrCallback,
          child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientsButton)),
              child: Stack(fit: StackFit.expand, children: <Widget>[
                Icon(icon, size: 30, color: Colors.blue)
              ])));

  expandStyle(int flex, Widget child) => Expanded(flex: flex, child: child);

  boxDecorationRectangle() => BoxDecoration(
    border: Border.all(width: 0.5, color: Colors.grey),
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //                 <--- border radius here
    ),
  );

  Widget hintedWebview(BuildContext context, String htmlValue, String hint) {
    return Container(
      height: isValid(htmlValue) ? 156 : 48,
      padding: EdgeInsets.only(left: 3.0),
      decoration: boxDecorationRectangle(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: isValid(htmlValue)
            ? AbsorbPointer(
          child: WebViewPage(
            htmlValue,
            raw: true,
          ),
        )
            : Text(
          hint,
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(color: Theme
              .of(context)
              .hintColor),
        ),
      ),
    );
  }

  Future showHtmlEditorDialog(BuildContext context,
      GlobalKey<HtmlEditorState> htmlEditorKey,
      String htmlValue,
      String hint,
      Function resultHandler) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .9,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  HtmlEditor(
                    key: htmlEditorKey,
                    hint: isValid(htmlValue) ? '' : hint,
                    value: htmlValue,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .8,
                    showBottomToolbar: false,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          AppLocalizations
                              .of(context)
                              .btnClose,
                          style: Theme
                              .of(context)
                              .textTheme
                              .button,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () async {
                          final html =
                          await htmlEditorKey.currentState.getText();
                          resultHandler(html);
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          AppLocalizations
                              .of(context)
                              .btnSave,
                          style: Theme
                              .of(context)
                              .textTheme
                              .button,
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
