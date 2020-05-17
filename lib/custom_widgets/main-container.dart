import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget {
  final Widget child;
  final Widget bottomNavigationBar;
  final BoxDecoration decoration;
  final CewerAppBar displayAppBar;
  MainContainer({
    Key key,
    @required this.decoration,
    @required this.child,
    this.displayAppBar,
    this.bottomNavigationBar,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          title: displayAppBar ?? CewerAppBar(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: decoration,
          child: SafeArea(
            minimum: EdgeInsets.only(left: 24, right: 24, top: 0),
            child: child,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar);
  }
}
