import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final String title;

  CommonAppBar({Key key, this.title}) : super(key: key);

  Widget build(BuildContext buildContext) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
    );
  }
}
