import 'package:cewers/bloc/sign_up.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/form-field.dart';
import 'package:cewers/custom_widgets/lga-dropdown.dart';
// import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/model/lga.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/screens/success.dart';
import 'package:cewers/style.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = "/signUp";
  // SignUpScreen([this.username]);
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _signUpKey = GlobalKey<FormState>();
  TextEditingController fullname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  SignUpBloc _signupBloc = new SignUpBloc();
  List<LocalGovernmentModel> localGovernmentList;

  String gender;
  String localGovernment;
  String community;
  Future lgaDropdown;

  void initState() {
    lgaDropdown = _signupBloc.getLocalGovernment();
    setState(() {
      gender = "male";
      localGovernment = "-";
      community = "-";
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    var phone = ModalRoute.of(context).settings.arguments ?? "";
    phoneNumber.text = phone.toString();
    return MaterialApp(
      theme: Theme.of(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // decoration: bgDecoration(),
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
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
                                    translate(context, FULL_NAME),
                                    "assets/icons/person.png"),
                                validator: (value) {
                                  return value.isEmpty
                                      ? "Name is required"
                                      : null;
                                },
                              ),
                            ),
                            FormTextField(
                              textFormField: TextFormField(
                                controller: phoneNumber,
                                decoration: formDecoration(
                                    translate(context, PHONE_NUMBER),
                                    "assets/icons/phone-icon.png"),
                                validator: (value) {
                                  return value.isEmpty
                                      ? "Phone number is required"
                                      : null;
                                },
                              ),
                            ),
                            // ),
                            FormTextField(
                              textFormField: TextFormField(
                                controller: email,
                                decoration: formDecoration(
                                    translate(context, EMAIL_ADDRESS),
                                    "assets/icons/envelope.png"),
                              ),
                            ),
                            LocalGovernmentDropdown(
                              allLgaAndComm: lgaDropdown,
                              // selectLocalGoverment:(){} ,
                              // selectedCommunity: (){},
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DropdownButton list =
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
                  builder: (_) => SuccessScreen(phoneNumber.text)),
            );
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
        // print(onError);
        // print("Unexpected error");
      });
    }
  }

  void _genderHandler(String value) {
    setState(() {
      gender = value;
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
