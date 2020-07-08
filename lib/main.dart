import 'dart:convert';

import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/model/keys.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/alerts.dart';
import 'package:cewers/screens/feedback.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/login.dart';
import 'package:cewers/screens/map.dart';
import 'package:cewers/screens/media-upload.dart';
import 'package:cewers/screens/report-notification.dart';
import 'package:cewers/screens/select-crime.dart';
import 'package:cewers/screens/select-state.dart';
import 'package:cewers/screens/send-report.dart';
import 'package:cewers/screens/sign_up.dart';
import 'package:cewers/screens/sos.dart';
import 'package:cewers/screens/success.dart';
// import 'package:cewers/screens/select-state.dart';
import 'package:cewers/screens/welcome.dart';
import 'package:cewers/service/onsignal.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:cewers/localization/localization.dart';

GetIt _getIt = GetIt.instance;

void main() {
  _getIt.registerSingleton<StorageController>(StorageController(),
      signalsReady: true);
  _getIt.registerSingleton<UploadNotifier>(UploadNotifier(StorageController()),
      signalsReady: true);
  _getIt.registerSingleton<GeoLocationController>(GeoLocationController(),
      signalsReady: true);
  // String state = await _getIt<StorageController>().getState();
  // Locale locale = await getLocale();
  runApp(App());
}

class App extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _App _app = context.findAncestorStateOfType<_App>();
    _app.setLocale(locale);
  }

  // final Locale locale;
  // final String state;
  // App(this.locale, this.state);
  _App createState() => _App();
}

class _App extends State<App> {
  // This widget is the root of your application.
  Locale _locale;

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      this._locale = locale;
    });
    super.didChangeDependencies();
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  void initState() {
    getLocale().then((locale) {
      _locale = locale;
    });
    _initOneSignal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getIt<StorageController>().getState(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("Startup Error"),
            );
          case ConnectionState.done:
            var _state = snapshot.data;
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'CEWERS.',
                locale: _locale,
                // actions: ActionsWidget,
                localizationsDelegates: localizationsDelegates,
                localeResolutionCallback: localeResolutionCallback,
                supportedLocales: supportedLocales,
                theme: ThemeData(
                  primaryColor: _getPrimaryColor(_state),
                  accentColor: _getSecondaryColor(_state),
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(
                      color: Theme.of(context)
                          .primaryColor, //change your color here
                    ),
                    textTheme: TextTheme(
                      headline1: appBarStyle()
                          .apply(color: Theme.of(context).primaryColor),
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                  ),
                  textTheme: TextTheme(
                    button: TextStyle(
                      fontFamily: fontRoboto,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 28,
                    ),
                    bodyText2: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    headline1: titleStyle()
                        .apply(color: Theme.of(context).primaryColor),
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
                  WelcomeScreen.route: (context) => WelcomeScreen(),
                  AlertListScreen.route: (context) => AlertListScreen(),
                  FeedbackScreen.route: (context) => FeedbackScreen(),
                  HomeScreen.route: (context) => HomeScreen(),
                  LoginScreen.route: (context) => LoginScreen(),
                  HeatMap.route: (context) => HeatMap(),
                  MediaUploadScreen.route: (context) => MediaUploadScreen(null),
                  SendReportScreen.route: (context) => SendReportScreen(null),
                  ReportNotification.route: (context) =>
                      ReportNotification(null, null),
                  SelectStateScreen.route: (context) => SelectStateScreen(),
                  SignUpScreen.route: (context) => SignUpScreen(),
                  SelectCrimeScreen.route: (context) => SelectCrimeScreen(),
                  SuccessScreen.route: (context) => SuccessScreen(),
                  SosScreen.route: (context) => SosScreen(),
                  "/": (context) =>
                      _state == null ? SelectStateScreen() : WelcomeScreen()
                });
            break;
          default:
            return _loading;
        }
      },
    );
  }

  Scaffold _loading = Scaffold(
    body: Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
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
