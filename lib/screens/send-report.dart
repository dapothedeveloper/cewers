// import 'package:cewers/controller/location.dart';

import 'package:cewers/bloc/send-report.dart';
import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/notifier/report-image.dart';
import 'package:cewers/screens/report-notification.dart';
import 'package:cewers/service/api.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
// import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class SendReportScreen extends StatefulWidget {
  final String _crime;

  SendReportScreen(this._crime);
  _SendReportScreen createState() => _SendReportScreen();
}

class _SendReportScreen extends State<SendReportScreen> {
  SendReportBloc myBloc = new SendReportBloc(StorageController(), API());
  String errorMessage;
  TextEditingController details = new TextEditingController();
  bool useLocation = true;
  final formKey = GlobalKey<FormState>();
  String _userId;
  var imageProvider;
  double longitude;
  double latitude;
  void initState() {
    myBloc.getUserId().then((userId) {
      _userId = userId;
    }).catchError((e) {
      print(e);
    });

    GeoLocationController()
        .getCoordinates()
        .then((value) => setCoordinates)
        .catchError((e) {
      print("==============ERROR===========");
      print(e);
    });
    super.initState();
  }

  void dispose() {
    super.dispose();
    details?.dispose();
    formKey?.currentState?.dispose();
    // Scaffold.of(context).hideCurrentSnackBar();
  }

  Widget build(BuildContext context) {
    imageProvider = Provider.of<ReportImageNotifier>(context);
    return MainContainer(
      decoration: bgDecoration(),
      displayAppBar: CewerAppBar("Enter ", "Details"),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Consumer<ReportImageNotifier>(
          builder: (context, data, child) => ActionButtonBar(
            action: () {
              Map<String, dynamic> payload;
              payload = {
                "alert": {
                  "userId": _userId,
                  "alertType": widget._crime.toLowerCase(),
                  "location": "${latitude ?? 7.7238},${longitude ?? 8.5679}",
                  "priority": "medium",
                  "comment": details.text,
                  "pictures": ["${data.mediaFile?.path}" ?? ""],
                  "videos": ["video.mp4"]
                }
              };

              myBloc.sendReport(payload).then((value) {
                if (value is APIResponseModel) {
                  if (value.status) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportNotification(details.text,
                              latitude ?? 7.7238, longitude ?? 8.5679)),
                    );
                    setState(() {
                      errorMessage = null;
                    });
                  } else {
                    setState(() {
                      errorMessage = value.message;
                    });
                  }
                } else {
                  setState(() {
                    errorMessage = "Invalid response type";
                  });
                }
              }).catchError((e) {
                print(e);
                setState(() {
                  errorMessage = "Unexpected error";
                });
              });

              // print(response);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         ReportNotification(details.text, "Lagos "),
              //   ),
              // );
            },
            text: "SUBMIT",
          ),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(children: [
          // Text(widget._crime),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: errorMessage != null
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                      : null,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  height: 200,
                  child: TextField(
                    minLines: 30,
                    maxLines: 50,
                    decoration: InputDecoration(
                      hintText: 'Enter details',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 30.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Colors.black, width: 0.0),
                      ),
                    ),
                    controller: details,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            imageProvider.openCamera();
                            // do something
                          },
                        ),
                      ),
                      Text("Upload picture or video evidence"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: null,
                      ),
                    ],
                  ),
                ),
                Consumer<ReportImageNotifier>(
                  builder: (context, data, child) => Container(
                      child: (data.mediaFile != null)
                          ? Image.file(data.mediaFile)
                          : null),
                ),

                // Row(children: [
                //   Switch(
                //     value: useLocation,
                //     onChanged: (value) async {
                //       if (value) {
                //         print(location.data?.latitude);
                //       }
                //       setState(() {
                //         useLocation = value;
                //         print(useLocation);
                //       });
                //     },
                //   ),
                //   Text("Use my location")
                // ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void setCoordinates(dynamic coordinates) {
    print(coordinates);
    if (coordinates is LocationData) {
      latitude = coordinates.latitude;
      longitude = coordinates.longitude;
    } else {
      latitude = 0;
      longitude = 0;
    }
  }
}
