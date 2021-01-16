import 'dart:convert';
import 'package:cewers/bloc/bloc.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';

class SendReportBloc implements Bloc {
  final API _api;
  SendReportBloc(this._api);

  Future<dynamic> sendReport(Map<String, dynamic> data) async {
    var response = await _api.postRequest("alert", data);
    if (response is APIError) return response;
    APIResponseModel responseBody =
        APIResponseModel.fromJson(json.decode(response));

    return responseBody;
  }

  Future<dynamic> getReport() async {
    Future.delayed(Duration(seconds: 20));
    var response = await _api.getRequest("alert");
    if (response is APIError) return response;
    APIResponseModel responseBody = APIResponseModel.fromJson(response);

    return responseBody;
  }

  @override
  void dispose() {}
}

class APIKeys {
  final String apiKey;
  final String secretKey;
  final String baseUrl;

  APIKeys(this.apiKey, this.secretKey, this.baseUrl);

  factory APIKeys.fromJson(dynamic json) {
    return APIKeys(json["key"] as String, json["secret"] as String, null);
  }

  factory APIKeys.getBaseUrl(dynamic json) {
    return APIKeys(null, null, json["baseUrl"]);
  }
}
