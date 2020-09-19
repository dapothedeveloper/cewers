import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/screens/alerts.dart';
import 'package:cewers/screens/feedback.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/map.dart';
import 'package:cewers/screens/sos.dart';
import 'package:flutter/material.dart';

class MainTab {
  final String icon;
  final String name;
  final String route;
  MainTab(this.name, this.icon, this.route);

  fetchAllTabs(BuildContext context, MainTab tab) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, tab.route);
      },
      child: Container(
        height: 75,
        child: Column(children: <Widget>[
          Image.asset("assets/icons/tabs/${tab.icon}"),
          Text(
            translate(context, tab.name),
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          )
        ]),
      ),
    );
  }
}

class BottomTab extends StatelessWidget {
  final List<MainTab> tabs = [
    MainTab(HOME, "home.png", HomeScreen.route),
    MainTab(ALERT, "alert.png", AlertListScreen.route),
    MainTab(MAP, "pin.png", HeatMap.route),
    MainTab(FEEDBACK, "info.png", FeedbackScreen.route),
    MainTab(SOS, "phone.png", SosScreen.route),
  ];
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => SafeArea(
        minimum: EdgeInsets.only(bottom: 2, left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[]
            ..addAll(tabs.map((tab) => tab.fetchAllTabs(context, tab))),
        ),
      ),
    );
  }
}
