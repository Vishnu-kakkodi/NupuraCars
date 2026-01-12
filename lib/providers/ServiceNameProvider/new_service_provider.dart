import 'package:flutter/material.dart';
import 'package:nupura_cars/models/ServiceModel/new_service_model.dart';
import 'package:nupura_cars/services/service_api.dart';


class ServiceProvider extends ChangeNotifier {
  bool loading = false;
  List<SubServiceModel> subServices = [];

  Future<void> loadServices(String serviceId, String userId) async {
        print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");

    loading = true;
    notifyListeners();

    subServices = await ServiceApi.fetchSubServices(serviceId,userId);

    loading = false;
    notifyListeners();
  }
}
