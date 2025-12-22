import 'dart:convert';
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/CarModel/car_model.dart';
import 'package:http/http.dart' as http;

class CarService {
  /// Fetch list of cars with optional filters
  Future<List<Car>> fetchCars({
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
      print("Start Time: $startTime");
      print("Start Time: $endTime");

      print("Start Time: $startDate");

      print("Start Time: $endDate");

      // Build query parameters
      List<String> queryParams = [];
      if (userId != null)
        queryParams.add('userId=${Uri.encodeComponent(userId)}');
      if (lat != null)
        queryParams.add('lat=${Uri.encodeComponent(lat)}');
      if (lng != null)
        queryParams.add('lng=${Uri.encodeComponent(lng)}');
      if (type != null && type.isNotEmpty)
        queryParams.add('type=${Uri.encodeComponent(type)}');
      if (carType != null && carType.isNotEmpty)
        queryParams.add('carType=${Uri.encodeComponent(carType)}');
      if (fuel != null && fuel.isNotEmpty)
        queryParams.add('fuel=${Uri.encodeComponent(fuel)}');
      if (startDate != null && startDate.isNotEmpty) {
        queryParams.add('rentalStartDate=${startDate.replaceAll("/", "-")}');
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams.add('rentalEndDate=${endDate.replaceAll("/", "-")}');
      }
      if (startTime != null && startTime.isNotEmpty) {
        queryParams.add('from=$startTime');
      }
      if (endTime != null && endTime.isNotEmpty) {
        queryParams.add('to=$endTime');
      }

      String url = '${ApiConstants.baseUrl}${ApiConstants.getAllCars}';
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      print("Request Url: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.jsonHeaders,
      );
      print("Response Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return [];

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        List<dynamic>? data;
        if (jsonResponse.containsKey('cars')) {
          data = jsonResponse['cars'];
        } else if (jsonResponse.containsKey('data')) {
          data = jsonResponse['data'];
        } else {
          return [];
        }

        return data!.map((carJson) => Car.fromJson(carJson)).toList();
      }

      if (response.statusCode == 404) {
        // Server says no cars found – return empty list
        return [];
      }

      // Other errors
      throw Exception('Failed to load cars: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching cars: $e');
    }
  }

  /// Fetch single car by ID
  Future<Car> fetchCarById(String id) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.getCarById}/$id';

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.jsonHeaders,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> carData = jsonDecode(response.body);
        return Car.fromJson(carData);
      }

      throw Exception('Failed to load car details: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching car by ID: $e');
    }
  }
}
