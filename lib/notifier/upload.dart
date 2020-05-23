import 'dart:convert';

import 'package:cewers/bloc/send-report.dart';
import 'package:cewers/controller/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cewers/extensions/string.dart';
import 'package:crypto/crypto.dart';

class UploadNotifier extends ChangeNotifier {
  final StorageController _storageController;
  final Dio _dio = Dio();

  UploadNotifier(this._storageController);

  double progressPercentage;
  String errorMessage;
  String status;

  String _credentialJsonUri = "assets/cloudinary.json";

  Future<String> getUserId() async {
    return this._storageController.getUserId();
  }

  Future<String> getState() async {
    return this._storageController.getState();
  }

  void setError(Exception error) {
    if (error is DioError) {
      errorMessage = error.toString();
    } else if (error is Exception) {
      errorMessage = (error.toString().replaceRange(0, 11, ""));
    } else {
      errorMessage = (error.toString());
    }
    notifyListeners();
  }

  Future<void> uploadImage(
      String imagePath, String imageFilename, int timeStamp) async {
    final credentials = await rootBundle.loadString(_credentialJsonUri);
    // print(credentials);
    CloudinaryCredential auth =
        CloudinaryCredential.fromJson(json.decode(credentials));

    Map<String, dynamic> params = new Map();
    if (auth.secretKey == null || auth.apiKey == null) {
      throw Exception("apiKey and apiSecret not found");
    }

    params["api_key"] = auth.apiKey;

    if (imagePath == null) {
      throw Exception(
          "You didn't upload a graphic evidence of your emergency!");
    }
    // String publicId = imageFilename.split('/').last;
    String publicId = imageFilename.split('.')[0];

    // if (imageFilename != null) {
    //   publicId = imageFilename.split('.')[0] + "_" + timeStamp.toString();
    // } else {
    //   imageFilename = publicId;
    // }

    params["folder"] = "Cewers/" + (await getState()).capitalize();

    if (publicId != null) {
      params["public_id"] = publicId;
    }

    params["file"] =
        await MultipartFile.fromFile(imagePath, filename: imageFilename);
    params["timestamp"] = timeStamp;
    params["signature"] =
        await getSignature(params["folder"], publicId, timeStamp);

    FormData formData = new FormData.fromMap(params);
    // var progress;
    Dio dio = await getApiClient();
    dio
        .post("cousant/auto/upload", data: formData, onSendProgress: progress)
        .catchError((e, stack) {
      errorMessage = e.toString();
    });
  }

  Future<String> getSignature(
      String folder, String publicId, int timeStamp) async {
    final credentials = await rootBundle.loadString(_credentialJsonUri);
    // print(credentials);
    CloudinaryCredential auth =
        CloudinaryCredential.fromJson(json.decode(credentials));
    var buffer = new StringBuffer();
    if (folder != null) {
      buffer.write("folder=" + folder + "&");
    }
    if (publicId != null) {
      buffer.write("public_id=" + publicId + "&");
    }
    buffer.write("timestamp=" + timeStamp.toString() + auth.secretKey);

    var bytes = utf8.encode(buffer.toString().trim()); // data being hashed

    return sha1.convert(bytes).toString();
  }

  Future<Dio> getApiClient({InterceptorsWrapper interceptor}) async {
    _dio.options.baseUrl = "https://api.cloudinary.com/v1_1/";
    _dio.interceptors.clear();
    if (interceptor != null) {
      _dio.interceptors.add(interceptor);
    }
    return _dio;
  }

  progress(int actualBytes, int totalBytes) {
    print("========");
    progressPercentage = actualBytes / totalBytes * 100;
    status = "${progressPercentage.toStringAsFixed(1)}% Uploading...";
    if (progressPercentage == 100) status = "Completed";
    notifyListeners();
  }
}

class UploadPayloadModel {
  final FormData formData;
  final Dio dio;
  UploadPayloadModel(this.dio, this.formData);
}
