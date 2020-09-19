import 'dart:async';

mixin Validator {
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    switch (email.isNotEmpty) {
      case true:
        isEmail(email) ? sink.add(email) : sink.addError("Email is invalid");
        break;
      case false:
        sink.add(email);
        break;
    }
  });
  var phoneNumberValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.isEmpty || phone.length != 11) {
      sink.addError("Phone number is invalid");
    } else {
      sink.add(phone);
    }
  });
  var genderValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.isEmpty || phone.length != 11) {
      sink.addError("Phone number is invalid");
    } else {
      sink.add(phone);
    }
  });
  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
