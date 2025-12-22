import 'package:flutter/material.dart';
import 'package:nupura_cars/models/ServiceModel/service_booking_model.dart' show ServiceBooking;
import 'package:nupura_cars/services/ServiceNameProvider/service_booking_service.dart';

class ServiceBookingProvider extends ChangeNotifier {
  final ServiceBookingService _service = ServiceBookingService();

  bool isLoading = false;
  List<ServiceBooking> bookings = [];

  Future<void> loadBookings(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      bookings = await _service.fetchAllBookings(userId);
    } catch (e) {
      bookings = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
