
class BookingSummary {
  final String message;
  final Booking booking;
  final Car car;

  BookingSummary({
    required this.message,
    required this.booking,
    required this.car,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> json) {
    return BookingSummary(
      message: json['message'] ?? '',
      booking: Booking.fromJson(json['booking'] ?? {}),
      car: Car.fromJson(json['car'] ?? {}),
    );
  }
}

class Booking {
  final String id;
  final User user;
  final String carId;
  final DateTime rentalStartDate;
  final DateTime rentalEndDate;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final int otp;
  final String pickupLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.user,
    required this.carId,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.otp,
    required this.pickupLocation,
    required this.createdAt,
    required this.updatedAt,
  });

factory Booking.fromJson(Map<String, dynamic> json) {
  // Custom date parser for format "5/19/2025, 1:55:00 AM"
  DateTime parseCustomDate(String dateStr) {
    try {
      // Try standard parsing first
      return DateTime.parse(dateStr);
    } catch (e) {
      try {
        // Split date and time parts
        final parts = dateStr.split(', ');
        if (parts.length == 2) {
          // Parse date part (MM/DD/YYYY)
          final dateParts = parts[0].split('/');
          if (dateParts.length == 3) {
            final month = int.parse(dateParts[0]);
            final day = int.parse(dateParts[1]);
            final year = int.parse(dateParts[2]);
            
            // Parse time part (HH:MM:SS AM/PM)
            final timeParts = parts[1].split(' ');
            if (timeParts.length == 2) {
              final timeDigits = timeParts[0].split(':');
              if (timeDigits.length == 3) {
                int hour = int.parse(timeDigits[0]);
                final minute = int.parse(timeDigits[1]);
                final second = int.parse(timeDigits[2]);
                
                // Handle AM/PM
                final amPm = timeParts[1].toUpperCase();
                if (amPm == 'PM' && hour < 12) {
                  hour += 12;
                } else if (amPm == 'AM' && hour == 12) {
                  hour = 0;
                }
                
                return DateTime(year, month, day, hour, minute, second);
              }
            }
          }
        }
        // If custom parsing also fails, use a default date
        print('Failed to parse date format: $dateStr');
        return DateTime.now();
      } catch (innerException) {
        // If both parsing methods fail, use current date
        print('Error parsing date "$dateStr": $innerException');
        return DateTime.now();
      }
    }
  }

  return Booking(
    id: json['_id'] ?? '',
    user: User.fromJson(json['userId'] ?? {}),
    carId: json['carId'] ?? '',
    rentalStartDate: parseCustomDate(json['rentalStartDate']),
    rentalEndDate: parseCustomDate(json['rentalEndDate']),
    totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    status: json['status'] ?? '',
    paymentStatus: json['paymentStatus'] ?? '',
    otp: json['otp'] ?? 0,
    pickupLocation: json['pickupLocation'] ?? '',
    createdAt: parseCustomDate(json['createdAt']),
    updatedAt: parseCustomDate(json['updatedAt']),
  );
}

  // Helper getters
  bool get isPending => paymentStatus.toLowerCase() == 'pending';
  bool get isCompleted => paymentStatus.toLowerCase() == 'completed';
}


class ExtendedPrice {
  final int perHour;
  final int perDay;

  ExtendedPrice({
    required this.perHour,
    required this.perDay,
  });

  factory ExtendedPrice.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse int
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? defaultValue;
      }
      if (value is double) return value.toInt();
      return defaultValue;
    }

    return ExtendedPrice(
      perHour: parseInt(json['perHour'], defaultValue: 0),
      perDay: parseInt(json['perDay'], defaultValue: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perHour': perHour,
      'perDay': perDay,
    };
  }
}

class Car {
  final String id;
  final String name;
  final String model;
  final double pricePerHour;
  final double pricePerDay;
  final String location;
  final List<String> image;
    final ExtendedPrice extendedPrice;


  Car({
    required this.id,
    required this.name,
    required this.model,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.location,
    required this.image,
        required this.extendedPrice,

  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '',
      name: json['carName'] ?? '',
      model: json['model'] ?? '',
      pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
      pricePerDay: (json['pricePerDay'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      image: List<String>.from(json['carImage'] ?? []),
            extendedPrice: ExtendedPrice.fromJson(json['extendedPrice']),

    );
  }

  // Getter for car details
  String get fuel => 'Petrol'; // Default or you can add this to your API
  String get seats => '5';    // Default or you can add this to your API
  String get type => 'Sedan'; // Default or you can add this to your API
}

class User {
  final String id;
  final String name;
  final String email;
  final String mobile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}