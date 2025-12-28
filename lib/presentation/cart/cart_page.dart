import 'package:app/common/collection_name.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/presentation/cart/widget/cart_widget_item.dart';
import 'package:app/repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final double shippingFee = 15000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: CartRepository.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Giỏ hàng trống',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final cartItems = snapshot.data!.docs
              .map((doc) => CartModel.fromJson(doc.id, doc.data()))
              .toList();

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              '${cartItems.length} Sản Phẩm',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await CartRepository.deleteAllCartItems();
                            },
                            label: const Text(
                              'Xóa tất cả',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            icon: const Icon(
                              Icons.delete_outlined,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];

                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection(CollectionName.product)
                                  .doc(cartItem.productId)
                                  .get(),
                              builder: (context, productSnapshot) {
                                if (!productSnapshot.hasData) {
                                  return const SizedBox();
                                }

                                final product = ProductModel.fromJson(
                                  productSnapshot.data!.data()!,
                                );
                                product.id = productSnapshot.data!.id;

                                return CartWidgetItem(
                                  cartItem: cartItem,
                                  product: product,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildCheckoutSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return FutureBuilder<double>(
      future: CartRepository.calculateSubtotal(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final subtotal = snapshot.data!;
        final total = subtotal + shippingFee;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPriceRow('Thành tiền', subtotal),
              const SizedBox(height: 12),
              _buildPriceRow('Vận chuyển', shippingFee),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              _buildPriceRow('Tổng cộng', total, isTotal: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Chức năng thanh toán
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          '${amount.toStringAsFixed(0)} đ',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.lightBlueAccent : Colors.black,
          ),
        ),
      ],
    );
  }
}
