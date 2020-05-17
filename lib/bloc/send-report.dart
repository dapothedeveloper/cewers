import 'dart:convert';
import 'package:cewers/bloc/bloc.dart';
import 'package:cewers/controller/storage.dart';
import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cewers/extensions/string.dart';

class SendReportBloc implements Bloc {
  final StorageController _storageController;
  final API _api;
  SendReportBloc(this._storageController, this._api);
  String _credentialJsonUri = "assets/cloudinary.json";

  Future<List<CloudinaryResponse>> uploadImage(String path) async {
    var credentials = await rootBundle.loadString(_credentialJsonUri);

    CloudinaryCredential auth =
        CloudinaryCredential.fromJson(json.decode(credentials));

    CloudinaryClient client =
        CloudinaryClient(auth.secretKey, auth.apiKey.toString(), "sample");
    /**
     * Get the client's userID and State from memory
     * So we can set a unique file for the file and equally
     * upload to the right folder on the cloud
     */
    String userId = await getUserId() ?? "unknowUser";
    String state = await getState() ?? "unknownState";

    List<String> paths = path.split(".");
    String fileExtension = paths[paths.length - 1];
    print(
        "${state.capitalize()}=====UPLOADING===========$fileExtension========FOR====$userId======");
    List<CloudinaryResponse> response = await client.uploadImages([path],
        filename: "$userId-${DateTime.now()}.$fileExtension",
        folder: state.capitalize());
    return response;
  }

  Future<String> getUserId() async {
    return this._storageController.getUserId();
  }

  Future<String> getState() async {
    return this._storageController.getState();
  }

  Future<dynamic> sendReport(Map<String, dynamic> data) async {
    var response = await _api.postRequest("alert", data);
    if (response is APIError) return response;
    APIResponseModel responseBody =
        APIResponseModel.fromJson(json.decode(response));
    uploadImage(data["alert"]["pictures"][0]).then((value) {
      print(value);
    });
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
  void dispose() {
    rootBundle.evict(_credentialJsonUri);
  }
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
