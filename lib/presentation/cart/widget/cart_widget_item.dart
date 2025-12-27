import 'package:app/common/constant.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/repository/cart_repository.dart';
import 'package:flutter/material.dart';

class CartWidgetItem extends StatelessWidget {
  const CartWidgetItem({
    super.key,
    required this.cartItem,
    required this.product,
  });

  final CartModel cartItem;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.images,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Size: ${cartItem.size}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colors[cartItem.color],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.price} đ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              await CartRepository.updateCartQuantity(
                                cartItemId: cartItem.id,
                                newQuantity: cartItem.quantity - 1,
                              );
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),

                          InkWell(
                            onTap: () async {
                              await CartRepository.updateCartQuantity(
                                cartItemId: cartItem.id,
                                newQuantity: cartItem.quantity + 1,
                              );
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await CartRepository.deleteCartItem(cartItem.id);
            },
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.close,
                color: Color.fromARGB(255, 250, 144, 144),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
