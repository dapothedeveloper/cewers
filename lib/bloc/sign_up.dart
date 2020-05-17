import 'dart:convert';
import 'package:cewers/bloc/bloc.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';

class SignUpBloc extends Bloc {
  API api = new API();
  Future<dynamic> register(Map<String, Map<String, String>> data) async {
    var response = await api.postRequest("user", data);
    if (response is APIError) return response;

    return APIResponseModel.fromJson(json.decode(response));
  }
// SharedPreferences _pref;

  Future<List<String>> getLocalGovernment() async {
    return ["LCDA One", "LCDA two"];
    // _pref = await SharedPreferences.getInstance();
    // String state = _pref.getString("preferredState");
    // var response = await _api.getRequest("whatever/$state");
    // if (response is APIError) return [response.message];
    // return response;
  }

  Future<List<String>> getCommunities(String localGovernment) async {
    return ["CUM One", "CUM two"];
    // var response = await _api.getRequest("whatever/$localGovernment");
    // if (response is APIError) return [response.message];
    // return response;
  }

  @override
  void dispose() {}
}
