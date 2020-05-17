import 'package:flutter/material.dart';

class CewerAppBar extends StatelessWidget {
  final String italicsTitle;
  final String boldTitle;
  CewerAppBar([
    this.boldTitle,
    this.italicsTitle,
  ]);
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Text(boldTitle ?? "",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .apply(color: Theme.of(context).primaryColor)),
          Text(italicsTitle ?? "CEWERS.",
              style: Theme.of(context)
                  .appBarTheme
                  .textTheme
                  .headline1
                  .apply(color: Theme.of(context).primaryColor)),
        ],
      ),
    );
  }
}
