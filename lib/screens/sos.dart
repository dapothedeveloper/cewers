import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[]..addAll(
                _emergencyNumbers.map(
                  (number) => Center(
                    child: InkWell(
                      onTap: () => launch("tel:$number"),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // ImageIcon(
                            //   AssetImage("assets/icons/tabs/phone.png"),
                            //   size: 24,
                            // ),
                            Icon(
                              Icons.phone,
                              size: 34,
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  number,
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )..toList(),
              ),
          ),
        ),
        // persistentFooterButtons: <Widget>[],
      ),
    );
  }
}
