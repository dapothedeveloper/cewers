import 'package:cewers/bloc/alert-list.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/model/alert.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:flutter/material.dart';

class AlertListScreen extends StatefulWidget {
  _AlertListScreen createState() => _AlertListScreen(AlertsBloc());
}

class _AlertListScreen extends State<AlertListScreen> {
  Future future;
  final AlertsBloc _aletsBloc;
  _AlertListScreen(this._aletsBloc);
  void initState() {
    super.initState();
    future = _aletsBloc.getAlerts();
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
                  return loading;
                }

                break;
              default:
                return loading;
                break;
            }
          }),
    );
  }

  Widget getErrorContainer(AsyncSnapshot snapshot) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 3),
        child: Center(child: Text("ERROR: ${snapshot?.data?.message}")));
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
              child: Text(f?.comment ?? "no comment"),
            ))
        .where(notNull)
        .toList();
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
