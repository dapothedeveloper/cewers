import 'dart:convert';

import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';
import 'dart:async';

class FeedbackBloc {
  API api = new API();

  Future<dynamic> submitFeedback(dynamic data) async {
    // print(data);
    final response = await api.postRequest("feedback", data);

    if (response is APIError) return response;
    var payload = APIResponseModel.fromJson(json.decode(response));
    return payload;
  }
}
