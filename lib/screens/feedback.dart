// import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/custom_widgets/tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackScreen extends StatefulWidget {
  _FeedbackScreen createState() => _FeedbackScreen();
}

class _FeedbackScreen extends State<FeedbackScreen> {
  String feedbackType;
  TextEditingController message = TextEditingController();
  final feedbackTypes = [
    "Complaint",
    "Responsiveness",
    "Efficiency",
    "Ways of Improvement",
    "Technical Issues",
  ];
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MainContainer(
      displayAppBar: CewerAppBar("Feedback", ""),
      decoration: null,
      child: Container(
          child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
            onChanged: (x) {
              setState(() {
                feedbackType = x;
              });
            },
            isExpanded: true,
            value: feedbackType,
            hint: Text("Select feedback type"),
            items: []..addAll(
                feedbackTypes.map(
                  (e) =>
                      DropdownMenuItem(value: e, onTap: () {}, child: Text(e)),
                ),
              ),
          ))),
          Card(
            child: TextFormField(
              controller: message,
              maxLines: 10,
              minLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                labelText: "Enter details",
              ),
            ),
          ),
          Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 5))
        ],
      )),
      bottomNavigationBar: BottomTab(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
