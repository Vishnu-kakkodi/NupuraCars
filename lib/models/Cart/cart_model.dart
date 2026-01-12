// class CartModel {
//   final List<CartItem> items;
//   final int total;

//   CartModel({required this.items, required this.total});

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       items: (json['packages'] as List)
//           .map((e) => CartItem.fromJson(e))
//           .toList(),
//       total: json['total'],
//     );
//   }
// }

// class CartItem {
//   final String id;
//   final String name;
//   final int price;
//   final String image;

//   CartItem({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.image,
//   });

//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       id: json['packageId'],
//       name: json['packageName'],
//       price: json['offerPrice'],
//       image: json['image']['url'],
//     );
//   }
// }















class CartModel {
  final List<CartItem> items;
  final int total;

  CartModel({
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CartModel(items: const [], total: 0);
    }

    final packages = json['packages'];

    return CartModel(
      items: packages is List
          ? packages
              .whereType<Map<String, dynamic>>()
              .map((e) => CartItem.fromJson(e))
              .toList()
          : const [],
      total: _parseInt(json['total']),
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

  factory CartItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CartItem(
        id: '',
        name: '',
        price: 0,
        image: '',
      );
    }

    return CartItem(
      id: _parseString(json['packageId']),
      name: _parseString(json['packageName']),
      price: _parseInt(json['offerPrice']),
      image: _parseString(json['image']?['url']),
    );
  }
}

/// --------------------
/// SAFE PARSERS
/// --------------------

String _parseString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
