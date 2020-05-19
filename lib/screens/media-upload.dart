import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/model/media-upload.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/report-notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaUploadScreen extends StatefulWidget {
  final MediaUploadModel data;
  MediaUploadScreen(this.data);
  _MediaUploadScreen createState() => _MediaUploadScreen();
}

class _MediaUploadScreen extends State<MediaUploadScreen> {
  var uploadProvider;

  Widget errorWidget;
  initState() {
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    uploadProvider = Provider.of<UploadNotifier>(context, listen: false);

    return Consumer(builder: (context, UploadNotifier data, child) {
      if (data.status == null)
        uploadProvider
            .uploadImage(widget.data.filePath, widget.data.fileName,
                widget.data.timeStamp)
            .catchError((e) {
          uploadProvider.setError(e);
        });
      return MainContainer(
        decoration: null,
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.5,
                      bottom: 10),
                  child: Center(child: Text("Alert sent!"))),
              Stack(
                children: <Widget>[
                  AnimatedContainer(
                    height: 20,
                    margin: EdgeInsets.only(top: 2, right: 2, left: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                    ),
                    duration: Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width *
                        (data.progressPercentage ?? 30 / 100),
                    child: null,
                  ),
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("${data.status ?? 'connecting'}"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 20),
                    child: data.errorMessage == null
                        ? null
                        : Text(data.errorMessage,
                            style: TextStyle(color: Colors.red)),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.8),
                child: ActionButtonBar(
                  text: "PROCEED",
                  action: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportNotification(
                              widget.data.alertDescription,
                              widget.data.coordinates),
                        ));
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: errorWidget)
            ],
          ),
        ),
      );
    });
  }
}
