// import 'package:cewers/custom_widgets/main-container.dart';
// import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/notifier/recorder.dart';
import 'package:cewers/screens/select-crime.dart';
import 'package:cewers/screens/voice-recorder.dart';
import 'package:provider/provider.dart';
// import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  static const String route = "/home";
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<AlertScreen> {
  // _HomeScreen(this._locationController);
  // Future _locationPersion;
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            height: 80,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider<RecorderNotifier>(
                      create: (_) => RecorderNotifier(),
                      child: VoiceRecodeScreen(),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(Icons.mic, size: 34),
                  Text(
                    "Click to record\nAlert",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SelectCrimeScreen.route);
              },
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(128),
                  image: DecorationImage(
                      image: AssetImage("assets/backgrounds/alert.png")),
                ),
                child: Center(
                    child: Text(
                  translate(context, ALERT),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
