import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/BookingModel/booking_model.dart';
import 'package:nupura_cars/models/BookingModel/create_model.dart';

class BookingService {
  /// Fetch all bookings for a given user
  Future<List<Booking>> fetchBookings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.fetchBookings}/$userId',
        ),
      );

      print("Response Body: $userId");

      print("response status codeeeeeeeeeeeeeeeee${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bookingsJson = data['bookings'] as List?;

        if (bookingsJson == null || bookingsJson.isEmpty) {
          return [];
        }

        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchBookings: $e');
      rethrow;
    }
  }

  /// Fetch the most recent booking for a user
  Future<Booking> fetchRecentBooking(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.fetchRecentBooking}/$userId',
        ),
      );

      print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr${response.statusCode}');
      print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bookingJson = data['booking'];

        if (bookingJson == null) {
          throw Exception('No recent booking found');
        }

        return Booking.fromJson(bookingJson);
      } else {
        throw Exception(
          'Failed to load recent booking: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in fetchRecentBooking: $e');
      rethrow;
    }
  }

  /// Fetch a booking summary for a specific booking ID
  Future<Booking> fetchBookingSummary(String userId, String bookingId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.bookingSummary}/$userId/$bookingId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bookingJson = data['booking'];

        if (bookingJson == null) {
          throw Exception('Booking not found');
        }

        return Booking.fromJson(bookingJson);
      } else {
        throw Exception(
          'Failed to load booking summary: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in fetchBookingSummary: $e');
      rethrow;
    }
  }

  /// Create a new booking for a user
  Future<CreateBookingModel> createBooking({
    required String userId,
    required String carId,
    required DateTime startDate,
    required DateTime endDate,
    required String startTime,
    required String endTime,
    required String deposit,
    required int amount,
    required String transactionId,
             int? advancePayment,
     int? depositAmount,
     required bool completePayment,
    required bool isCarWash,
     int? carWashAmount,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.createBooking}',
    );

    print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    // Format dates as YYYY-MM-DD
    final formattedStartDate =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    final formattedEndDate =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

    final payload = {
      "userId": userId,
      "carId": carId,
      "rentalStartDate": formattedStartDate,
      "rentalEndDate": formattedEndDate,
      "from": startTime,
      "to": endTime,
      "deposit": deposit,
      "amount": amount,
      "transactionId":transactionId,
         "advancePayment": advancePayment,
        "depositAmount": depositAmount,
        "completePayment": completePayment,
        "isCarWash": isCarWash,
        "carWashAmount": carWashAmount,
      
    };

    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$payload',
    );
    print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$carId');

    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$formattedStartDate',
    );

    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$formattedEndDate',
    );

    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$startTime',
    );
    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$endTime',
    );
    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$deposit',
    );

    print(
      'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$amount',
    );


    try {
      final response = await http.post(
        url,
        headers: ApiConstants.jsonHeaders,
        body: jsonEncode(payload),
      );

      print('responseeeeeeeeeeeeeeeee ${response.statusCode}');
      print('response bodyyyyyyyyyyyyyyyyyyyyyyyy${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;

        if (body.isEmpty || body == 'null') {
          throw Exception("Booking created but response is empty");
        }

        final data = jsonDecode(body);
        return CreateBookingModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Booking failed: ${errorData['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('Error in createBooking: $e');
      rethrow;
    }
  }
}
