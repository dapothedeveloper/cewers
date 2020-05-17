import 'package:flutter/material.dart';

class SelectIndicator extends StatelessWidget {
  final bool active;
  SelectIndicator(this.active);
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
