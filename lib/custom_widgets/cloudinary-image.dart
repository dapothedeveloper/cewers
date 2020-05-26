import 'package:cached_network_image/cached_network_image.dart';
import 'package:cewers/bloc/send-report.dart';
import 'package:cewers/custom_widgets/coordinates-tranlator.dart';
import 'package:cewers/custom_widgets/labeled-text.dart';
import 'package:cewers/model/alert.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cewers/extensions/string.dart';
import 'dart:convert';

class CloudinaryImage extends StatefulWidget {
  final AlertsModel data;
  final String state;
  CloudinaryImage(this.data, this.state, {Key key}) : super(key: key);
  _CloudinaryImage createState() => _CloudinaryImage();
}

class _CloudinaryImage extends State<CloudinaryImage> {
  Future future;
  initState() {
    super.initState();
    future = _getCloudinaryBaseUrl();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return CircularProgressIndicator();
            break;
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          case ConnectionState.active:
            return CircularProgressIndicator();
            break;
          case ConnectionState.done:
            return Card(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
                width: MediaQuery.of(context).size.width - 20,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.data.picture != null &&
                                !snapshot.hasError
                            ? snapshot.data +
                                "/${widget.state}/" +
                                widget.data.picture[0]
                            : "unknown.jpg" ??
                                Image.asset("assets/images/placeholder.png"),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        heightFactor: 2,
                        child: Text(
                          widget.data?.alertType?.capitalize(),
                          style: TextStyle(
                              fontFamily: fontRoboto,
                              fontWeight: FontWeight.w700,
                              fontSize: 26,
                              color: Colors.black87),
                        ),
                      ),
                      Text(
                        _shortenText(widget.data?.comment ?? "No comment"),
                        style: TextStyle(
                            fontFamily: fontRoboto,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54),
                      ),
                      LabeledText("Status: ", widget.data.status.capitalize()),
                      LabeledText("Date: ", widget.data.createdAt),
                      LabeledText("Location ", ":",
                          widget: Flexible(
                              child:
                                  CoordinateTranslator(widget.data.location))),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                size: 42,
                                color: Colors.black38,
                              ),
                              Image.asset(
                                "assets/icons/${widget.data?.alertType}.png",
                                height: 42,
                                width: 42,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ))
                    ]),
              ),
            );
            break;
          default:
            return CircularProgressIndicator();
            break;
        }
      },
    );
  }

  Future<String> _getCloudinaryBaseUrl() async {
    final credentials = await rootBundle.loadString("assets/cloudinary.json");
    CloudinaryCredential auth =
        CloudinaryCredential.getBaseUrl(json.decode(credentials));
    // print(auth.baseUrl);
    return auth.baseUrl;
  }

  String _shortenText(String text) {
    if (text.length > 100) return text.substring(0, 99) + "...";
    return text;
  }
}
