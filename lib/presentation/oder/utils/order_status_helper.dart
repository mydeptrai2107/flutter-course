import 'package:flutter/material.dart';
import '../models/order_status.dart';

class OrderStatusUI {
  final String text;
  final Color color;
  final Color bg;
  final IconData icon;

  OrderStatusUI({
    required this.text,
    required this.color,
    required this.bg,
    required this.icon,
  });
}

OrderStatusUI getOrderStatusInfo(OrderStatus status) {
  switch (status) {
    case OrderStatus.processing:
      return OrderStatusUI(
        text: 'Chờ xử lý',
        color: Colors.orange,
        bg: Colors.orange.shade100,
        icon: Icons.inventory_2_outlined,
      );
    case OrderStatus.shipping:
      return OrderStatusUI(
        text: 'Đang giao',
        color: Colors.green,
        bg: Colors.green.shade100,
        icon: Icons.local_shipping_outlined,
      );
    case OrderStatus.cancelled:
      return OrderStatusUI(
        text: 'Đã hủy',
        color: Colors.red,
        bg: Colors.red.shade100,
        icon: Icons.cancel_outlined,
      );
  }
}
