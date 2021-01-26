import 'dart:convert';
import 'package:cewers/bloc/bloc.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';
// import 'package:flutter/material.dart';

class SignUpBloc extends Bloc {
  API api = new API();
  Future<dynamic> register(Map<String, Map<String, String>> data) async {
    var response = await api.postRequest("user", data);
    if (response is APIError) return response;

    return APIResponseModel.fromJson(json.decode(response));
  }
// SharedPreferences _pref;

  Future<dynamic> getLocalGovernment() async {
    var response = await api.getRequest("lgas");
    // print(response);
    if (response is APIError) return response?.message;
    var payload = APIResponseModel.fromJson(response);
    Iterable list = payload?.data;

    return list
        ?.map<LocalGovernmentModel>((lga) => LocalGovernmentModel.fromJson(lga))
        ?.toList()
        ?.where(notNull);
  }

  Future<dynamic> getWards() async {
    var response = await api.getRequest("ward");
    // print(response);
    if (response is APIError) return response?.message;
    var payload = APIResponseModel.fromJson(response);
    Iterable list = payload?.data;

    return list
        ?.map<WardModel>((ward) => WardModel.fromJson(ward))
        ?.toList()
        ?.where(notNull);
  }

  bool notNull(Object o) => o != null;

  @override
  void dispose() {}
}

class LocalGovernmentModel {
  final String name;
  final bool isDeleted;

  LocalGovernmentModel(this.name, this.isDeleted);
  factory LocalGovernmentModel.fromJson(Map<String, dynamic> json) {
    return LocalGovernmentModel(json["name"] as String, json["isDeleted"]);
  }
}

class WardModel {
  final String name;
  final String lga;
  final bool isDeleted;

  WardModel(this.name, this.lga, this.isDeleted);
  factory WardModel.fromJson(dynamic json) {
    return WardModel(json["name"] as String, json["lga"], json["isDeleted"]);
  }
}
