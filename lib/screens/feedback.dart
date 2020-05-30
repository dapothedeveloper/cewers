// import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/bloc/feedback.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/custom_widgets/tab.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/screens/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackScreen extends StatefulWidget {
  _FeedbackScreen createState() => _FeedbackScreen();
}

class FeedbackModel {
  final String typeValue;
  final String typeName;
  FeedbackModel(this.typeName, this.typeValue);
}

class _FeedbackScreen extends State<FeedbackScreen> {
  String feedbackType;
  TextEditingController message = TextEditingController();
  StorageController _storageController = StorageController();
  String errorMessage;
  FeedbackBloc _feedbackBloc = FeedbackBloc();
  bool loading;
  final List<FeedbackModel> feedbackTypes = [
    FeedbackModel("Complaint", 'complaint'),
    FeedbackModel("Responsiveness", 'responsiveness'),
    FeedbackModel("Efficiency", 'efficiency'),
    FeedbackModel("Ways of Improvement", 'improvement'),
    FeedbackModel("Technical Issues", 'issues'),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                        (e) => DropdownMenuItem(
                            value: e.typeValue,
                            onTap: () {},
                            child: Text(e.typeName)),
                      ),
                    ),
                ),
              ),
            ),
          ),
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
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Text(errorMessage ?? ""),
          ),
          Container(
            child: loading == true ? LinearProgressIndicator() : null,
          ),
          Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              child: ActionButtonBar(
                text: "Submit",
                action: () async {
                  setState(() {
                    errorMessage = "please wait...";
                    loading = true;
                  });
                  await sendFeedback(context).then((value) {
                    print("value");
                  }).catchError((e) => print(e));
                },
              ))
        ],
      )),
      bottomNavigationBar: BottomTab(),
    );
  }

  Future<void> sendFeedback(BuildContext context) async {
    String userId = await _storageController.getUserId();

    var payload = {
      "comment": message.text,
      "feedback": feedbackType,
      "userId": userId ?? "anonymous"
    };
    print("one");
    final response = await _feedbackBloc.submitFeedback(payload);
    print("Yoo");
    print(payload);

    if (response is APIResponseModel) {
      setState(() {
        errorMessage = null;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SuccessScreen("feedback")));
    }
    if (response is APIError) {
      setState(() {
        errorMessage = response.message;
      });
    } else {
      setState(() {
        errorMessage = "Unexpected error";
      });
    }
    setState(() {
      loading = false;
    });
  }
}
