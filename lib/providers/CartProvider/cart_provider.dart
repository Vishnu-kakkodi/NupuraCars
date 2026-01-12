import 'package:flutter/material.dart';
import 'package:nupura_cars/models/Cart/cart_model.dart';

import '../../services/service_api.dart'; // for getCart

class CartProvider extends ChangeNotifier {
  CartModel? cart;
  bool isLoading = false;

  int get count => cart?.items.length ?? 0;

  Future<void> loadCart(String userId) async {
        print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");

    isLoading = true;
    notifyListeners();

    cart = await ServiceApi.fetchCart(userId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(String userId, String packageId) async {
    await ServiceApi.addToCart(userId, packageId);
    await loadCart(userId);
  }

  /// ✅ NEW: REMOVE ITEM USING API
  Future<void> removeLocal(String userId, String packageId) async {
    try {
      await ServiceApi.removeFromCart(
        userId: userId,
        packageId: packageId,
      );

      /// Refresh cart from backend (source of truth)
      await loadCart(userId);
    } catch (e) {
      rethrow;
    }
  }
}
