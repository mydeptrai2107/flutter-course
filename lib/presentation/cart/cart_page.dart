import 'package:app/common/collection_name.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/presentation/cart/providers/cart_provider.dart';
import 'package:app/presentation/cart/widget/cart_widget_item.dart';
import 'package:app/presentation/checkout/checkout_page.dart';
import 'package:app/presentation/checkout/widget/checkout_summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final double shippingFee = 15000;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().listenCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.cartItems.isEmpty) {
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
                  Text('Giỏ hàng trống', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(child: _buildCartList()),
              _buildCheckoutSection(),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Giỏ hàng',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  /// ================= CART LIST =================
  Widget _buildCartList() {
    return Selector<CartProvider, List<CartModel>>(
      selector: (_, provider) => provider.cartItems,
      builder: (context, cartItems, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildHeader(cartItems.length),
              const SizedBox(height: 10),
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
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final product = ProductModel.fromJson(
                          snapshot.data!.data()!,
                        );
                        product.id = snapshot.data!.id;

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
        );
      },
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            '$itemCount Sản phẩm',
            style: const TextStyle(fontSize: 10, color: Colors.lightBlueAccent),
          ),
        ),
        TextButton.icon(
          onPressed: () => context.read<CartProvider>().deleteAllCartItems(),
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  /// ================= CHECKOUT =================
  Widget _buildCheckoutSection() {
    return Selector<CartProvider, double>(
      selector: (_, provider) => provider.subTotal,
      builder: (context, subtotal, child) {
        final total = subtotal + shippingFee;

        return CheckoutSummary(
          subTotal: subtotal,
          shippingFee: shippingFee,
          buttonText: 'Thanh toán',
          onCheckout: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckoutPage()),
            );
          },
        );
      },
    );
  }
}
