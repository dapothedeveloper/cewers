import 'package:cewers/bloc/alert-list.dart';
import 'package:cewers/custom_widgets/main-container.dart';
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
                return Container(
                  child: ListView(
                    children: <Widget>[]..addAll(
                        (snapshot.data is APIError)
                            ? [getErrorContainer(snapshot)]
                            : [
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    child: Center(
                                        child: Text(
                                            "${snapshot.data.data.length} Alerts avaialble"))),
                              ],
                      ),
                  ),
                );
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

  getSuccessList(AsyncSnapshot snapshot) {
    print(snapshot.data.data[0]);
    if (snapshot.data is APIResponseModel && snapshot.data.data is List) {
      return snapshot.data.data.map((f) {
        return Card(
          child: Text("Welcome to report page"),
        );
      });
    } else {
      return [
        Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 3),
            child: Center(child: Text("No resent alerts.")))
      ];
    }
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
