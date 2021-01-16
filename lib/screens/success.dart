import 'package:cewers/custom_widgets/button.dart';
// import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/login.dart';
// import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String payload;
  static const String route = "/success";
  SuccessScreen([this.payload]);
  Widget build(BuildContext context) {
    return Scaffold(
      // decoration: bgDecoration(),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.only(bottom: 30, left: 24, right: 24),
        child: ActionButtonBar(
          text: payload == "feedback" ? "GO BACK HOME" : "GOTO LOGIN",
          action: () {
            payload == "feedback"
                ? Navigator.pushNamed(context, HomeScreen.route)
                : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen(payload)),
                  );
          },
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/icons/check.png"),
            SafeArea(
              minimum: EdgeInsets.only(top: 20, left: 50, right: 50),
              child: Align(
                alignment: Alignment.center,
                child: Center(
                    child: Text(
                  payload == "feedback"
                      ? "Your feedback has been sent successfully."
                      : "Your account has been created. Please login to access you account",
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
