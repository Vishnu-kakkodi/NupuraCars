class CarDecorCategoryModel {
  final String id;
  final String name;
  final String image;

  CarDecorCategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CarDecorCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CarDecorCategoryModel(id: '', name: '', image: '');
    }

    return CarDecorCategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?['url']?.toString() ?? '',
    );
  }
}
