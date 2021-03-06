import 'dart:core';

class APIResponseModel {
  final bool status;
  final dynamic data;
  final String message;
  APIResponseModel(this.status, this.data, this.message);
  factory APIResponseModel.fromJson(dynamic json) {
    return APIResponseModel(json['status'] as bool, json['data'] as dynamic,
        json["message"] as String);
  }
  factory APIResponseModel.fromJsonList(dynamic json) {
    return APIResponseModel(json['status'] as bool, json["data"] as List,
        json["message"] as String);
  }
}
