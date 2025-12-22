import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/models/ServiceModel/current_service_car_model.dart';


class CurrentServiceCarService {
  static const String _baseUrl =
      'http://31.97.206.144:4072/api/users';

  Future<CurrentServiceCarResponse> fetchCurrentServiceCar({
    required String userId,
    required String serviceId,
  }) async {
    final url =
        '$_baseUrl/mycurrentcar/$userId?serviceId=$serviceId';

    final response = await http.get(Uri.parse(url));

        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$url");


    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CurrentServiceCarResponse.fromJson(decoded);
    } else {
      throw Exception('Failed to fetch current service car');
    }
  }
}
