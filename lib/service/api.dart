import 'dart:convert';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/model/error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API {
  // final String link = ;
  // String link = "165.22.80.212";
  // Uri _baseUrl = Uri(scheme: "http", host: "a5cb1e02.ngrok.io");
  Uri _baseUrl = Uri(scheme: "http", host: "165.22.80.212");
  Map<String, String> _headers = {"Content-Type": "application/json"};
  // Map<String, int> _ports = {"benue": 8000, "taraba": 8001, "nasarawa": 8002};

  StorageController _storageController = new StorageController();

  Future<String> getState() async {
    return await _storageController.getState();
  }

  Future<dynamic> postRequest(String path, Map<String, dynamic> data) async {
    var body = json.encode(data);
    var state = await getState();
    // int port = _ports[state];
    _headers["state"] = state;
    debugPrint("$_baseUrl:8000/api/$path");
    http.Response response = await http
        .post("$_baseUrl:8000/api/$path", headers: _headers, body: body)
        .timeout(
      Duration(seconds: 15),
      onTimeout: () {
        // time has run out, do what you wanted to do
        return null;
      },
    );
    if (response == null) return APIError("Timed out");
    if (response.statusCode == 200)
      return response.body;
    else
      return APIError("Server currently unavailable");
  }

  Future<dynamic> getRequest(String path) async {
    var state = await getState();
    // int port = _ports[state];
    _headers["state"] = state;
    http.Response response =
        await http.get("$_baseUrl:8000/api/$path", headers: _headers).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        // time has run out, do what you wanted to do
        return null;
      },
    );
    debugPrint(response.toString());
    if (response == null) return APIError("Timed out");
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      return APIError("Server currently unavailable");
  }

  Future<dynamic> putRequest(String path, Map<String, String> data) async {
    final body = json.encode(data);
    var state = await getState();
    // int port = _ports[state];
    _headers["state"] = state;
    var response = await http
        .put("$_baseUrl:8000/api/$path", headers: _headers, body: body)
        .timeout(
      Duration(seconds: 15),
      onTimeout: () {
        return null;
      },
    );

    if (response == null) return APIError("Timed out");
    if (response.statusCode == 200)
      return response.body;
    else
      return APIError("Server currently unavailable");
  }
}
