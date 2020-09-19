import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class ActionButtonBar extends StatelessWidget {
  final String text;
  final Function action;

  ActionButtonBar({Key key, this.text, this.action});

  Widget build(BuildContext context) {
    return SizedBox(
      width: 253,
      child: RaisedButton(
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: action,
        padding: EdgeInsets.only(top: 12, bottom: 10),
        child: Text(
          text,
          style: ButtonStyle,
        ),
      ),
    );
  }
}
