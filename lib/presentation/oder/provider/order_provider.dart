import 'package:app/models/order_model.dart';
import 'package:app/repository/order_repository.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchUserOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _repository.getUserOrders();
    } catch (e) {
      print("Error fetching orders : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
