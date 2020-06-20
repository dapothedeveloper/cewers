import 'package:cewers/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  return AppLocalization.of(context).getTranslatedValue(key);
}

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  await _pref.setString(LANGUAGECODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  String languageCode = _pref.getString(LANGUAGECODE) ?? ENGLISH;
  return _locale(languageCode);
}

Future<String> getState() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();

  String state = _pref.getString("prefferedState");
  return state;
}

Locale _locale(String languageCode) {
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
