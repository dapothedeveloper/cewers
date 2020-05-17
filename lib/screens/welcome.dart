import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/login.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class WelcomeScreen extends StatefulWidget {
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  GetIt _getIt = GetIt.instance;
  Future future;
  void initState() {
    future = _getIt<StorageController>().getState();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        String mapUri = snapshot.data == null
            ? "assets/images/benue-map.png"
            : "assets/images/${snapshot.data.toLowerCase()}-map.png";
        String bgUri = snapshot.data == null
            ? "assets/backgrounds/benue.png"
            : "assets/backgrounds/${snapshot.data.toLowerCase()}.png";
        return MainContainer(
          displayAppBar: CewerAppBar(),
          decoration: bgDecoration(bgUri),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      left: 100,
                      top: -60,
                      child: Image.asset(mapUri),
                    ),
                    Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              SafeArea(
                                  minimum: EdgeInsets.only(top: 39),
                                  child: Text(
                                    "Conflict Early Warning Early Response System.",
                                    style: coloredHeaderStyle().apply(
                                        color: Theme.of(context).primaryColor),
                                    textAlign: TextAlign.center,
                                  )),
                              SafeArea(
                                minimum: EdgeInsets.only(top: 25, bottom: 23),
                                child: ActionButtonBar(
                                  action: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  },
                                  text: "REPORT EVENT",
                                ),
                              ),
                              SafeArea(
                                minimum: EdgeInsets.only(bottom: 28),
                                child: SizedBox(
                                  width: 253,
                                  child: OutlineButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: Text(
                                      "LOGIN",
                                      style: ButtonStyle.apply(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).primaryColor,
                                    borderSide: BorderSide.none,
                                    disabledBorderColor:
                                        Theme.of(context).primaryColor,
                                    highlightedBorderColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                              SafeArea(
                                minimum: EdgeInsets.only(bottom: 33),
                                child: Text(
                                  "Select State",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
