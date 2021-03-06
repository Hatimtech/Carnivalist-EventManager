import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidthAwareTextField extends StatefulWidget {
  final Function onActionDone;
  final FocusNode focusNode;
  final bool showHint;

  const WidthAwareTextField(
      {Key key, this.onActionDone, this.focusNode, this.showHint = true})
      : super(key: key);

  @override
  _WidthAwareTextFieldState createState() => _WidthAwareTextFieldState();
}

class _WidthAwareTextFieldState extends State<WidthAwareTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  double minTagFieldWidth = 132;
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
  void didUpdateWidget(covariant WidthAwareTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textEditingController.text?.isEmpty ?? true)
      _textEditingController.clear();
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
          maxLength: 250,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
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
            if (value != null && value.isNotEmpty && value
                .trim()
                .isNotEmpty) {
              setState(() => _textEditingController.text = '');
              currentFieldWidth = minTagFieldWidth;
              if (widget.onActionDone != null) widget.onActionDone(value);
            }
          },
          onEditingComplete: () => print('On Editing Complete'),
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
