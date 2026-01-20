import 'package:app/models/order_model.dart';
import 'package:app/repository/order_repository.dart';
import 'package:flutter/material.dart';

class OrderHistoryProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders() async {
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {

      _orders = await _orderRepository.getUserOrders();
      
    } catch (e) {
      print('Provider: Error $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<OrderModel> getOrdersByStatus(String status) {
    final filtered = _orders.where((order) => order.status == status).toList();

    return filtered;
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final success = await _orderRepository.cancelOrder(orderId);
      if (success) {
        await fetchOrders();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
