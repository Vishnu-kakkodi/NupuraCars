class CarDecorProductModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String image;
  final List<String> features;

  CarDecorProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.features,
  });

  factory CarDecorProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CarDecorProductModel(
        id: '',
        name: '',
        description: '',
        price: 0,
        image: '',
        features: const [],
      );
    }

    List<String> parsedFeatures = [];
    if (json['features'] is List) {
      for (final f in json['features']) {
        if (f is String) {
          parsedFeatures.addAll(
            f.replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '')
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty),
          );
        }
      }
    }

    return CarDecorProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      image: json['image']?['url']?.toString() ?? '',
      features: parsedFeatures,
    );
  }
}
