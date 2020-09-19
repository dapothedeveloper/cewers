import 'package:flutter/material.dart';

class AppStateNofifier extends ChangeNotifier {
  Locale locale;

  setLocale(Locale newLocale) {
    locale = newLocale;
    notifyListeners();
  }
}
