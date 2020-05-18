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

class CloudinaryCredential {
  final String apiKey;
  final String secretKey;

  CloudinaryCredential(this.apiKey, this.secretKey);

  factory CloudinaryCredential.fromJson(dynamic json) {
    return CloudinaryCredential(
        json["key"] as String, json["secret"] as String);
  }
}
