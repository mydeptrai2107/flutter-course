import 'package:app/models/product_model.dart';
import 'package:app/repository/product_repository.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  int _brandSelected = 1;
  int get brandSelected => _brandSelected;

  Future<void> fetchProduct() async {
    _products = await ProductRepository.fetchProduct();
    notifyListeners();
  }

  void selectBrand(int id) {
    _brandSelected = id;
    notifyListeners();
  }
}
