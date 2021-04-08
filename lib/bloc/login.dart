import 'dart:convert';

import 'package:cewers/bloc/bloc.dart';
import 'package:cewers/bloc/validator.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/screens/login.dart';
import 'package:cewers/service/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class LoginBloc with Validator implements Bloc {
  final _phoneNumberController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  API api = new API();

  Stream get phoneNumber =>
      _phoneNumberController.transform(phoneNumberValidator);
  Function(String) get validate => _phoneNumberController.sink.add;

  // Stream get login => Observable.combineLast2();
  void dispose() {
    _phoneNumberController?.close();
    _passwordController?.close();
  }

  Future<dynamic> login(Map<String, String> data) async {
    final response = await api.postRequest("user/login", data);
    if (response is APIError) {
      return response;
    } else {
      APIResponseModel responseBody =
          APIResponseModel.fromJson(json.decode(response));
      bool loginSuccess =
          responseBody.message.toLowerCase() == "authentication successful"
              ? true
              : false;

      if (loginSuccess) {
        final storage = new StorageController();
        debugPrint(responseBody.data.toString());
        var userData = UserModel.fromMap(responseBody.data);
        storage.storeUserId(userData.id);
        return userData;
      } else {
        return false;
      }
    }
  }

  Future<dynamic> agentLogin(Map<String, String> data) async {
    final response = await api.postRequest("user-agent/login", data);
    if (response is APIError) {
      return response;
    } else {
      APIResponseModel responseBody =
          APIResponseModel.fromJson(json.decode(response));
      bool loginSuccess =
          responseBody.message.toLowerCase() == "authentication successful"
              ? true
              : false;

      if (loginSuccess) {
        final storage = new StorageController();
        debugPrint(responseBody.data.toString());
        var userData = UserModel.fromMap(responseBody.data);
        storage.storeUserId(userData.id);
        return userData;
      } else {
        return false;
      }
    }
  }
}
