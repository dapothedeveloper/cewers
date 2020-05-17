import 'package:flutter/material.dart';

class StateCard extends StatelessWidget {
  final String stateName;
  final String stateMapUri;
  final Function action;
  StateCard(
      {Key key,
      @required this.stateName,
      @required this.stateMapUri,
      @required this.action})
      : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 34),
            width: 237,
            child: Column(
              children: <Widget>[
                Image.asset(this.stateMapUri),
                Center(
                    child: Text(
                  stateName.toUpperCase(),
                  style: TextStyle(fontSize: 20),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
