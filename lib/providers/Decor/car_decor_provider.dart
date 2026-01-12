import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/models/Decor/car_decor_category_model.dart';
import 'package:nupura_cars/models/Decor/car_decor_product_model.dart';

class CarDecorProvider extends ChangeNotifier {
  bool loading = false;

  List<CarDecorCategoryModel> categories = [];
  List<CarDecorProductModel> products = [];

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    final res = await http.get(
      Uri.parse('http://31.97.206.144:4072/api/admin/getcardecorscat'),
    );

    final data = json.decode(res.body);
    categories = (data['cardecors'] as List? ?? [])
        .map((e) => CarDecorCategoryModel.fromJson(e))
        .toList();

    loading = false;
    notifyListeners();
  }

  Future<void> loadProducts(String categoryId) async {
    loading = true;
    notifyListeners();

    final res = await http.get(
      Uri.parse(
        'http://31.97.206.144:4072/api/admin/getcardecorproductbycat?cardecorId=$categoryId',
      ),
    );

    final data = json.decode(res.body);
    products = (data['cardecorProducts'] as List? ?? [])
        .map((e) => CarDecorProductModel.fromJson(e))
        .toList();

    loading = false;
    notifyListeners();
  }
}
