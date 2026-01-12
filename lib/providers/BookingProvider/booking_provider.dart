
import 'package:nupura_cars/models/BookingModel/booking_model.dart';
import 'package:nupura_cars/models/BookingModel/create_model.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/services/BookingService/booking_service.dart';
import 'package:flutter/material.dart';


class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  final DateTimeProvider _provider = DateTimeProvider();

  List<Booking> _bookings = [];
  Booking? _recentBooking;
  Booking? _booking;
  bool _isLoading = false;
  String? _bookingError;

  // Getters
  List<Booking> get bookings => _bookings;
  Booking? get recentBooking => _recentBooking;
  Booking? get booking => _booking;
  bool get isLoading => _isLoading;
  String? get bookingError => _bookingError;

  /// Load all bookings for a user
  Future<void> loadBookings(String userId) async {
    _isLoading = true;
    _bookingError = null;
    notifyListeners();

    try {
      _bookings = await _bookingService.fetchBookings(userId);
      print('✅ Loaded ${_bookings.length} bookings');

      for (var i = 0; i < _bookings.length; i++) {
        final booking = _bookings[i];
        print('Booking $i: ${booking.car.name}');
      }

    } catch (e) {
      _bookingError = 'Failed to load bookings: $e';
      _bookings = [];
      print('❌ Error in loadBookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get the most recent booking
  // Future<void> getRecentBooking(String userId) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     _recentBooking = await _bookingService.fetchRecentBooking(userId);
  //     if (_recentBooking != null) {
  //       print('✅ Recent Booking: ${_recentBooking!.car.name}');
  //     }
  //   } catch (e) {
  //     _recentBooking = null;
  //     print('❌ Error fetching recent booking: $e');
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }



  /// Get the most recent ACTIVE booking (exclude cancelled & completed)
Future<void> getRecentBooking(String userId) async {
  _isLoading = true;
  notifyListeners();

  try {
    final booking = await _bookingService.fetchRecentBooking(userId);

    if (booking == null) {
      _recentBooking = null;
      return;
    }

    final status = booking.status.toLowerCase();

    /// ❌ Ignore cancelled / completed
    if (status == 'cancelled' || status == 'completed') {
      _recentBooking = null;
      print('ℹ️ Recent booking ignored due to status: $status');
    } else {
      _recentBooking = booking;
      print('✅ Active Recent Booking: ${booking.car.name}');
    }
  } catch (e) {
    _recentBooking = null;
    print('❌ Error fetching recent booking: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// Create a new booking
  Future<CreateBookingModel> createBooking({
    required String userId,
    required String carId,
    required DateTime rentalStartDate,
    required DateTime rentalEndDate,
    required String from,
    required String to,
    required String deposit,
    required int amount,
    required String transactionId,
         int? advancePayment,
     int? depositAmount,
     required bool completePayment,
    required bool isCarWash,
     int? carWashAmount,
  }) async {
        print("hhhhhhhhhhjjjjjjjjjjjjjjjjuuuuuuuuuuuuuuuuuuu");

    _isLoading = true;
    _bookingError = null;
    notifyListeners();

    print("hhhhhhhhhhjjjjjjjjjjjjjjjjuuuuuuuuuuuuuuuuuuu");

    try {
      print('user idddddddddddddddddddd$userId');
      print('card idddddddddddddddddddd$carId');
      print('start idddddddddddddddddddd$rentalStartDate');
      print('end idddddddddddddddddddd$rentalEndDate');
      print('from idddddddddddddddddddd$from');
      print('to idddddddddddddddddddd$to');
      print('depo idddddddddddddddddddd$deposit');
      print('amou idddddddddddddddddddd$amount');
         print('end idddddddddddddddddddd$advancePayment');
      print('from idddddddddddddddddddd$depositAmount');
      print('to idddddddddddddddddddd$completePayment');
      print('depo idddddddddddddddddddd$isCarWash');
      print('amou idddddddddddddddddddd$carWashAmount');
            print('amou idddddddddddddddddddd$transactionId');



      final result = await _bookingService.createBooking(
        userId: userId,
        carId: carId,
        startDate: rentalStartDate,
        endDate: rentalEndDate,
        startTime: from,
        endTime: to,
        deposit: deposit,
        amount: amount,
        transactionId:transactionId,
           advancePayment: advancePayment,
        depositAmount: depositAmount,
        completePayment: completePayment,
        isCarWash: isCarWash,
        carWashAmount: carWashAmount,
      );



      await _provider.resetAll();

      print('user id$userId');

      // Refresh after booking
      await getRecentBooking(userId);
      await loadBookings(userId);

      return result;
    } catch (e) {
      _bookingError = e.toString();
      print('❌ Booking creation failed: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
