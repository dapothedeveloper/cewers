// import 'dart:convert';

import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/localization/localization.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/login.dart';
import 'package:cewers/screens/media-upload.dart';
import 'package:cewers/screens/report-notification.dart';
import 'package:cewers/screens/select-crime.dart';
import 'package:cewers/screens/select-state.dart';
import 'package:cewers/screens/send-report.dart';
import 'package:cewers/screens/sign_up.dart';
import 'package:cewers/screens/success.dart';
import 'package:cewers/service/api.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

GetIt _getIt = GetIt.instance;

void main() {
  _getIt.registerSingleton<StorageController>(StorageController(),
      signalsReady: true);
  _getIt.registerSingleton<UploadNotifier>(UploadNotifier(StorageController()),
      signalsReady: true);
  _getIt.registerSingleton<GeoLocationController>(GeoLocationController(),
      signalsReady: true);
  _getIt.registerSingleton<API>(API(), signalsReady: true);

  runApp(App());
}

class App extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _App _app = context.findAncestorStateOfType<_App>();
    _app.setLocale(locale);
  }

  static void setTheme(BuildContext context, String state) {
    _App _app = context.findAncestorStateOfType<_App>();
    _app.updateTheme(state);
  }

  _App createState() => _App();
}

class _App extends State<App> {
  // This widget is the root of your application.
  Locale _locale;
  String _state;
  GetIt _getIt = GetIt.instance;

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      this._locale = locale;
    });
    updateTheme(_state);
    super.didChangeDependencies();
  }

  void updateTheme(String state) {
    setState(() {
      _state = state;
    });
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  void initState() {
    getLocale().then((locale) {
      return locale;
    }).then((locale) {
      _getIt<StorageController>().getState().then((state) {
        setState(() {
          _state = state;
          _locale = locale;
        });
      });
    });
    // _initOneSignal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CEWERS.',
        locale: _locale,
        supportedLocales: [
          Locale(ENGLISH, "US"), // English
          Locale(HAUSA, "NG"), // Housa
          Locale(AGATU, "NG"), // Hebrew
          Locale(JUKUN, "NG"), // Jukun
          Locale(TIV, "NG"), // Tiv
          Locale(ALAGO, "NG"), // Alago
          Locale(EGGON, "NG"), // Eggon
          Locale(MADA, "NG"), // Mada
          // ... other locales the app supports
        ],
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(
          primaryColor: _getPrimaryColor(),
          accentColor: _getSecondaryColor(),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: _getPrimaryColor(), //change your color here
            ),
            textTheme: TextTheme(
              headline1:
                  appBarStyle().apply(color: Theme.of(context).primaryColor),
            ),
            color: Colors.transparent,
            elevation: 0,
          ),
          textTheme: TextTheme(
            button: TextStyle(
              fontFamily: fontRoboto,
              fontWeight: FontWeight.w700,
              color: _getPrimaryColor(),
              fontSize: 28,
            ),
            bodyText2: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            headline1:
                titleStyle().apply(color: Theme.of(context).primaryColor),
            headline3: TextStyle(
                fontFamily: fontRoboto,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black87),
            headline6: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            subtitle1: subHeadStyle(context),
            subtitle2: coloredHeaderStyle()
                .apply(color: Theme.of(context).primaryColor),
          ),
        ),
        initialRoute: "/",
        routes: {
          HomeScreen.route: (context) => HomeScreen(),
          LoginScreen.route: (context) => LoginScreen(),
          MediaUploadScreen.route: (context) => MediaUploadScreen(null),
          SendReportScreen.route: (context) => SendReportScreen(null),
          ReportNotification.route: (context) => ReportNotification(null, null),
          SelectStateScreen.route: (context) => SelectStateScreen(),
          SignUpScreen.route: (context) => SignUpScreen(),
          SelectCrimeScreen.route: (context) => SelectCrimeScreen(),
          SuccessScreen.route: (context) => SuccessScreen(),
          HomeScreen.route: (context) => HomeScreen(),
          "/": (context) {
            debugPrint(_state);

            return _state == null ? SelectStateScreen() : HomeScreen();
          }
        },
      ),
    );
  }

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

  Color _getPrimaryColor() {
    return _state == null ? primaryColor : _primaryColors[_state.toLowerCase()];
  }

  Color _getSecondaryColor() {
    return _state == null
        ? secondaryColor
        : _secondaryColors[_state.toLowerCase()];
  }

  void dispose() {
    super.dispose();
  }
}
