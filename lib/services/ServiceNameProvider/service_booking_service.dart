import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/models/ServiceModel/service_booking_model.dart' show ServiceBooking;

class ServiceBookingService {
  static const String baseUrl = "http://31.97.206.144:4072/api/users";

  Future<List<ServiceBooking>> fetchAllBookings(String userId) async {
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkk$userId");

    final response =
        await http.get(Uri.parse("$baseUrl/allservicebooking/$userId"));

    final data = json.decode(response.body);
print("kkkkkkkkkkkkkkkkkkkkkkkkkkk${response.body}");
    if (response.statusCode == 200 && data['isSuccessfull']) {
      return (data['bookings'] as List)
          .map((e) => ServiceBooking.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch service bookings");
    }
  }
}
