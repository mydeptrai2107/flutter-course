import 'package:flutter/material.dart';

class OrderModel {
  String? id;
  final String userId;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String district;
  final double subTotal;
  final double shippingFee;
  final double total;
  final String status;
  final List<OrderItem> items;
  final DateTime createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.district,
    required this.subTotal,
    required this.shippingFee,
    required this.total,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'district': district,
      'subTotal': subTotal,
      'shippingFee': shippingFee,
      'total': total,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        id: json['id'],
        userId: json['userId'] ?? '',
        fullName: json['fullName'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        district: json['district'] ?? '',
        subTotal: (json['subTotal'] ?? 0).toDouble(),
        shippingFee: (json['shippingFee'] ?? 0).toDouble(),
        total: (json['total'] ?? 0).toDouble(),
        status: json['status'] ?? 'pending',
        items:
            (json['items'] as List<dynamic>?)
                ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: json['createdAt'] is String
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
    } catch (e) {
      print('❌ Error parsing OrderModel: $e');
      print('📦 JSON data: $json');
      rethrow;
    }
  }

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText() {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'processing':
        return 'Đang vận chuyển';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num).toDouble(),
    );
  }
}
