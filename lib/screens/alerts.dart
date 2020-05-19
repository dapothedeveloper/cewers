import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cewers/bloc/alert-list.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/model/alert.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cewers/extensions/string.dart';

class AlertListScreen extends StatefulWidget {
  _AlertListScreen createState() => _AlertListScreen(AlertsBloc());
}

class _AlertListScreen extends State<AlertListScreen> {
  Future future;
  final AlertsBloc _aletsBloc;
  String state;
  GetIt _getIt = GetIt.instance;
  _AlertListScreen(this._aletsBloc);
  void initState() {
    super.initState();
    future = _aletsBloc.getAlerts();
    _getIt<StorageController>()
        .getState()
        .then(setCurrentState)
        .catchError(errorHandle);
  }

  void setCurrentState(String value) {
    state = value;
  }

  void errorHandle(dynamic e) {
    print(e);
  }

  bool notNull(Object o) => o != null;

  Widget build(BuildContext context) {
    return MainContainer(
      decoration: null,
      child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return loading;
                break;
              case ConnectionState.none:
                return loading;
                break;
              case ConnectionState.active:
                return loading;
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data is APIError)
                    return Container(
                      child: ListView(
                        children: <Widget>[getErrorContainer(snapshot)],
                      ),
                    );
                  return Container(
                    child: ListView(
                      children: []..addAll(
                          getSuccessList(snapshot.data.data).where(notNull)),
                    ),
                  );
                } else {
                  return getErrorContainer(snapshot.error);
                }

                break;
              default:
                return loading;
                break;
            }
          }),
    );
  }

  Widget getErrorContainer(dynamic error) {
    var errorMessage;
    if (error is SocketException) errorMessage = "Connection error";
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 3),
        child: Center(
            child: Text(
          "ERROR: ${errorMessage ?? error.toString()}",
          style: TextStyle(
            color: Colors.red,
          ),
        )));
  }

  List<AlertsModel> parseAlert(List list) {
    // List<AlertsModel> alertList;
    return list.map((e) => AlertsModel.fromJson(e)).where(notNull).toList();
  }

  List<Widget> getSuccessList(dynamic alerts) {
    print(alerts?.length);
    // print(alerts.data);
    var list = parseAlert(alerts); // alerts.data;
    return list
        .map((f) => Card(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
                child: Column(children: [
                  CachedNetworkImage(
                    imageUrl: getImage(
                            f.picture != null ? f.picture[0] : "unknown.jpg") ??
                        Image.asset("name"),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 150,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 2,
                    child: Text(
                      f?.alertType?.capitalize(),
                      style: TextStyle(
                          fontFamily: fontRoboto,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          color: Colors.black87),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 1,
                    child: Text(
                      shortenText(f?.comment ?? "No comment"),
                      style: TextStyle(
                          fontFamily: fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black54),
                    ),
                  ),
                ]),
              ),
            ))
        .where(notNull)
        .toList();
  }

  String shortenText(String text) {
    if (text.length > 50) return text.substring(0, 50) + "...";
    return text;
  }

  String getImage(String publicId) {
    final baseUrl = "http://res.cloudinary.com/cousant/image";
    print("$baseUrl/${state ?? 'benue'}/$publicId");
    return "$baseUrl/${state ?? 'benue'}/$publicId";
  }

  Widget loading = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
  void dispose() {
    super.dispose();
  }
}
