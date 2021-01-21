import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/localization/localization_constant.dart';
// import 'package:cewers/model/localization.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/login.dart';
import 'package:cewers/screens/select-state.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt _getIt = GetIt.instance;

class WelcomeScreen extends StatelessWidget {
  static String route = "/welcome";
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    return FutureBuilder(
      future: _getIt<StorageController>().getState(),
      builder: (_, snapshot) {
        String mapUri = snapshot.data == null
            ? "assets/images/benue-map.png"
            : "assets/images/${snapshot.data.toLowerCase()}-map.png";
        String bgUri = snapshot.data == null
            ? "assets/backgrounds/benue.png"
            : "assets/backgrounds/${snapshot.data.toLowerCase()}.png";
        // List<AppLocalModel> stateDialets = languages.map((language) {
        //   if (language.state.toLowerCase() == snapshot.data.toLowerCase() ||
        //       language.state == OFFICIAL_LANGUAGE) {
        //     return language;
        //   }
        // });
        var stateDialets;
        List<DropdownMenuItem<dynamic>> _dropDownMenuList;
        if (snapshot.data != null) {
          stateDialets = languages.where((language) =>
              language != null &&
                  language.state.toLowerCase() == snapshot.data.toLowerCase() ||
              language.state == OFFICIAL_LANGUAGE);
          _dropDownMenuList = stateDialets
              .map<DropdownMenuItem>(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.languageTitle,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .apply(color: primaryColor),
                  ),
                ),
              )
              .toList();
        }
        return MaterialApp(
          theme: Theme.of(context),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: DropdownButton(
                      underline: SizedBox(),
                      icon: Icon(
                        Icons.language,
                        color: primaryColor,
                      ),
                      items: _dropDownMenuList,
                      onChanged: (languageCode) {
                        changeLanguage(languageCode, context);
                      }),
                ),
              ],
            ),
            body: Container(
              decoration: bgDecoration(bgUri),
              padding: EdgeInsets.only(left: 24, right: 24, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        left: 10,
                        top: -120,
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: AssetImage(mapUri), fit: BoxFit.contain),
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data.toString().toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: -(MediaQuery.of(context).size.height / 2),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Image.asset("assets/logo/cwnew.png")),
                      ),
                      Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            height: 306,
                            margin: EdgeInsets.only(
                                top: 0, left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 39),
                                    child: Text(
                                      translate(context, WELCOME_CARD_TITLE),
                                      style: coloredHeaderStyle()
                                          .apply(color: primaryColor),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 25, bottom: 23),
                                  child: ActionButtonBar(
                                    action: () async {
                                      Navigator.pushNamed(
                                        context,
                                        HomeScreen.route,
                                      );
                                    },
                                    text: translate(context, REPORT_EVENT),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 28),
                                  child: SizedBox(
                                    width: 253,
                                    child: OutlineButton(
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 1),
                                      color: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, LoginScreen.route);
                                      },
                                      child: Text(
                                        translate(context, LOGIN),
                                        style: ButtonTextStyle.apply(
                                            color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 33),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SelectStateScreen.route);
                                    },
                                    child: Text(
                                      translate(context, CHANGE_STATE),
                                      style: TextStyle(color: primaryColor),
                                    ),
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
          ),
        );
      },
    );
  }
}
