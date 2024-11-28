import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hawa_hawai_assignment/src/core/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products'));
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  return (data['products'] as List)
      .map((product) => ProductModel.fromJson(product))
      .toList();
});

final cartProvider = StateNotifierProvider<CartNotifier, Map<int, int>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<int, int>> {
  CartNotifier() : super({});

  void addToCart(int productId) {
    state = {...state, productId: (state[productId] ?? 0) + 1};
  }

  void removeFromCart(int productId) {
    if (state[productId] == 1) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId: (state[productId] ?? 1) - 1};
    }
  }
}
