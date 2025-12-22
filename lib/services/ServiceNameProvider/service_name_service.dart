import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/models/ServiceModel/service_name_model.dart';

class ServiceNameService {
  static const String _baseUrl =
      'http://31.97.206.144:4072/api/admin/allservicenames';

  Future<List<ServiceNameModel>> fetchServiceNames() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List services = decoded['services'] ?? [];

      return services
          .map((e) => ServiceNameModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load service names');
    }
  }
}
