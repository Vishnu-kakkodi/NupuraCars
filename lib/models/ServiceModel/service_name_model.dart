// class ServiceNameModel {
//   final String id;
//   final String serviceType;
//   final String serviceName;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   ServiceNameModel({
//     required this.id,
//     required this.serviceType,
//     required this.serviceName,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ServiceNameModel.fromJson(Map<String, dynamic> json) {
//     return ServiceNameModel(
//       id: json['_id'] ?? '',
//       serviceType: json['serviceType'] ?? '',
//       serviceName: json['serviceName'] ?? '',
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
// }















class ServiceNameModel {
  final String id;
  final String serviceType;
  final String serviceName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceNameModel({
    required this.id,
    required this.serviceType,
    required this.serviceName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceNameModel.fromJson(Map<String, dynamic> json) {
    return ServiceNameModel(
      id: _parseString(json['_id']),
      serviceType: _parseString(json['serviceType']),
      serviceName: _parseString(json['serviceName']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
}
DateTime _parseDate(dynamic value) {
  if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);

  if (value is DateTime) return value;

  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  if (value is int) {
    // supports timestamp (seconds or milliseconds)
    if (value.toString().length == 10) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

String _parseString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  if (value is String) return value;
  return value.toString();
}
