import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidthAwareTextField extends StatefulWidget {
  final Function onActionDone;
  final FocusNode focusNode;
  final bool showHint;

  const WidthAwareTextField(
      {this.onActionDone, this.focusNode, this.showHint = true});

  @override
  _WidthAwareTextFieldState createState() => _WidthAwareTextFieldState();
}

class _WidthAwareTextFieldState extends State<WidthAwareTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  double minTagFieldWidth = 116;
  double maxTagFieldWidth, currentFieldWidth;

  @override
  void initState() {
    super.initState();
    currentFieldWidth = minTagFieldWidth;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      maxTagFieldWidth = MediaQuery.of(context).size.width - 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: currentFieldWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextFormField(
          controller: _textEditingController,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.body1,
          maxLines: 1,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.showHint
                ? AppLocalizations.of(context).inputHintTag
                : null,
          ),
          onChanged: (value) {
            double textWidth = _getTextWidth(value);

            if (textWidth > maxTagFieldWidth) {
              textWidth = maxTagFieldWidth;
            } else if (textWidth < minTagFieldWidth) {
              textWidth = minTagFieldWidth;
            }

            if (textWidth != currentFieldWidth)
              setState(() {
                currentFieldWidth = textWidth;
              });
          },
          onFieldSubmitted: (value) {
            if (value != null && value.isNotEmpty && value.trim().isNotEmpty) {
              _textEditingController.text = '';
              currentFieldWidth = minTagFieldWidth;
              if (widget.onActionDone != null) widget.onActionDone(value);
            }
          },
        ),
      ),
    );
  }

  double _getTextWidth(String text) {
    TextSpan textSpan = new TextSpan(
      style: Theme.of(context).textTheme.body1,
      text: text,
    );
    TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout();
    return textPainter.width;
  }
}
