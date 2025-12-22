class CartModel {
  final List<CartItem> items;
  final int total;

  CartModel({required this.items, required this.total});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['packages'] as List)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      total: json['total'],
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final int price;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['packageId'],
      name: json['packageName'],
      price: json['offerPrice'],
      image: json['image']['url'],
    );
  }
}
