// import 'package:cewers/custom_widgets/main-container.dart';
// import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/custom_widgets/tab.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/screens/select-crime.dart';
// import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/home";
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  // _HomeScreen(this._locationController);
  // Future _locationPersion;
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // decoration: null,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SelectCrimeScreen.route);
              },
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(128),
                    image: DecorationImage(
                        image: AssetImage("assets/backgrounds/alert.png"))),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomTab(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
