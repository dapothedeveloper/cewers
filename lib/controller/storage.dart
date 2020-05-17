import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  SharedPreferences _pref;

  void storeUserId(String userId) async {
    _pref = await SharedPreferences.getInstance();
    _pref.setString("userId", userId);
  }

  Future<String> getUserId() async {
    _pref = await SharedPreferences.getInstance();
    return _pref.getString("userId");
  }

  Future<String> getState() async {
    _pref = await SharedPreferences.getInstance();
    return _pref.getString("prefferedState");
  }

  Future<bool> storeState(String state) async {
    _pref = await SharedPreferences.getInstance();
    return _pref.setString("prefferedState", state);
  }
}
