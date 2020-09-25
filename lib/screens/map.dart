import 'dart:async';
import 'dart:io';
// import 'dart:math';

import 'package:cewers/bloc/alert-list.dart';
import 'package:cewers/custom_widgets/tab.dart';
import 'package:cewers/model/alert.dart';
import 'package:cewers/model/error.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeatMap extends StatefulWidget {
  // HeatMap({Key key, this.text});
  static const String route = "heatMap";
  _HeatMap createState() => _HeatMap();
}

// typedef Marker MarkerUpdateAction(Marker marker);

class _HeatMap extends State<HeatMap> {
  // Completer<GoogleMapController> _controller = Completer();

  GoogleMapController controller;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // MarkerId selectedMarker;
  // int _markerIdCounter = 1;
  // static final LatLng center = const LatLng(7.33333, 8.75);
  Future future;
  AlertsBloc _aletsBloc = AlertsBloc();

  initState() {
    super.initState();
    future = _aletsBloc.getAlerts();
  }

  List<AlertsModel> parseAlert(List list) {
    // List<AlertsModel> alertList;
    return list != null && list.length > 0
        ? list.map((e) => AlertsModel.fromJson(e)).where(notNull).toList()
        : null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
                  // print(snapshot.data.data);
                  return getSuccessList(snapshot.data.data);
                } else {
                  return getErrorContainer(snapshot.error);
                }

                break;
              default:
                return loading;
                break;
            }
          }),
      bottomNavigationBar: BottomTab(),
    );
  }

  bool notNull(Object o) => o != null;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  GoogleMap getSuccessList(dynamic alerts) {
    var list = parseAlert(alerts); // alerts.data;
    var initPos = list != null ? list[0].location.split(",") : [];
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          zoom: 10,
          target: initPos.length == 2
              ? LatLng(double.parse(initPos[0]), double.parse(initPos[1]))
              : LatLng(0, 0)),
      onMapCreated: _onMapCreated,
      markers: initPos.length == 2
          ? list
              .map((alert) {
                if (alert.location is String && alert.location.contains(",")) {
                  var coordinates = alert.location.split(",");
                  return Marker(
                    markerId: MarkerId(DateTime.now().toIso8601String()),
                    position: LatLng(double.parse(coordinates[0]),
                        double.parse(coordinates[1])),
                  );
                }
              })
              .where(notNull)
              .toSet()
          : {Marker(markerId: MarkerId(DateTime.now().toIso8601String()))},
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

  Widget loading = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
  @override
  void dispose() {
    super.dispose();
  }
}
