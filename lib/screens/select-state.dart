import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/state-card.dart';
import 'package:cewers/main.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SelectStateScreen extends StatefulWidget {
  _SelectStateScreen createState() => _SelectStateScreen();
}

class _SelectStateScreen extends State<SelectStateScreen> {
  GetIt _getIt = GetIt.instance;
  Future future;
  void initState() {
    super.initState();
    future = _getIt<StorageController>().getState();
  }

  void dispose() {
    super.dispose();
    // _getIt<StorageController>().closeStream();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        title: Container(
          child: Row(
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
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) => Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[]..addAll(
                ["benue", "taraba", "nasarawa"].map(
                  (state) => StateCard(
                      stateName: state.toUpperCase(),
                      stateMapUri: "assets/images/$state-map.png",
                      action: () async {
                        await _getIt<StorageController>().storeState(state);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }),
                ),
              ),
          ),
        ),
      ),
    );
  }
}
