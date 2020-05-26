import 'package:flutter/material.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String description;
  final Widget widget;
  LabeledText(this.label, this.description, {Key key, this.widget})
      : super(key: key);

  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.headline6,
        ),
        widget ??
            Text(
              description,
              style: Theme.of(context).textTheme.bodyText1,
            ),
      ],
    );
  }
}
