import 'package:eventmanagement/ui/widget/shrinked_checkbox.dart' as CustomCB;
import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding = const EdgeInsets.all(4.0),
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            CustomCB.Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(child: Text(label, style: Theme
                .of(context)
                .textTheme
                .body1,)),
          ],
        ),
      ),
    );
  }
}
