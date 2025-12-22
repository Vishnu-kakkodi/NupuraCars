import 'package:flutter/material.dart';
import 'package:nupura_cars/models/ServiceModel/current_service_car_model.dart';
import 'package:nupura_cars/services/ServiceNameProvider/current_service_car_service.dart';

class CurrentServiceCarProvider extends ChangeNotifier {
  final CurrentServiceCarService _service = CurrentServiceCarService();

  CurrentServiceCarResponse? _data;
  bool _isLoading = false;
  String? _error;

  CurrentServiceCarResponse? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentServiceCar({
    required String userId,
    required String serviceId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await _service.fetchCurrentServiceCar(
        userId: userId,
        serviceId: serviceId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
