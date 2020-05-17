import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/screens/alerts.dart';
import 'package:flutter/material.dart';

class ReportNotification extends StatefulWidget {
  final String report;
  final double latitude;
  final double longitude;
  ReportNotification(this.report, this.latitude, this.longitude, {Key key})
      : super(key: key);
  _ReportNotification createState() => _ReportNotification();
}

class _ReportNotification extends State<ReportNotification> {
  Future _future;

  initState() {
    // _future =
    super.initState();
  }

  Widget build(BuildContext context) {
    return MainContainer(
        decoration: null,
        displayAppBar: CewerAppBar("Alert ", "Recieved!"),
        child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 24),
                child: Column(
                  children: <Widget>[
                    SafeArea(
                      minimum: EdgeInsets.only(top: 20, bottom: 25),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Report Details",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          )),
                    ),
                    Align(
                      // heightFactor: 2,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Location: ",
                          ),
                          FutureBuilder(
                            future: _future,
                            builder: (context, snapshot) => Text(
                                snapshot.data ??
                                    "${widget.latitude}, ${widget.longitude}"),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.report ?? "."),
                    ),
                    Align(
                      heightFactor: 2,
                      alignment: Alignment.bottomRight,
                      child: ActionButtonBar(
                        text: "VIEW ALERTS",
                        action: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlertListScreen()));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  void dispose() {
    super.dispose();
    Scaffold.of(context).hideCurrentSnackBar();
  }
}

// {
// 	"alert":{
// 		"userId":"5e9ea7e2337e4322391c758b",
// 		"alertType":"crime",
// 		"location":"6.4623144,3.4778092",
// 		"priority": "medium",
// 		"comment": "testing2",
// 		"pictures": ["picture1.png", "picture2.png"],
// 		"videos": ["video1.png", "video2.png"]
// 	}
// }
