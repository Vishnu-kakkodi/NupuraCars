// class CurrentServiceCarResponse {
//   final String message;
//   final bool isSuccessfull;
//   final CurrentServiceCar currentCar;
//   final List<ServicePlan> plans;

//   CurrentServiceCarResponse({
//     required this.message,
//     required this.isSuccessfull,
//     required this.currentCar,
//     required this.plans,
//   });

//   factory CurrentServiceCarResponse.fromJson(Map<String, dynamic> json) {
//     return CurrentServiceCarResponse(
//       message: json['message'] ?? '',
//       isSuccessfull: json['isSuccessfull'] ?? false,
//       currentCar: CurrentServiceCar.fromJson(json['currentCar']),
//       plans: (json['plans'] as List<dynamic>? ?? [])
//           .map((e) => ServicePlan.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class CurrentServiceCar {
//   final String id;
//   final String userId;
//   final CarInfo carId;
//   final String brandId;
//   final String brandName;
//   final String registrationNumber;
//   final String fuelType;
//   final String variant;

//   CurrentServiceCar({
//     required this.id,
//     required this.userId,
//     required this.carId,
//     required this.brandId,
//     required this.brandName,
//     required this.registrationNumber,
//     required this.fuelType,
//     required this.variant,
//   });

//   factory CurrentServiceCar.fromJson(Map<String, dynamic> json) {
//     return CurrentServiceCar(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       carId: CarInfo.fromJson(json['carId'] ?? {}),
//       brandId: json['brandId'] ?? '',
//       brandName: json['brandName'] ?? '',
//       registrationNumber: json['registrationNumber'] ?? '',
//       fuelType: json['fuelType'] ?? '',
//       variant: json['variant'] ?? '',
//     );
//   }
// }

// class CarInfo {
//   final String id;
//   final String name;
//   final String image;
//   final BrandInfo? brand;

//   CarInfo({
//     required this.id,
//     required this.name,
//     required this.image,
//     this.brand,
//   });

//   factory CarInfo.fromJson(Map<String, dynamic> json) {
//     return CarInfo(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       image: json['image'] ?? '',
//       brand: json['brandId'] != null
//           ? BrandInfo.fromJson(json['brandId'])
//           : null,
//     );
//   }
// }

// class BrandInfo {
//   final String id;
//   final String name;

//   BrandInfo({
//     required this.id,
//     required this.name,
//   });

//   factory BrandInfo.fromJson(Map<String, dynamic> json) {
//     return BrandInfo(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }

// class ServicePlan {
//   final String id;
//   final String serviceId;
//   final String description;
//   final String brandId;
//   final String modelId;
//   final String fuelType;
//   final String variant;
//   final num price;

//   ServicePlan({
//     required this.id,
//     required this.serviceId,
//     required this.description,
//     required this.brandId,
//     required this.modelId,
//     required this.fuelType,
//     required this.variant,
//     required this.price,
//   });

//   factory ServicePlan.fromJson(Map<String, dynamic> json) {
//     return ServicePlan(
//       id: json['_id'] ?? '',
//       serviceId: json['serviceId'] ?? '',
//       description: json['description'] ?? '',
//       brandId: json['brandId'] ?? '',
//       modelId: json['modelId'] ?? '',
//       fuelType: json['fuelType'] ?? '',
//       variant: json['variant'] ?? '',
//       price: json['price'] ?? 0,
//     );
//   }
// }














/// ---------- SAFE HELPERS (reuse across models) ----------

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

num _parseNum(dynamic value, {num defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is num) return value;
  if (value is String) return num.tryParse(value) ?? defaultValue;
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

Map<String, dynamic> _parseMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

List<dynamic> _parseList(dynamic value) {
  if (value is List) return value;
  return <dynamic>[];
}

/// ---------- MODELS ----------

class CurrentServiceCarResponse {
  final String message;
  final bool isSuccessfull;
  final CurrentServiceCar currentCar;
  final List<ServicePlan> plans;

  CurrentServiceCarResponse({
    required this.message,
    required this.isSuccessfull,
    required this.currentCar,
    required this.plans,
  });

  factory CurrentServiceCarResponse.fromJson(Map<String, dynamic> json) {
    final currentCarJson = _parseMap(json['currentCar']);
    final plansJson = _parseList(json['plans']);

    return CurrentServiceCarResponse(
      message: _parseString(json['message']),
      isSuccessfull: _parseBool(json['isSuccessfull']),
      currentCar: CurrentServiceCar.fromJson(currentCarJson),
      plans: plansJson
          .where((e) => e != null)
          .map((e) => ServicePlan.fromJson(_parseMap(e)))
          .toList(),
    );
  }
}

class CurrentServiceCar {
  final String id;
  final String userId;
  final CarInfo carId;
  final String brandId;
  final String brandName;
  final String registrationNumber;
  final String fuelType;
  final String variant;

  CurrentServiceCar({
    required this.id,
    required this.userId,
    required this.carId,
    required this.brandId,
    required this.brandName,
    required this.registrationNumber,
    required this.fuelType,
    required this.variant,
  });

  factory CurrentServiceCar.fromJson(Map<String, dynamic> json) {
    return CurrentServiceCar(
      id: _parseString(json['_id']),
      userId: _parseString(json['userId']),
      carId: CarInfo.fromJson(_parseMap(json['carId'])),
      brandId: _parseString(json['brandId']),
      brandName: _parseString(json['brandName']),
      registrationNumber: _parseString(json['registrationNumber']),
      fuelType: _parseString(json['fuelType']),
      variant: _parseString(json['variant']),
    );
  }
}

class CarInfo {
  final String id;
  final String name;
  final String image;
  final BrandInfo? brand;

  CarInfo({
    required this.id,
    required this.name,
    required this.image,
    this.brand,
  });

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    final rawBrand = json['brandId'];

    BrandInfo? brand;
    if (rawBrand != null) {
      if (rawBrand is Map) {
        brand = BrandInfo.fromJson(_parseMap(rawBrand));
      } else if (rawBrand is String) {
        // Sometimes backend might just send brandId as string
        brand = BrandInfo(id: _parseString(rawBrand), name: '');
      }
    }

    return CarInfo(
      id: _parseString(json['_id']),
      name: _parseString(json['name']),
      image: _parseString(json['image']),
      brand: brand,
    );
  }
}

class BrandInfo {
  final String id;
  final String name;

  BrandInfo({
    required this.id,
    required this.name,
  });

  factory BrandInfo.fromJson(Map<String, dynamic> json) {
    return BrandInfo(
      id: _parseString(json['_id']),
      name: _parseString(json['name']),
    );
  }
}

class ServicePlan {
  final String id;
  final String serviceId;
  final String description;
  final String brandId;
  final String modelId;
  final String fuelType;
  final String variant;
  final num price;

  ServicePlan({
    required this.id,
    required this.serviceId,
    required this.description,
    required this.brandId,
    required this.modelId,
    required this.fuelType,
    required this.variant,
    required this.price,
  });

  factory ServicePlan.fromJson(Map<String, dynamic> json) {
    return ServicePlan(
      id: _parseString(json['_id']),
      serviceId: _parseString(json['serviceId']),
      description: _parseString(json['description']),
      brandId: _parseString(json['brandId']),
      modelId: _parseString(json['modelId']),
      fuelType: _parseString(json['fuelType']),
      variant: _parseString(json['variant']),
      price: _parseNum(json['price']),
    );
  }
}
