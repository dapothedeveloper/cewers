import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  final List<String> _emergencyNumbers = [
    "07080800001",
    "07080800002",
    "07080800003"
  ];
  static const String route = "/sos";

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[]..addAll(
                _emergencyNumbers.map(
                  (number) => Row(
                    children: <Widget>[
                      ImageIcon(AssetImage("assets/tabs/phone.png")),
                      Card(
                        child: Text(number),
                      )
                    ],
                  ),
                )..toList(),
              ),
          ),
        ),
      ),
    );
  }
}
