import 'dart:convert';

import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/select-state.dart';
import 'package:cewers/screens/welcome.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

GetIt _getIt = GetIt.instance;

void main() {
  _getIt.registerSingleton<StorageController>(StorageController(),
      signalsReady: true);
  _getIt.registerSingleton<UploadNotifier>(UploadNotifier(StorageController()),
      signalsReady: true);
  _getIt.registerSingleton<GeoLocationController>(GeoLocationController(),
      signalsReady: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  Future future;
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

  @override
  void initState() {
    future = _getIt<StorageController>().getState();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> initOnseSignal() async {
    final credentials = await rootBundle.loadString("assets/google.json");
    var keys = json.decode(credentials);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(keys["oneSignalKey"], iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return MaterialApp(
              title: 'CEWERS.',
              theme: ThemeData(
                primaryColor: _getPrimaryColor(snapshot.data),
                accentColor: _getSecondaryColor(snapshot.data),
                appBarTheme: AppBarTheme(
                  textTheme: TextTheme(
                    headline1: appBarStyle()
                        .apply(color: Theme.of(context).primaryColor),
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
                  headline1:
                      titleStyle().apply(color: Theme.of(context).primaryColor),
                  headline6: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              home: (snapshot.data == null)
                  ? SelectStateScreen()
                  : WelcomeScreen(),
              debugShowCheckedModeBanner: false,
            );
            break;
          case ConnectionState.waiting:
            return _loading;
            break;
          case ConnectionState.none:
            return _loading;
            break;
          case ConnectionState.active:
            return _loading;
            break;
          default:
            return _loading;
        }
      },
    );
  }

  Widget _loading = MaterialApp(
    title: 'CEWERS.',
    home: Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
}
