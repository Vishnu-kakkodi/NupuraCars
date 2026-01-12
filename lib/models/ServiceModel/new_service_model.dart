// class SubServiceModel {
//   final String id;
//   final String name;
//   final List<PackageModel> packages;

//   SubServiceModel({
//     required this.id,
//     required this.name,
//     required this.packages,
//   });

//   factory SubServiceModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       return SubServiceModel(
//         id: '',
//         name: '',
//         packages: const [],
//       );
//     }

//     return SubServiceModel(
//       id: json['_id']?.toString() ?? '',
//       name: json['subServiceName']?.toString() ?? '',
//       packages: (json['packages'] is List)
//           ? (json['packages'] as List)
//               .where((e) => e != null)
//               .map((e) => PackageModel.fromJson(e))
//               .toList()
//           : [],
//     );
//   }
// }

// class PackageModel {
//   final String id;
//   final String name;
//   final int price;
//   final int offerPrice;
//   final double rating;
//   final String image;
//   final List<String> benefits;

//   PackageModel({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.offerPrice,
//     required this.rating,
//     required this.image,
//     required this.benefits,
//   });

//   factory PackageModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       return PackageModel(
//         id: '',
//         name: '',
//         price: 0,
//         offerPrice: 0,
//         rating: 0.0,
//         image: '',
//         benefits: const [],
//       );
//     }

//     /// ✅ SAFELY PARSE BENEFITS
//     List<String> parsedBenefits = [];
//     if (json['benefits'] is List) {
//       for (final b in json['benefits']) {
//         if (b is String) {
//           parsedBenefits.addAll(
//             b.replaceAll('[', '')
//                 .replaceAll(']', '')
//                 .replaceAll('"', '')
//                 .split(',')
//                 .map((e) => e.trim())
//                 .where((e) => e.isNotEmpty),
//           );
//         }
//       }
//     }

//     return PackageModel(
//       id: json['_id']?.toString() ?? '',
//       name: json['packageName']?.toString() ?? '',
//       price: _toInt(json['price']),
//       offerPrice: _toInt(json['offerPrice']),
//       rating: _toDouble(json['ratings']),
//       image: json['image'] is Map
//           ? json['image']['url']?.toString() ?? ''
//           : '',
//       benefits: parsedBenefits,
//     );
//   }

//   // ---------------- HELPERS ----------------

//   static int _toInt(dynamic v) {
//     if (v == null) return 0;
//     if (v is int) return v;
//     if (v is double) return v.toInt();
//     return int.tryParse(v.toString()) ?? 0;
//   }

//   static double _toDouble(dynamic v) {
//     if (v == null) return 0.0;
//     if (v is double) return v;
//     if (v is int) return v.toDouble();
//     return double.tryParse(v.toString()) ?? 0.0;
//   }
// }



















class SubServiceModel {
  final String id;
  final String name;
  final List<PackageModel> packages;

  SubServiceModel({
    required this.id,
    required this.name,
    required this.packages,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SubServiceModel(
        id: '',
        name: '',
        packages: const [],
      );
    }

    final rawPackages = json['packages'];

    return SubServiceModel(
      id: _toString(json['_id']),
      name: _toString(json['subServiceName']),
      packages: rawPackages is List
          ? rawPackages
              .whereType<Map<String, dynamic>>()
              .map(PackageModel.fromJson)
              .toList()
          : const [],
    );
  }
}

class PackageModel {
  final String id;
  final String name;
  final int price;
  final int offerPrice;
  final double rating;
  final String image;
  final List<String> benefits;

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.offerPrice,
    required this.rating,
    required this.image,
    required this.benefits,
  });

  factory PackageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PackageModel(
        id: '',
        name: '',
        price: 0,
        offerPrice: 0,
        rating: 0.0,
        image: '',
        benefits: const [],
      );
    }

    return PackageModel(
      id: _toString(json['_id']),
      name: _toString(json['packageName']),
      price: _toInt(json['price']),
      offerPrice: _toInt(json['offerPrice']),
      rating: _toDouble(json['ratings']),
      image: _toString(json['image']?['url']),
      benefits: _parseBenefits(json['benefits']),
    );
  }
}

/// --------------------
/// SAFE HELPERS
/// --------------------

String _toString(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  return v.toString();
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

List<String> _parseBenefits(dynamic value) {
  if (value == null) return const [];

  // Case 1: Already a List
  if (value is List) {
    return value
        .whereType<String>()
        .expand((e) => e
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .split(','))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // Case 2: String like '["A","B"]'
  if (value is String) {
    return value
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return const [];
}
