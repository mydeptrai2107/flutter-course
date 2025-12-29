import 'dart:async';

import 'package:app/models/cart_model.dart';
import 'package:app/repository/cart_repository.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _cartItems = [];
  List<CartModel> get cartItems => _cartItems;
  double _subTotal = 0;
  double get subTotal => _subTotal;
  StreamSubscription? _cartSubscription;
  void listenCart() {
    _cartSubscription?.cancel();
    _cartSubscription = CartRepository.getCartItems().listen((snapshot) async {
      _cartItems = snapshot.docs
          .map((doc) => CartModel.fromJson(doc.id, doc.data()))
          .toList();

      _subTotal = await CartRepository.calculateSubtotal();
      notifyListeners();
    });
  }

  Future<void> deleteAllCartItems() async {
    await CartRepository.deleteAllCartItems();
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}
