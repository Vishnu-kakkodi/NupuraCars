import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/models/Cart/cart_model.dart';
import 'package:nupura_cars/models/ServiceModel/new_service_model.dart';


class ServiceApi {
  static const baseUrl = 'http://31.97.206.144:4072/api';

  static Future<List<SubServiceModel>> fetchSubServices(String serviceId) async {
    final res = await http.get(Uri.parse('$baseUrl/admin/getsubservices?serviceId=$serviceId'));
    final data = jsonDecode(res.body);
    return (data['subServices'] as List)
        .map((e) => SubServiceModel.fromJson(e))
        .toList();
  }

  static Future<void> addToCart(String userId, String packageId) async {
    await http.post(
      Uri.parse('$baseUrl/users/addtocart/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'packageId': packageId}),
    );
  }

  static Future<CartModel> fetchCart(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/users/getcart/$userId'));
    final data = jsonDecode(res.body);
    return CartModel.fromJson(data['cart']);
  }

  static Future<void> removeFromCart({
    required String userId,
    required String packageId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/removepackagefromcart/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'packageId': packageId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }
}

