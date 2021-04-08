import 'package:cewers/bloc/login.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/custom_widgets/form-field.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:flutter/material.dart';
import 'package:cewers/style.dart';
import 'package:provider/provider.dart';

import 'package:cewers/notifier/page-view.dart';
import '../localization/localization_constant.dart';
import 'index.dart';
import 'login.dart';

class PasswordScreen extends StatefulWidget {
  final UserModel user;
  PasswordScreen(this.user);
  _PasswordScreen createState() => _PasswordScreen();
}

class _PasswordScreen extends State<PasswordScreen> {
  TextEditingController password = new TextEditingController();
  LoginBloc _loginBloc = LoginBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final loginFormKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _scaffoldKey?.currentState?.removeCurrentSnackBar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: CewerAppBar("Enter", " Password.")),
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
                        translate(context, PASSWORD),
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
                        controller: password,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: formDecoration(
                            translate(context, PASSWORD),
                            "assets/icons/lock.png",
                            snapshot.hasError ? snapshot.error : null),
                      ),
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
                  agentLogin();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  agentLogin() {
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
        var payload = {
          "phoneNumber": widget.user.id,
          "password": password.text
        };
        _loginBloc.agentLogin(payload).then((success) {
          _scaffoldKey.currentState.hideCurrentSnackBar();

          if (success is bool) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Login failed"),
              backgroundColor: Colors.red,
            ));
            // ignore: unnecessary_statements
          } else if (success is UserModel) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider<PageViewNotifier>(
                  create: (_) => PageViewNotifier(),
                  child: IndexPage(0, success),
                ),
              ),
            );
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

  @override
  void dispose() {
    loginFormKey.currentState?.dispose();
    password?.dispose();
    _loginBloc.dispose();
    super.dispose();
  }
}
