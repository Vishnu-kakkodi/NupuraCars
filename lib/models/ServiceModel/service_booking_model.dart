/// ---------- SAFE HELPERS ----------

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

bool _parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final v = value.toLowerCase();
    if (v == 'true' || v == '1' || v == 'yes') return true;
    if (v == 'false' || v == '0' || v == 'no') return false;
  }
  return defaultValue;
}

String _parseString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  if (value is String) return value;
  return value.toString();
}

/// Safely get a Map from dynamic
Map<String, dynamic> _parseMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

/// Safely get a List from dynamic
List<dynamic> _parseList(dynamic value) {
  if (value is List) return value;
  return <dynamic>[];
}

/// ---------- MODELS ----------

class ServiceBookingResponse {
  final bool isSuccessfull;
  final String message;
  final List<ServiceBooking> bookings;

  ServiceBookingResponse({
    required this.isSuccessfull,
    required this.message,
    required this.bookings,
  });

  factory ServiceBookingResponse.fromJson(Map<String, dynamic> json) {
    final bookingsJson = _parseList(json['bookings']);

    return ServiceBookingResponse(
      isSuccessfull: _parseBool(json['isSuccessfull']),
      message: _parseString(json['message']),
      bookings: bookingsJson
          .where((e) => e != null)
          .map((e) => ServiceBooking.fromJson(_parseMap(e)))
          .toList(),
    );
  }
}

class ServiceBooking {
  final String id;
  final String status;
  final String pickupStatus;
  final int total;
  final String serviceDate;
  final bool isPickup;
  final String pickupDate;
  final String pickupTime;
  final CurrentCar currentCar;
  final ServicePlan plan;
  final String registrationNumber;

  ServiceBooking({
    required this.id,
    required this.status,
    required this.pickupStatus,
    required this.total,
    required this.serviceDate,
    required this.isPickup,
    required this.pickupDate,
    required this.pickupTime,
    required this.currentCar,
    required this.plan,
    required this.registrationNumber,
  });

  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    final currentCarJson = _parseMap(json['currentCar']);
    final planJson = _parseMap(json['plan']);

    return ServiceBooking(
      id: _parseString(json['_id']),
      status: _parseString(json['status']),
      pickupStatus: _parseString(json['pickupStatus']),
      total: _parseInt(json['total']),
      serviceDate: _parseString(json['serviceDate']),
      isPickup: _parseBool(json['isPickup']),
      pickupDate: _parseString(json['pickupDate']),
      pickupTime: _parseString(json['pickupTime']),
      currentCar: CurrentCar.fromJson(currentCarJson),
      plan: ServicePlan.fromJson(planJson),
      registrationNumber:
          _parseString(currentCarJson['registrationNumber']), // safe
    );
  }
}

class CurrentCar {
  final String modelName;
  final String image;

  CurrentCar({
    required this.modelName,
    required this.image,
  });

  factory CurrentCar.fromJson(Map<String, dynamic> json) {
    final carIdJson = _parseMap(json['carId']);

    return CurrentCar(
      modelName: _parseString(carIdJson['name']),
      image: _parseString(carIdJson['image']),
    );
  }
}

class ServicePlan {
  final String serviceType;
  final String serviceName;
  final String fuelType;
  final String variant;
  final int price;

  ServicePlan({
    required this.serviceType,
    required this.serviceName,
    required this.fuelType,
    required this.variant,
    required this.price,
  });

  factory ServicePlan.fromJson(Map<String, dynamic> json) {
    final serviceDetailsJson = _parseMap(json['serviceDetails']);

    return ServicePlan(
      serviceType: _parseString(serviceDetailsJson['serviceType']),
      serviceName: _parseString(serviceDetailsJson['serviceName']),
      fuelType: _parseString(json['fuelType']),
      variant: _parseString(json['variant']),
      price: _parseInt(json['price']),
    );
  }
}
