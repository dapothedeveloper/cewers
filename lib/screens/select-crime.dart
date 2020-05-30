import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/crime-select-indicator.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/custom_widgets/tab.dart';
import 'package:cewers/notifier/report-image.dart';
import 'package:cewers/screens/send-report.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class SelectCrimeScreen extends StatefulWidget {
  _SelectCrimeScreen createState() => _SelectCrimeScreen();
}

class _SelectCrimeScreen extends State<SelectCrimeScreen> {
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MainContainer(
      decoration: bgDecoration(),
      displayAppBar: CewerAppBar("  Type", "Select"),
      bottomNavigationBar: BottomTab(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 280,
              padding: EdgeInsets.all(50),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                for (var i = 0; i < iconList.length; i++) {
                                  iconList[i].active = false;
                                  iconList[index].active = true;
                                }
                              });
                            },
                            autoPlay: false,
                            aspectRatio: 0.8,
                            enlargeCenterPage: true,
                          ),
                          items: []..addAll(
                              iconList.map(
                                (image) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider<
                                                    ReportImageNotifier>(
                                                create: (context) =>
                                                    ReportImageNotifier(),
                                                child: SendReportScreen(
                                                    image.value)),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 300,
                                    margin: EdgeInsets.all(5.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/icons/${image.icon}",
                                          fit: BoxFit.contain,
                                          height: 440,
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5),
                                          alignment: Alignment.center,
                                          child: Center(
                                              child: Text(image.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .apply(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeightDelta: 24,
                                                          fontSizeDelta: -4))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[]
                ..addAll(iconList.map((icon) => SelectIndicator(icon.active))),
            ),
          ),
          Align(
            heightFactor: 3,
            alignment: Alignment.center,
            child: Text(
              "< Swipe left or right >",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          )
        ]),
      ),
    );
  }

  List<IconList> iconList = [
    IconList("herdsmen.png", "Herdsmen Attack", "herdsmen", true),
    IconList("health.png", "Health", "health", false),
    IconList("violence.png", "Communial Clash", "violence", false),
    IconList("fire.png", "Fire", "fire", false),
    IconList("natural-disaster.png", "Natural Disaster", "health", false),
  ];
  // final List<Widget> imageSliders = ;
}

class IconList {
  final String icon;
  final String name;
  final String value;
  bool active;
  IconList(this.icon, this.name, this.value, this.active);
}
