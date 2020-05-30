import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';
import 'dart:async';

class FeedbackBloc {
  API api = new API();

  Future<dynamic> submitFeedback(Map<String, String> data) async {
    final response = await api.postRequest("feedback", data);
    print(data);
    if (response is APIError) return response;
    var payload = APIResponseModel.fromJson(response);
    print(response.toString());
    return payload;
  }
}
