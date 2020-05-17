import 'package:cewers/bloc/sign_up.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/form-field.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/screens/success.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static String route = "/signUp";
  final String username;
  SignUpScreen([this.username]);
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _signUpKey = GlobalKey<FormState>();
  TextEditingController fullname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  SignUpBloc _signupBloc = new SignUpBloc();
  List<Map<String, List<Map<String, List<String>>>>> allLocalGovernment = [
    {
      "benue": [
        {
          "Agatu": ["Aila", "Usha"]
        },
        {
          "Buruku": ["Binev", "Mbaya"]
        },
        {
          "Guma": ["Daudu", "Gbajimba"]
        },
        {
          "Kwande": ["Moon", "Yaav"]
        },
        {
          "Logo": ["Tombo-oAyilamo", "Tswarev-Ukemberagya"]
        }
      ]
    }
  ];

  String gender;
  String localGovernment;
  String community;

  void initState() {
    super.initState();
    phoneNumber.text = widget.username;
    setState(() {
      gender = "male";
      localGovernment = "-";
      community = "-";
    });
  }

  Widget build(BuildContext context) {
    return MainContainer(
        decoration: bgDecoration(),
        bottomNavigationBar: Builder(
          builder: (context) => SafeArea(
            minimum: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: ActionButtonBar(
              text: "SIGN UP",
              action: () {
                // _signUpKey.currentState.validate();
                registerUser(context);
              },
            ),
          ),
        ),
        child: Container(
          child: ListView(
            children: <Widget>[
              Text(
                "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .apply(color: Theme.of(context).primaryColor),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _signUpKey,
                      child: SafeArea(
                        minimum: EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          children: [
                            FormTextField(
                              textFormField: TextFormField(
                                controller: fullname,
                                decoration: formDecoration(
                                    "Full name", "assets/icons/person.png"),
                                validator: (value) {
                                  return value.isEmpty
                                      ? "Name is required"
                                      : null;
                                },
                              ),
                            ),
                            StreamBuilder(
                              stream: null,
                              builder: (context, snapshot) => FormTextField(
                                textFormField: TextFormField(
                                  controller: phoneNumber,
                                  decoration: formDecoration("Phone number*",
                                      "assets/icons/phone.png"),
                                  validator: (value) {
                                    return value.isEmpty
                                        ? "Phone number is required"
                                        : null;
                                  },
                                ),
                              ),
                            ),
                            FormTextField(
                              textFormField: TextFormField(
                                controller: email,
                                decoration: formDecoration("Email address",
                                    "assets/icons/envelope.png"),
                              ),
                            ),
                            FormTextField(
                              textFormField: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  icon: Icon(Icons.location_city),
                                  hintText: "Address",
                                  // border: InputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: "male",
                                  groupValue: gender,
                                  onChanged: _genderHandler,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _genderHandler("male");
                                    },
                                    child: Text("Male")),
                                Radio(
                                  value: "female",
                                  groupValue: gender,
                                  onChanged: _genderHandler,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _genderHandler("female");
                                    },
                                    child: Text("Female")),
                              ],
                            ),
                            Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Text("Local government"),
                              ),
                              DropdownButton(
                                hint: Text("Select"),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "none",
                                    child: new Text("-"),
                                  ),
                                ],
                                onChanged: setLocalGovernment,
                              ),
                            ]),
                            Row(children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text("Select")),
                              DropdownButton(
                                hint: Text("Community"),
                                onChanged: setCommunity,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'none',
                                    child: new Text("-"),
                                  ),
                                ],
                              )
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void registerUser(BuildContext context) {
    if (_signUpKey.currentState.validate()) {
      _signUpKey.currentState.save();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please wait..."),
        ),
      );
      var payload = {
        "user": {
          "fullName": fullname.text,
          "email": email.text,
          "phoneNumber": phoneNumber.text,
          "gender": gender,
          "address": address.text,
          "localGovernment": localGovernment,
          "community": community,
          "userType": "citizen",
        }
      };
      /**
       * Confirm password combination
       */
      _signupBloc.register(payload).then((response) {
        if (response is APIResponseModel) {
          if (response.status) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SuccessScreen(phoneNumber.text)));
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(response.message),
              ),
            );
          }
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(response.message),
            ),
          );
        }

        //Api response
      }).catchError((onError) {
        print(onError);
        print("Unexpected error");
      });
    }
  }

  void _genderHandler(String value) {
    setState(() {
      gender = value;
    });
  }

  setLocalGovernment(String lga) {
    setState(() {
      localGovernment = lga;
    });
  }

  setCommunity(String comm) {
    setState(() {
      community = comm;
    });
  }

  void dispose() {
    _signUpKey.currentState?.dispose();
    fullname?.dispose();
    email?.dispose();
    phoneNumber?.dispose();
    Scaffold.of(context).hideCurrentSnackBar();
    super.dispose();
  }
}
