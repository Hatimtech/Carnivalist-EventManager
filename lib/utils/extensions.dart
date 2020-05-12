import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/ui/widget/flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  inputField(TextEditingController textEditingController,
      {ValueChanged<String> onChanged,
        int maxLength,
        TextInputType keyboardType,
        String hintText,
        String labelText,
        TextStyle labelStyle,
        bool obscureText = false,
        InkWell inkWell,
        TextInputAction textInputAction,
        FocusNode focusNode,
        FocusNode nextFocusNode,
        FormFieldValidator<String> validation}) =>
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
    TextInputAction textInputAction,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    FormFieldValidator<String> validation,
  }) =>
      TextFormField(
          controller: textEditingController,
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
            if (nextFocusNode != null) nextFocusNode.requestFocus();
            if (focusNode != null) focusNode.unfocus();
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
}
