import 'dart:convert';
import 'package:cewers/bloc/bloc.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/lga.dart';
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

  Future<dynamic> getLocalGovernment() async {
    var response = await api.getRequest("lga");
    // print(response);
    if (response is APIError) return response.message;
    var payload = APIResponseModel.fromJson(response);
    return payload.data
        .map((lga) => LocalGovernmentModel.fromJson(lga))
        .toList()
        .where(notNull);
  }

  bool notNull(Object o) => o != null;
  Future<List<String>> getCommunities(String localGovernment) async {
    return ["CUM One", "CUM two"];
    // var response = await _api.getRequest("whatever/$localGovernment");
    // if (response is APIError) return [response.message];
    // return response;
  }

  @override
  void dispose() {}
}
