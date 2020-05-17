import 'package:cewers/model/error.dart';
import 'package:cewers/model/response.dart';
import 'package:cewers/service/api.dart';

class AlertsBloc {
  API api = API();

  Future<dynamic> getAlerts() async {
    var response = await api.getRequest("alert");
    if (response is APIError) return response;
    return APIResponseModel.fromJson(response);
  }
}
