import 'package:cewers/bloc/login.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/form-field.dart';
import 'package:cewers/custom_widgets/main-container.dart';
import 'package:cewers/screens/home.dart';
import 'package:cewers/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:cewers/style.dart';

class LoginScreen extends StatefulWidget {
  final String phoneNumber;
  LoginScreen([this.phoneNumber]);
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController phoneNumber = new TextEditingController();
  LoginBloc _loginBloc = new LoginBloc();

  final loginFormKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    phoneNumber.text = widget.phoneNumber;
  }

  Widget build(BuildContext context) {
    return MainContainer(
      decoration: bgDecoration(),
      bottomNavigationBar: Builder(
        builder: (context) => SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: ActionButtonBar(
            text: "Login",
            action: () {
              login(context);
            },
          ),
        ),
      ),
      child: ListView(
        children: <Widget>[
          SafeArea(
            minimum: EdgeInsets.only(
                left: 30,
                right: 30,
                top: MediaQuery.of(context).size.height / 10),
            child: Form(
              key: loginFormKey,
              child: Column(children: <Widget>[
                SafeArea(
                  minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: titleStyle().apply(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: _loginBloc.phoneNumber,
                  builder: (context, snapshot) => FormTextField(
                    textFormField: TextFormField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: formDecoration(
                          "Phone number",
                          "assets/icons/envelope.png",
                          snapshot.hasError ? snapshot.error : null),
                      onChanged: _loginBloc.validate,
                      validator: (value) {
                        _loginBloc.validate(value);
                        return snapshot.hasError ? snapshot.error : null;
                      },
                    ),
                  ),
                )
              ]),
            ),
          ),
          SafeArea(
            minimum: EdgeInsets.only(top: 20, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("New User?"),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: SafeArea(
                        minimum: EdgeInsets.only(left: 5),
                        child: Text("Sign Up"))),
              ],
            ),
          ),
          SafeArea(
            minimum: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/icons/google.png"),
                Image.asset("assets/icons/facebook.png"),
                Image.asset("assets/icons/email.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  login(BuildContext context) {
    loginFormKey.currentState.save();
    if (loginFormKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please wait...."),
        backgroundColor: Colors.black,
      ));
      var payload = {"phoneNumber": phoneNumber.text};
      _loginBloc.login(payload).then((success) {
        if (success is bool) {
          success
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      phoneNumber.text,
                    ),
                  ),
                );
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(success.message),
            backgroundColor: Colors.red,
          ));
        }
      }).catchError((onError) {
        print(onError);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Unexpected error occured"),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  @override
  void dispose() {
    loginFormKey.currentState?.dispose();
    phoneNumber?.dispose();
    Scaffold.of(context).hideCurrentSnackBar();
    super.dispose();
  }
}
