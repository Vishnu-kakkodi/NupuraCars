// car_models.dart

class Brand {
  final String id;
  final String name;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Brand({
    required this.id,
    required this.name,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

/// Minimal brand info used inside serviceCars / myCars
class BrandRef {
  final String id;
  final String name;

  BrandRef({
    required this.id,
    required this.name,
  });

  factory BrandRef.fromJson(Map<String, dynamic> json) {
    return BrandRef(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }
}

class ServiceCar {
  final String id;
  final BrandRef brand;
  final String name;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceCar({
    required this.id,
    required this.brand,
    required this.name,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceCar.fromJson(Map<String, dynamic> json) {
    return ServiceCar(
      id: json['_id'] as String,
      brand: BrandRef.fromJson(json['brandId'] as Map<String, dynamic>),
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

/// Car info embedded inside myCars (carId object)
class EmbeddedCar {
  final String id;
  final BrandRef brand;
  final String name;
  final String image;

  EmbeddedCar({
    required this.id,
    required this.brand,
    required this.name,
    required this.image,
  });

  factory EmbeddedCar.fromJson(Map<String, dynamic> json) {
    return EmbeddedCar(
      id: json['_id'] as String,
      brand: BrandRef.fromJson(json['brandId'] as Map<String, dynamic>),
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
    );
  }
}

class UserCar {
  final String id;
  final String userId;

  /// Always holds the carId string (works for both shapes).
  final String carId;

  /// Filled when the API returns carId as an object (myCars endpoint).
  final EmbeddedCar? car;

  final String brandId;
  final String brandName;
  final String registrationNumber;
  final String fuelType;
  final String variant;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? seater;

  UserCar({
    required this.id,
    required this.userId,
    required this.carId,
    required this.brandId,
    required this.brandName,
    required this.registrationNumber,
    required this.fuelType,
    required this.variant,
    this.car,
    this.createdAt,
    this.updatedAt,
    this.seater
  });

  factory UserCar.fromJson(Map<String, dynamic> json) {
    final dynamic carIdRaw = json['carId'];

    EmbeddedCar? embeddedCar;
    String carIdString;

    if (carIdRaw is Map<String, dynamic>) {
      embeddedCar = EmbeddedCar.fromJson(carIdRaw);
      carIdString = embeddedCar.id;
    } else if (carIdRaw is String) {
      carIdString = carIdRaw;
    } else {
      carIdString = '';
    }

    return UserCar(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      carId: carIdString,
      car: embeddedCar,
      brandId: json['brandId'] as String,
      brandName: json['brandName'] as String,
      registrationNumber: json['registrationNumber'] as String,
      fuelType: json['fuelType'] as String,
      variant: json['variant'] as String,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
          seater: json['seater'] ?? ''
    );
  }
}

/// Payload for create / edit user car
class UserCarRequest {
  final String carId;
  final String registrationNumber;
  final String fuelType;
  final String variant;
  final String seater;

  UserCarRequest({
    required this.carId,
    required this.registrationNumber,
    required this.fuelType,
    required this.variant,
    required this.seater
  });

  Map<String, dynamic> toJson() {
    return {
      "carId": carId,
      "registrationNumber": registrationNumber,
      "fuelType": fuelType,
      "variant": variant,
      "seater": seater
    };
  }
}
