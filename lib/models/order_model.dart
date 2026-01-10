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
    this.status = 'pending',
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
    return OrderModel(
      id: json['id'],
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      subTotal: (json['subTotal'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] ?? 'pending',
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
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