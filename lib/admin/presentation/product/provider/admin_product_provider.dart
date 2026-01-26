import 'package:app/admin/repository/admin_product_repository.dart';
import 'package:app/models/product_model.dart';
import 'package:flutter/widgets.dart';

class AdminProductProvider with ChangeNotifier {
  final AdminProductRepository _repository = AdminProductRepository();
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await _repository.getProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    await _repository.addProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(ProductModel product) async{
    await _repository.updateProduct(product);
    await fetchProducts();
  }
  Future<void> deleteProduct(String id) async{
    await _repository.deleteProduct(id);
    await fetchProducts();
  }
}
