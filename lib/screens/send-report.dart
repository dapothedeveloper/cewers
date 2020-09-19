// import 'package:cewers/controller/location.dart';

import 'package:cewers/bloc/send-report.dart';
import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/model/media-upload.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/model/user-location.dart';
import 'package:cewers/notifier/report-image.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/media-upload.dart';
import 'package:cewers/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

const SMS_PHONE = 14012716411;

class SendReportScreen extends StatefulWidget {
  final String _crime;

  static const String route = "/sendReport";
  SendReportScreen(this._crime);
  _SendReportScreen createState() => _SendReportScreen(StorageController());
}

class _SendReportScreen extends State<SendReportScreen> {
  final formKey = GlobalKey<FormState>();
  final StorageController storageController;
  SendReportBloc myBloc = new SendReportBloc(API());
  TextEditingController details = new TextEditingController();
  TextEditingController landmark = new TextEditingController();
  GetIt _getIt = GetIt.instance;
  String errorMessage;
  String _userId;
  bool useLocation = true;

  var imageProvider;
  String filePath;
  double longitude;
  double latitude;

  _SendReportScreen(this.storageController);

  void initState() {
    storageController.getUserId().then(setUserId).catchError((e) {
      print(e);
    });

    _getIt<GeoLocationController>()
        .getCoordinates()
        .then(setCoordinates)
        .catchError((e) {
      // print("==============ERROR===========");
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: Scaffold(
        // decoration: bgDecoration(),

        appBar: AppBar(title: CewerAppBar("Enter ", "Details")),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
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
                        hintText: translate(context, ENTER_DETAILS),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 30.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.0),
                        ),
                      ),
                      controller: details,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: landmark,
                      validator: _validateLandmark,
                      decoration: InputDecoration(
                        hintText: 'Landmark of event',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 30.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.0),
                        ),
                      ),
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
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Consumer<ReportImageNotifier>(
            builder: (context, data, child) => ActionButtonBar(
              action: () async {
                Map<String, dynamic> payload;

                filePath = data.mediaFile?.path;
                int timeStamp = DateTime.now().millisecondsSinceEpoch;
                String fileName = filePath != null
                    ? "$_userId-$timeStamp.${filePath.split('.').last}"
                    : null;

                payload = {
                  "alert": {
                    "userId": _userId,
                    "alertType": widget._crime.toLowerCase(),
                    "location": "${latitude ?? 0},${longitude ?? 0}",
                    "priority": "medium",
                    "comment": details.text,
                    "landmark": landmark.text,
                    "pictures": ["$fileName"],
                    "videos": ["$fileName"]
                  }
                };
                var thereIsInternetConnection =
                    await _internetConnectivityTest();
                if (thereIsInternetConnection) {
                  submit(context, payload, timeStamp, data.mediaFile?.path,
                      fileName);
                } else {
                  sendMessage(
                      "Details: ${details.text} \nLandmark: ${landmark.text}");
                }
              },
              text: "SUBMIT",
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _internetConnectivityTest() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      // print('not connected');
      return false;
    }
  }

  sendMessage(String message) async {
    var url = Platform.isAndroid
        ?
        //FOR Android
        'sms:?${SMS_PHONE}body=$message'
        : 'sms:$SMS_PHONE&body=$message';

    await launch(url);
  }

  void setUserId(String userId) {
    _userId = userId;
    // print(_userId);
  }

  void setCoordinates(UserCoordinateModel coordinates) {
    if (coordinates.errorMessage == null) {
      latitude = coordinates.latitude;
      longitude = coordinates.longitude;
    } else {
      setState(() {
        errorMessage = coordinates.errorMessage.toString();
      });
    }
  }

  submit(BuildContext context, dynamic payload, int timeStamp, String filePath,
      String fileName) {
    // print("Submitted");
    myBloc.sendReport(payload).then((value) {
      // print(value);
      if (value is APIResponseModel) {
        if (value.status) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<UploadNotifier>(
                create: (context) => UploadNotifier(StorageController()),
                child: MediaUploadScreen(MediaUploadModel(
                    filePath,
                    timeStamp,
                    fileName,
                    details.text,
                    "${latitude ?? 0},${longitude ?? 0}")),
              ),
            ),
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
      // print(e);
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  String _validateLandmark(String text) {
    if (text == null && latitude == null) {
      return "Landmark validation failed";
    } else {
      return null;
    }
  }
}
