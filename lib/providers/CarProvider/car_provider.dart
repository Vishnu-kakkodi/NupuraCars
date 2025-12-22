
import 'package:nupura_cars/models/CarModel/car_model.dart';
import 'package:nupura_cars/services/CarService/car_service.dart';
import 'package:flutter/material.dart';


class CarProvider with ChangeNotifier {
  final CarService _service = CarService(); 

  List<Car> _allCars = [];
  List<Car> _filteredCars = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedType = '';
  String _selectedFuel = '';

  // Getters
  List<Car> get allCars => _allCars;
  List<Car> get cars => _filteredCars;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  String get selectedType => _selectedType;
  String get selectedFuel => _selectedFuel;

  // State setters
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void setFilteredCars(List<Car> filtered) {
    _filteredCars = filtered;
    notifyListeners();
  }

  void clearFilters() {
    _selectedType = '';
    _selectedFuel = '';
    _filteredCars = _allCars;
    notifyListeners();
  }

  // ✅ Initial load method
  Future<void> initCars({
    String? userId,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? type,
    String? carType,
    String? fuel,
  }) async {
    await loadCars(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      type: type,
      carType: carType,
      fuel: fuel,
    );
  }

  // ✅ Main fetch method
  Future<void> loadCars({
    String? userId,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? type,
    String? carType,
    String? fuel,
        String? lat,
    String? lng,
  }) async {
    try {
      setLoading(true);
      clearError();
print("ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
      final fetchedCars = await _service.fetchCars(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        type: type,
        carType: carType,
        fuel: fuel,
        lat: lat,
        lng: lng
      );

      _allCars = fetchedCars;
      _filteredCars = List.from(fetchedCars);
      notifyListeners();
    } catch (e) {
      setError('Failed to load cars: ${e.toString()}');
      _allCars = [];
      _filteredCars = [];
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  // ✅ Filter logic
  Future<void> applyFilters({
    String? userId,
    String? carType,
    String? type,
    String? fuel,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
  }) async {
    try {
      setLoading(true);
      clearError();

      if (type != null) _selectedType = type;
      if (fuel != null) _selectedFuel = fuel;

      final fetchedCars = await _service.fetchCars(
        userId: userId,
        carType: carType,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        type: _selectedType.isEmpty ? null : _selectedType,
        fuel: _selectedFuel.isEmpty ? null : _selectedFuel,
      );

      _filteredCars = fetchedCars;
      notifyListeners();
    } catch (e) {
      setError('Failed to filter cars: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  // ✅ Search logic
  void searchCars(String query) {
    final lowerQuery = query.toLowerCase();
    final results = _allCars.where((car) {
      return car.name.toLowerCase().contains(lowerQuery) ||
          car.location.toLowerCase().contains(lowerQuery);
    }).toList();

    _filteredCars = results;
    notifyListeners();
  }

  // ✅ Fetch single car detail
  Future<Car> getCarDetails(String id) async {
    return await _service.fetchCarById(id);
  }
}
