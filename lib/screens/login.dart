import 'package:cewers/bloc/login.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/form-field.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:cewers/style.dart';
import 'package:provider/provider.dart';

import 'package:cewers/notifier/page-view.dart';
import 'index.dart';
import 'password.dart';

class LoginScreen extends StatefulWidget {
  final String phoneNumber;
  static const String route = "/login";
  LoginScreen([this.phoneNumber]);
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController phoneNumber = new TextEditingController();
  LoginBloc _loginBloc = LoginBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final loginFormKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    phoneNumber.text = widget.phoneNumber;
    _scaffoldKey?.currentState?.removeCurrentSnackBar();
  }

  @override
  void didChangeDependencies() {
    phoneNumber.text = widget.phoneNumber;

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: CewerAppBar("", "CEWERS.")),
      key: _scaffoldKey,
      body: SafeArea(
        minimum: EdgeInsets.only(
            left: 30, right: 30, top: MediaQuery.of(context).size.height / 10),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: height / 6),
              child: Form(
                key: loginFormKey,
                child: Column(children: <Widget>[
                  SafeArea(
                    minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        translate(context, LOGIN),
                        style: titleStyle().apply(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: _loginBloc.phoneNumber,
                    builder: (_, snapshot) => FormTextField(
                      textFormField: TextFormField(
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        decoration: formDecoration(
                            translate(context, PHONE_NUMBER),
                            "assets/icons/person.png",
                            snapshot.hasError ? snapshot.error : null),
                        onChanged: _loginBloc.validate,
                        validator: (value) {
                          _loginBloc.validate(value);
                          return snapshot.hasError ? snapshot.error : null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(translate(context, NEW_USER) + "?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpScreen.route);
                          },
                          child: SafeArea(
                            minimum: EdgeInsets.only(left: 5),
                            child: Text(translate(context, SIGN_UP)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height / 4.8,
              ),
              child: ActionButtonBar(
                text: translate(context, LOGIN),
                action: () {
                  login();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() {
    try {
      loginFormKey.currentState.save();
      if (loginFormKey.currentState.validate()) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Please wait....",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
        var payload = {"phoneNumber": phoneNumber.text};
        _loginBloc.login(payload).then((resp) {
          _scaffoldKey.currentState.hideCurrentSnackBar();

          if (resp is bool) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Login failed"),
              backgroundColor: Colors.red,
            ));
            // ignore: unnecessary_statements
            phoneNumber.text.isNotEmpty ? showSignUpDialog() : null;
          } else if (resp is UserModel) {
            if (resp.userType.toLowerCase().trim() == "special_agent") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PasswordScreen(resp),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider<PageViewNotifier>(
                    create: (_) => PageViewNotifier(),
                    child: IndexPage(),
                  ),
                ),
              );
            }
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Unexpected API response"),
              backgroundColor: Colors.red,
            ));
            // Text();
          }
        }).catchError((onError) {
          debugPrint(onError.toString());
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Unexpected error occured"),
            backgroundColor: Colors.red,
          ));
        });
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e?.message ?? e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  showSignUpDialog() {
    showDialog(
      context: _scaffoldKey.currentContext,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(_scaffoldKey.currentContext).size.width / 1.3,
          height: MediaQuery.of(_scaffoldKey.currentContext).size.height / 5,
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "User phone number is invalid\nPlease enter correct phone number or proceed to sign up as a new user",
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
                            "Sign up",
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: gotoSignUp,
                        ),
                        InkWell(
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          onTap: () =>
                              Navigator.pop(_scaffoldKey.currentContext),
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

  gotoSignUp() {
    Navigator.pop(_scaffoldKey.currentContext);
    Navigator.pushNamed(
      _scaffoldKey.currentContext,
      SignUpScreen.route,
      arguments: phoneNumber.text,
    );
  }

  @override
  void dispose() {
    loginFormKey.currentState?.dispose();
    phoneNumber?.dispose();
    _loginBloc.dispose();
    super.dispose();
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String userType;
  final String state;

  UserModel(this.id, this.fullName, this.phoneNumber, this.email, this.userType,
      this.state);

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      map["_id"] as String,
      map["fullName"] as String,
      map["phoneNumber"] as String,
      map["email"] as String,
      map["userType"] as String,
      map["state"] as String,
    );
  }
}
