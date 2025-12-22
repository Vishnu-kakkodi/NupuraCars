class SubServiceModel {
  final String id;
  final String name;
  final List<PackageModel> packages;

  SubServiceModel({
    required this.id,
    required this.name,
    required this.packages,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    return SubServiceModel(
      id: json['_id'],
      name: json['subServiceName'],
      packages: (json['packages'] as List)
          .map((e) => PackageModel.fromJson(e))
          .toList(),
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

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'],
      name: json['packageName'],
      price: json['price'],
      offerPrice: json['offerPrice'],
      rating: (json['ratings'] ?? 0).toDouble(),
      image: json['image']['url'],
      benefits: (json['benefits'] as List)
          .expand((e) => List<String>.from(
              (e as String).replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',')))
          .toList(),
    );
  }
}
