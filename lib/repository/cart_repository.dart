import 'package:app/common/collection_name.dart';
import 'package:app/sevices/dialog_sevices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartRepository {
  static Future<void> addCart({
    required BuildContext context,
    required String productId,
    required int size,
    required int color,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    bool isSuccess = true;
    String message = "";
    try {
      final cartCollection = FirebaseFirestore.instance
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.carts);

      final cart = await cartCollection.get();
      QueryDocumentSnapshot<Map<String, dynamic>>? item;
      int quantity = 1;
      //cart.docs.map((e) => e.id).toList();
      // cart.docs.map((e) => e.id).toList(); tương đường với
      for (final cart in cart.docs) {
        if (cart.data()['productId'] == productId &&
            cart.data()['size'] == size &&
            cart.data()['color'] == color) {
          item = cart;
        }
      }
      if (item != null) {
        quantity = (item['quantity'] ?? 0) + 1;
        await cartCollection.doc(item.id).set({
          "productId": productId,
          "size": size,
          "color": color,
          "quantity": quantity,
        });
      } else {
        await cartCollection.add({
          "productId": productId,
          "size": size,
          "color": color,
          "quantity": quantity,
        });
      }

      message = "Thêm giỏ hàng thành công";
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      message = e.message ?? 'Lỗi hệ thống';
    } finally {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: isSuccess,
        content: message,
      );
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.carts)
        .snapshots();
  }

  static Future<void> deleteCartItem(String cartItemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.carts)
        .doc(cartItemId)
        .delete();
  }

  static Future<void> deleteAllCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartCollection = FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.carts);

    final carts = await cartCollection.get();
    for (final cart in carts.docs) {
      await cart.reference.delete();
    }
  }

  static Future<void> updateCartQuantity({
    required String cartItemId,
    required int newQuantity,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (newQuantity <= 0) {
      // Nếu số lượng <= 0 thì xóa sản phẩm
      await deleteCartItem(cartItemId);
      return;
    }

    await FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.carts)
        .doc(cartItemId)
        .update({'quantity': newQuantity});
  }

  static Future<double> calculateSubtotal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    double subtotal = 0;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.carts)
        .get();

    for (final cartDoc in cartSnapshot.docs) {
      final cartData = cartDoc.data();
      final productId = cartData['productId'];
      final quantity = cartData['quantity'] ?? 1;

      final productDoc = await FirebaseFirestore.instance
          .collection(CollectionName.product)
          .doc(productId)
          .get();

      if (productDoc.exists) {
        final price = productDoc.data()?['price'] ?? 0;
        subtotal += (price * quantity);
      }
    }

    return subtotal;
  }
}
