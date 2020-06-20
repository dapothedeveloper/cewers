import 'dart:convert';

import 'package:cewers/localization/localization_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Map<String, String> _localizationValues;

  Future load() async {
    print(locale.languageCode);
    String jsonStringValues =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizationValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  String getTranslatedValue(String key) {
    return _localizationValues[key];
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return [ENGLISH, HAUSA, JUKUN, AGATU, TIV].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    // print(locale.languageCode.toString());
    AppLocalization appLocalization = AppLocalization(locale);
    await appLocalization.load();
    return appLocalization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
