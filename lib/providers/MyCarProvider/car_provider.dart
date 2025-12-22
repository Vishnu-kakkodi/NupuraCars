
// car_provider.dart

import 'package:flutter/foundation.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/services/MyCarService/car_api_service.dart';

class MyCarProvider extends ChangeNotifier {
  final CarApiService _service;

  MyCarProvider({CarApiService? service})
      : _service = service ?? CarApiService();

  /// BRANDS
  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  bool _isBrandsLoading = false;
  bool get isBrandsLoading => _isBrandsLoading;

  String? _brandsError;
  String? get brandsError => _brandsError;

  /// SERVICE CARS
  List<ServiceCar> _serviceCars = [];
  List<ServiceCar> get serviceCars => _serviceCars;

  bool _isServiceCarsLoading = false;
  bool get isServiceCarsLoading => _isServiceCarsLoading;

  String? _serviceCarsError;
  String? get serviceCarsError => _serviceCarsError;

  /// MY CARS
  List<UserCar> _myCars = [];
  List<UserCar> get myCars => _myCars;

  bool _isMyCarsLoading = false;
  bool get isMyCarsLoading => _isMyCarsLoading;

  String? _myCarsError;
  String? get myCarsError => _myCarsError;

  /// Currently selected brand (optional)
  Brand? _selectedBrand;
  Brand? get selectedBrand => _selectedBrand;

  void setSelectedBrand(Brand? brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  // ========= 🔥 CURRENT CAR STATE =========

  /// current car object
  UserCar? _currentCar;
  UserCar? get currentCar => _currentCar;

  /// current car id from backend (`currentCar` field)
  String? _currentCarId;
  String? get currentCarId => _currentCarId;

  bool _isCurrentCarLoading = false;
  bool get isCurrentCarLoading => _isCurrentCarLoading;

  String? _currentCarError;
  String? get currentCarError => _currentCarError;

  void clearCurrentCar() {
    _currentCar = null;
    _currentCarId = null;
    _currentCarError = null;
    notifyListeners();
  }

  // ================== ACTIONS ==================

  Future<void> loadBrands() async {
    _isBrandsLoading = true;
    _brandsError = null;
    notifyListeners();

    try {
      _brands = await _service.fetchBrands();
    } catch (e) {
      _brandsError = e.toString();
    } finally {
      _isBrandsLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadServiceCarsForBrand(String brandName) async {
    _isServiceCarsLoading = true;
    _serviceCarsError = null;
    notifyListeners();

    try {
      _serviceCars = await _service.fetchServiceCarsByBrand(brandName);
    } catch (e) {
      _serviceCarsError = e.toString();
    } finally {
      _isServiceCarsLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyCars(String userId) async {
    _isMyCarsLoading = true;
    _myCarsError = null;
    notifyListeners();

    try {
      _myCars = await _service.fetchMyCars(userId);
    } catch (e) {
      _myCarsError = e.toString();
    } finally {
      _isMyCarsLoading = false;
      notifyListeners();
    }
  }

  Future<UserCar?> addUserCar(String userId, UserCarRequest request) async {
    try {
      final newCar = await _service.createMyCar(userId, request);
      _myCars.add(newCar);
      notifyListeners();
      return newCar;
    } catch (e) {
      _myCarsError = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<UserCar?> updateUserCar(
    String userId,
    String userCarId,
    UserCarRequest request,
  ) async {
    try {
      final updated = await _service.editUserCar(userId, userCarId, request);
      final index = _myCars.indexWhere((c) => c.id == userCarId);
      if (index != -1) {
        _myCars[index] = updated;
      }

      // If this car is the current one, also update currentCar
      if (_currentCarId == userCarId) {
        _currentCar = updated;
      }

      notifyListeners();
      return updated;
    } catch (e) {
      _myCarsError = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeUserCar(String userId, String userCarId) async {
    try {
      await _service.deleteUserCar(userId, userCarId);
      _myCars.removeWhere((c) => c.id == userCarId);

      // If deleted car was current, clear
      if (_currentCarId == userCarId) {
        clearCurrentCar();
      }

      notifyListeners();
    } catch (e) {
      _myCarsError = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ========= 🔥 CURRENT CAR ACTIONS =========

  /// Call POST /api/users/set-current-car
  /// and update local state.
  Future<void> setCurrentCarForUser(String userId, String carId) async {
    try {
      _currentCarError = null;
      // hit API
      final currentCarIdFromApi = await _service.setCurrentCar(userId, carId);

      _currentCarId = currentCarIdFromApi;

      // Try to map to an existing UserCar in _myCars (for quick UI update)
      try {
        _currentCar = _myCars.firstWhere((c) => c.id == carId);
      } catch (_) {
        // If not found, we simply keep only the id; UI can still use currentCarId
        _currentCar ??= null;
      }

      notifyListeners();
    } catch (e) {
      _currentCarError = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Call GET /api/users/mycurrentcar/:userId
  /// and sync current car state.
  Future<void> loadMyCurrentCar(String userId) async {
    _isCurrentCarLoading = true;
    _currentCarError = null;
    notifyListeners();

    try {
      final current = await _service.fetchMyCurrentCar(userId);
      _currentCar = current;
      _currentCarId = current?.id;
    } catch (e) {
      _currentCarError = e.toString();
    } finally {
      _isCurrentCarLoading = false;
      notifyListeners();
    }
  }
}
