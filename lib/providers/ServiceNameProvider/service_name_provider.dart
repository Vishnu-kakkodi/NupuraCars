import 'package:flutter/material.dart';
import 'package:nupura_cars/models/ServiceModel/service_name_model.dart';
import 'package:nupura_cars/services/ServiceNameProvider/service_name_service.dart';

class ServiceNameProvider extends ChangeNotifier {
  final ServiceNameService _service = ServiceNameService();

  List<ServiceNameModel> _services = [];
  bool _isLoading = false;
  String? _error;

  List<ServiceNameModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getServiceNames() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _services = await _service.fetchServiceNames();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
