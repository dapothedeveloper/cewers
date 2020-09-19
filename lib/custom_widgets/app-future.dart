import 'package:flutter/material.dart';

class AppFutureBuilder extends StatefulWidget {
  final Future future;
  final Widget welcome;
  final Widget selectState;

  _AppFutureBuilder createState() => _AppFutureBuilder();

  AppFutureBuilder(
      {Key key,
      @required this.future,
      @required this.welcome,
      @required this.selectState})
      : super(key: key);
}

class _AppFutureBuilder extends State<AppFutureBuilder> {
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return snapshot.data == null
                  ? widget.selectState
                  : widget.welcome;
              break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}
