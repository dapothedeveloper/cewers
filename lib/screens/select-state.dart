import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/state-card.dart';
import 'package:cewers/main.dart';
import 'package:cewers/style.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SelectStateScreen extends StatefulWidget {
  static const String route = "/selectState";
  _SelectStateScreen createState() => _SelectStateScreen();
}

class _SelectStateScreen extends State<SelectStateScreen> {
  GetIt _getIt = GetIt.instance;
  Future future;
  void initState() {
    super.initState();
    future = _getIt<StorageController>().getState();
    _getIt<GeoLocationController>().promptRequestLocationPerssion();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                Text("Select ",
                    style: titleStyle()
                        .apply(color: Theme.of(context).primaryColor)),
                Text(
                  "State ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor,
                    fontSize: largeTextSize,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 25),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[]..addAll(
                  ["benue", "taraba", "nasarawa"].map(
                    (state) => StateCard(
                        stateName: state.toUpperCase(),
                        stateMapUri: "assets/images/$state-map.png",
                        action: () async {
                          await _getIt<StorageController>().storeState(state);
                          App.setTheme(context, state);
                          Navigator.pushNamed(context, "/");
                        }),
                  ),
                ),
            ),
          ),
        ));
  }
}
