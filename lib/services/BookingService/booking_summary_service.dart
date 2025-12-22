import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/BookingModel/booking_summary_model.dart';

class BookingSummaryService {
  /// Fetch booking summary by userId and bookingId
  Future<BookingSummary> getBookingSummary(String userId, String bookingId) async {
    final String url = '${ApiConstants.baseUrl}${ApiConstants.bookingSummary}/$userId/$bookingId';

    try {
      final response = await http.get(Uri.parse(url));

      print('urrrrrrrrrrrrrrrrrrrrrrrrrrrrrrl$url');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> data = json.decode(response.body);
            return BookingSummary.fromJson(data);
          } catch (e) {
            throw Exception('Invalid response format: $e');
          }
        } else {
          throw Exception('Empty response received from server');
        }
      } else {
        throw Exception('Failed to fetch booking summary. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBookingSummary: $e');
      rethrow;
    }
  }
}
