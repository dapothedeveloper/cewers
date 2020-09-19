class UserAuthentication {
  String _username;
  String _password;

  String get username => _username;
  String get password => _password;

  set setUsername(String username) {
    _username = username;
  }

  set setPassword(String password) {
    _password = password;
  }

  UserAuthentication();
}
