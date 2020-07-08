import 'package:cewers/localization/localization.dart';
import 'package:cewers/main.dart';
import 'package:cewers/model/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const String ENGLISH = "en";
const String HAUSA = "ha";
const String JUKUN = "jk";
const String AGATU = "ag";
const String TIV = "tv";
const String HOME = "home";
const String WELCOME_CARD_TITLE = "welcome_card_title";
const String REPORT_EVENT = "report_event";
const String LOGIN = "login";
const String SIGN_UP = "sign_up";
const String CHANGE_STATE = "change_state";
const String FULL_NAME = "full_name";
const String PHONE_NUMBER = "phone_number";
const String EMAIL_ADDRESS = "email_address";
const String SELECT_COMMUNITY = "select_community";
const String SELECT_FEEDBACK = "select_feedback";
const String NEW_USER = "new_user";
const String ENTER_DETAILS = "enter_details";
const String ALERT = "alert";
const String MAP = "map";
const String FEEDBACK = "feedback";
const String SOS = "sos";
const String TYPE_SELECT = "type_select";
const String FIRE = "fire";
const String COMMUNIAL_CLASH = "communial_clash";
const String HEALTH = "health";
const String HERDSMEN_ATTACK = "herdsmen_attack";
const String INTERCOMMUNIAL_CLASH = "intercommunial_clash";
const String NATURAL_DISASTER = "natural_disaster";
const String VIOLENCE = "violence";
const String SELECT_LGA = "armed_banditry";
const String KIDNAPPING = "kidnapping";
const String FARMERS_CLASH = "farmers_clash";

const LANGUAGECODE = "languageCode";
String translate(BuildContext context, String key) {
  return AppLocalization.of(context).getTranslatedValue(key) ?? key;
}

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  await _pref.setString(LANGUAGECODE, languageCode);
  return locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  String languageCode = _pref.getString(LANGUAGECODE) ?? ENGLISH;
  return locale(languageCode);
}

Future<String> getState() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  String state = _pref.getString("prefferedState");
  return state;
}
// ... app-specific localization delegate[s] here

List<LocalizationsDelegate> localizationsDelegates = [
  AppLocalization.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
Locale localeResolutionCallback(
    Locale deviceLocale, Iterable<Locale> supportedLocale) {
  for (var locale in supportedLocale) {
    if (locale.languageCode == deviceLocale.languageCode &&
        locale.countryCode == deviceLocale.countryCode) {
      return deviceLocale;
    }
  }
  return supportedLocale.first;
}

final supportedLocales = [
  const Locale(ENGLISH, "US"), // English
  const Locale(HAUSA, "NG"), // Housa
  const Locale(AGATU, "NG"), // Hebrew
  const Locale(JUKUN, "NG"), // Jukun
  const Locale(TIV, "NG"), // Tiv
  // ... other locales the app supports
];
Locale locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, "US");
      break;
    case JUKUN:
      _temp = Locale(languageCode, "NG");
      break;
    case TIV:
      _temp = Locale(languageCode, "NG");
      break;
    case AGATU:
      _temp = Locale(languageCode, "NG");
      break;
    case HAUSA:
      _temp = Locale(languageCode, "NG");
      break;
    default:
      _temp = Locale(languageCode, "US");
  }
  return _temp;
}

final List<AppLocalModel> languages = [
  AppLocalModel("English", "US", ENGLISH),
  AppLocalModel("Hausa", "NG", HAUSA),
  AppLocalModel("Jukun", "NG", JUKUN),
  AppLocalModel("Agatu", "NG", AGATU),
  AppLocalModel("Tiv", "NG", TIV),
];

void changeLanguage(AppLocalModel languageCode, BuildContext context) {
  Locale _temp;
  switch (languageCode.languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode.languageCode, "US");
      break;
    case JUKUN:
      _temp = Locale(languageCode.languageCode, "NG");
      break;
    case TIV:
      _temp = Locale(languageCode.languageCode, "NG");
      break;
    case AGATU:
      _temp = Locale(languageCode.languageCode, "NG");
      break;
    case HAUSA:
      _temp = Locale(languageCode.languageCode, "NG");
      break;
    default:
      _temp = Locale(languageCode.languageCode, "US");
  }
  App.setLocale(context, _temp);
}

AppBar bar(BuildContext context) => AppBar(
      // title: Text(translate(context, HOME)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: DropdownButton(
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
              ),
              items: languages
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.languageTitle,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .apply(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (languageCode) {
                // setState(() {
                changeLanguage(languageCode, context);
                // });
              }),
        ),
      ],
    );
