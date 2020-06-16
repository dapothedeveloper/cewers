import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  _LanguageScreen createState() => _LanguageScreen();
}

class _LanguageScreen extends State<LanguageScreen> {
  List<String> languages = ["English", "Hausa", "Jukun", "Agatu", "Tiv"];
  String _language;

  Widget build(BuildContext context) {
    return MainContainer(
      displayAppBar: CewerAppBar("Select", " Language"),
      decoration: null,
      child: Center(
        child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: ListView(
              children: <Widget>[]..addAll(
                  languages.map(
                    (e) => ListTile(
                        selected: _language == e.toLowerCase(),
                        onTap: () {
                          setLanguage(e.toLowerCase());
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              e,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Radio(
                                value: e.toLowerCase(),
                                groupValue: _language,
                                onChanged: setLanguage)
                          ],
                        )),
                  ),
                ),
            )),
      ),
    );
  }

  setLanguage(String language) {
    setState(() {
      _language = language;
    });
  }
}
