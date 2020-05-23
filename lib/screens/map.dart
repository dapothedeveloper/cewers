import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class HeatMap extends StatelessWidget {
  final String text;
  HeatMap({Key key, this.text});
  Widget build(BuildContext context) {
    return MainContainer(
      decoration: bgDecoration(),
      child: Container(
        child: Center(
          child: Text(this.text ?? "Feedback!"),
        ),
      ),
    );
  }
}
