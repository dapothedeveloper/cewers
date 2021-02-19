import 'package:flutter/material.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String description;
  final Widget widget;
  LabeledText(this.label, this.description, {Key key, this.widget});

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 100,
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline6,
            )),
        widget ??
            Text(
              description,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.bodyText1,
            ),
      ],
    );
  }
}
