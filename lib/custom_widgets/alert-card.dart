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

import 'package:get_it/get_it.dart';

import '../model/error.dart';
import '../service/api.dart';

class AlertCard extends StatefulWidget {
  final AlertsModel data;
  final String state;
  final bool isSpecialAgent;
  final BuildContext scaffoldContext;
  AlertCard(
    this.data,
    this.state,
    this.isSpecialAgent, {
    Key key,
    @required this.scaffoldContext,
  }) : super(key: key);
  _AlertCard createState() => _AlertCard();
}

class _AlertCard extends State<AlertCard> {
  Future future;
  initState() {
    super.initState();
    future = _getCloudinaryBaseUrl();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        var coordinates;
        String categoryIcon;
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
            coordinates = widget.data is AlertsModel
                ? _splitCoordinates(widget.data.location)
                : null;
            categoryIcon = widget.data is AlertsModel &&
                    widget.data.alertType == "Dispute/clash over Land ownership"
                ? "herdsmen"
                : widget.data?.alertType;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
                width: MediaQuery.of(context).size.width - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                  // textBaseline: TextBaseline.alphabetic,
                  children: [
                    widget.data.picture is List<String> &&
                            widget.data.picture.toString().contains(".jpg")
                        ? CachedNetworkImage(
                            imageUrl: snapshot.data +
                                "/${widget.state}/" +
                                widget.data.picture[0],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/placeholder.png",
                              fit: BoxFit.fill,
                            ),
                          )
                        : Image.asset(
                            "assets/images/placeholder.png",
                            fit: BoxFit.fill,
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
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      _shortenText(widget?.data?.comment ?? "No comment"),
                      style: TextStyle(
                          fontFamily: fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black54),
                    ),
                    LabeledText("Status: ", widget?.data?.status?.capitalize()),
                    LabeledText("Date: ",
                        "${widget.data.createdAt.day}/${widget.data.createdAt.month}/${widget.data.createdAt.year} ${widget.data.createdAt.hour}:${widget.data.createdAt.minute}"),
                    LabeledText(
                        "Landmark:", widget.data?.landmark ?? "Not reported"),
                    LabeledText("Location: ", ":",
                        widget: Flexible(
                          child: coordinates == null
                              ? Text("Not reported")
                              : CoordinateTranslator(coordinates),
                        )),
                    LabeledText("LGA: ",
                        widget.data?.localGovernment ?? "Not available"),
                    LabeledText("Community:",
                        widget.data?.community ?? "Not available"),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          widget.isSpecialAgent == true
                              ? AlertVerificationWidget(
                                  widget.data.id,
                                  widget.data.status,
                                  widget.data.alertType,
                                  widget.scaffoldContext)
                              : Container(
                                  width: 1,
                                  height: 1,
                                ),
                          Image.asset(
                            "assets/icons/$categoryIcon.png",
                            height: 42,
                            width: 42,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
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

  List<String> _splitCoordinates(String coordinates) {
    if (coordinates == null) {
      return null;
    }
    var split = coordinates.contains(",") ? coordinates.split(",") : null;
    return split.length == 2 ? split : null;
  }

  Future<String> _getCloudinaryBaseUrl() async {
    final credentials = await rootBundle.loadString("assets/cloudinary.json");
    APIKeys auth = APIKeys.getBaseUrl(json.decode(credentials));
    // print(auth.baseUrl);
    return auth.baseUrl;
  }

  String _shortenText(String text) {
    if (text.length > 100) return text.substring(0, 99) + "...";
    return text;
  }
}

class AlertVerificationWidget extends StatefulWidget {
  final String status;
  final String alertType;
  final String id;
  final BuildContext scaffoldContext;
  AlertVerificationWidget(
      this.id, this.status, this.alertType, this.scaffoldContext);
  _AlertVerificationWidget createState() => _AlertVerificationWidget();
}

class _AlertVerificationWidget extends State<AlertVerificationWidget> {
  String _status;
  API api = GetIt.I<API>();
  initState() {
    super.initState();
    setState(() {
      _status = widget.status;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  groupValue: _status,
                  value: 'rejected',
                  onChanged: (status) {
                    _confirmDialog(status, "Reject");
                  },
                ),
                Text("Reject"),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  groupValue: _status,
                  value: 'approved',
                  onChanged: (status) {
                    _confirmDialog(status, "Approve");
                  },
                ),
                Text('Approve'),
              ],
            ),
          )
        ],
      ),
    );
  }

  _updateStatus(String status) {
    api.postRequest("update-alert ", {"_id": widget.id, "status": status}).then(
        (resp) {
      if (resp is APIError) {
        _showUpdateInfo(resp.message, "failed");
      } else {
        setState(() {
          _status = status;
        });
      }
    });
  }

  _showUpdateInfo(String message, String requestStatus) {
    showDialog(
      context: widget.scaffoldContext,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(widget.scaffoldContext).size.width / 1.3,
          height: MediaQuery.of(widget.scaffoldContext).size.height / 5,
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Update $requestStatus",
                    style: TextStyle(fontSize: 24),
                  ),
                  Divider(height: 5),
                  Text(
                    message ?? "",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _confirmDialog(String status, String statusText) {
    showDialog(
      context: widget.scaffoldContext,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(widget.scaffoldContext).size.width / 1.3,
          height: MediaQuery.of(widget.scaffoldContext).size.height / 5,
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to $statusText this ${widget.alertType} alert",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: Text(
                            statusText,
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            _updateStatus(status);
                            Navigator.pop(widget.scaffoldContext);
                          },
                        ),
                        InkWell(
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          onTap: () => Navigator.pop(widget.scaffoldContext),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
