import 'dart:convert';

import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/model/keys.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/select-state.dart';
import 'package:cewers/screens/welcome.dart';
import 'package:cewers/service/onsignal.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cewers/localization/localization.dart';

GetIt _getIt = GetIt.instance;

void main() {
  _getIt.registerSingleton<StorageController>(StorageController(),
      signalsReady: true);
  _getIt.registerSingleton<UploadNotifier>(UploadNotifier(StorageController()),
      signalsReady: true);
  _getIt.registerSingleton<GeoLocationController>(GeoLocationController(),
      signalsReady: true);

  runApp(App());
}

class App extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _App _app = context.findAncestorStateOfType<_App>();
    _app.setLocale(locale);
    getState().then((state) {
      _app.setUserState(state);
    });
  }

  _App createState() => _App();
}

class _App extends State<App> {
  // This widget is the root of your application.

  Locale _locale;
  String _state;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setUserState(String state) {
    setState(() {
      _state = state;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getState().then((value) {
      this._state = value;
    });
    getLocale().then((locale) {
      this._locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _initOneSignal();
    getState().then((value) {
      this._state = value;
    });
    getLocale().then((locale) {
      this._locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEWERS.',
      locale: _locale,
      // actions: ActionsWidget,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocale) {
        for (var locale in supportedLocale) {
          if (locale.languageCode == deviceLocale.languageCode &&
              locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocale.first;
      },
      supportedLocales: [
        const Locale(ENGLISH, "US"), // English
        const Locale(HAUSA, "NG"), // Housa
        const Locale(AGATU, "NG"), // Hebrew
        const Locale(JUKUN, "NG"), // Jukun
        const Locale(TIV, "NG"), // Tiv
        // ... other locales the app supports
      ],
      theme: ThemeData(
        primaryColor: _getPrimaryColor(_state),
        accentColor: _getSecondaryColor(_state),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          textTheme: TextTheme(
            headline1:
                appBarStyle().apply(color: Theme.of(context).primaryColor),
            headline3: TextStyle(
                fontFamily: fontRoboto,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black87),
            subtitle1: subHeadStyle(context),
            subtitle2: coloredHeaderStyle()
                .apply(color: Theme.of(context).primaryColor),
            button: TextStyle(
              fontFamily: fontRoboto,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
              fontSize: 28,
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          headline1: titleStyle().apply(color: Theme.of(context).primaryColor),
          headline6: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: (_state == null) ? SelectStateScreen() : WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _loading = MaterialApp(
    title: 'CEWERS.',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
  final Map<String, Color> _primaryColors = {
    "taraba": primaryColor,
    "benue": benueColor,
    "nasarawa": nasarawaColor
  };

  final Map<String, Color> _secondaryColors = {
    "taraba": primaryColor,
    "benue": benueColor,
    "nasarawa": nasarawaColor
  };

  Color _getPrimaryColor(String state) {
    return state == null ? primaryColor : _primaryColors[state.toLowerCase()];
  }

  Color _getSecondaryColor(String state) {
    return state == null
        ? secondaryColor
        : _secondaryColors[state.toLowerCase()];
  }

  void dispose() {
    super.dispose();
  }

  Future<void> _initOneSignal() async {
    final credentials = await rootBundle.loadString("assets/keys.json");
    var keys = SingleKeyModel.forOnesignal(json.decode(credentials));
    /**
     *  OSLogLevel.debug must be change to  OSLogLevel.none
     */
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.debug);
    PushNotification(keys.key);
  }
}
