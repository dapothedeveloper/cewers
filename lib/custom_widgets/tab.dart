import 'package:cewers/screens/alerts.dart';
import 'package:cewers/screens/home.dart';
import 'package:flutter/material.dart';

class MainTab {
  final String icon;
  final String name;
  final Widget screen;
  MainTab(this.name, this.icon, this.screen);

  static fetchAllTabs(BuildContext context) {
    return [
      MainTab("home", "home.png", HomeScreen()),
      MainTab("Alerts", "alert.png", AlertListScreen()),
      MainTab("Map", "pin.png", null),
      MainTab("Feedback", "info.png", null),
    ]
        .map(
          (tab) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => tab.screen));
            },
            child: Container(
              height: 75,
              child: Column(children: <Widget>[
                Image.asset("assets/icons/tabs/${tab.icon}"),
                Text(
                  tab.name,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )
              ]),
            ),
          ),
        )
        .toList();
  }
}

class BottomTab extends StatelessWidget {
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => SafeArea(
        minimum: EdgeInsets.only(bottom: 2, left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[]..addAll(MainTab.fetchAllTabs(context)),
        ),
      ),
    );
  }
}
