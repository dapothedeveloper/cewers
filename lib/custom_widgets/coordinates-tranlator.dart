import 'package:cewers/controller/location.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get_it/get_it.dart';

class CoordinateTranslator extends StatefulWidget {
  final String coordinates;
  _CoordinateTranslator createState() => _CoordinateTranslator();
  CoordinateTranslator(this.coordinates, {Key key}) : super(key: key);
}

class _CoordinateTranslator extends State<CoordinateTranslator> {
  Future future;
  initState() {
    super.initState();
    double latitude = double.parse(splitCoordinates(widget.coordinates).first);
    double longitude = double.parse(splitCoordinates(widget.coordinates).last);
    future = GeoLocationController().getNamedLocation(latitude, longitude);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return LinearProgressIndicator();
            break;
          case ConnectionState.waiting:
            return LinearProgressIndicator();
            break;
          case ConnectionState.active:
            return LinearProgressIndicator();
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Flexible(
                  child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.red),
              ));
            } else {
              if (snapshot.data == null) {
                return Text("Location service unavailable");
              } else if (snapshot.data is List<Address> &&
                  snapshot.data.length != 0) {
                List<Address> location = snapshot.data;
                return Text(location[0]?.locality ?? "No data");
              }

              return Text(
                "Location service unavailable",
                style: TextStyle(
                  color: Colors.red,
                ),
              );
            }
            break;
          default:
            return LinearProgressIndicator();
            break;
        }
      },
    );
  }

  List<String> splitCoordinates(String coordinates) {
    var split = coordinates.split(",");
    throwIf(coordinates == null, "Location not reported");
    throwIf(split.length != 2, "Invalid coordinates");
    return split;
  }
}
