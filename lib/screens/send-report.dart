// import 'package:cewers/controller/location.dart';

import 'package:cewers/bloc/send-report.dart';
import 'package:cewers/controller/location.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
// import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/model/media-upload.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/model/user-location.dart';
import 'package:cewers/notifier/report-image.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/media-upload.dart';
import 'package:cewers/service/api.dart';
// import 'package:cewers/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      // decoration: bgDecoration(),
      appBar: AppBar(title: CewerAppBar("Enter ", "Details")),
      body: Container(
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
                        borderSide: BorderSide(color: Colors.black, width: 0.0),
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
                        borderSide: BorderSide(color: Colors.black, width: 0.0),
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
            action: () {
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

              myBloc.sendReport(payload).then((value) {
                if (value is APIResponseModel) {
                  if (value.status) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<UploadNotifier>(
                          create: (context) =>
                              UploadNotifier(StorageController()),
                          child: MediaUploadScreen(MediaUploadModel(
                              data.mediaFile?.path,
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
            },
            text: "SUBMIT",
          ),
        ),
      ),
    );
  }

  void setUserId(String userId) {
    _userId = userId;
    print(_userId);
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

  String _validateLandmark(String text) {
    if (text == null && latitude == null) {
      return "Landmark validation failed";
    } else {
      return null;
    }
  }
}
