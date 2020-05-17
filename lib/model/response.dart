class APIResponseModel {
  final bool status;
  final dynamic data;
  final String message;
  final int statusCode;
  APIResponseModel(this.status, this.data, this.message, this.statusCode);
  factory APIResponseModel.fromJson(dynamic json) {
    return APIResponseModel(json['status'] as bool, json['data'] as dynamic,
        json["message"] as String, json["statusCode"] as int);
  }
}
