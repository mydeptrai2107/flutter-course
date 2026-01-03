class CartModel {
  String id;
  String productId;
  int size;
  int color;
  int quantity;
  CartModel({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.quantity,
  });

  static CartModel fromJson(String id, Map<String, dynamic> json) {
    return CartModel(
      id: id,
      productId: json['productId'] ?? '',
      size: json['size'] ?? 0,
      color: json['color'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }

  static Map<String, dynamic> toJson(CartModel cart) {
    return {
      "id": cart.id,
      "productId": cart.productId,
      "size": cart.size,
      "color": cart.color,
      "quantity": cart.quantity,
    };
  }
}
