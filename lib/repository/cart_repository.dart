import 'package:app/common/collection_name.dart';
import 'package:app/services/dialog_services.dart';
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
          .collection(CollectionName.users)
          .doc(user.uid)
          .collection(CollectionName.carts);

      final carts = await cartCollection.get();
      QueryDocumentSnapshot<Map<String, dynamic>>? item;
      int quantity = 1;

      for (final cart in carts.docs) {
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

      message = 'Thêm vào giỏ hàng thành công';
    } on FirebaseException catch (e) {
      isSuccess = false;
      message = e.message ?? 'Lỗi hệ thống';
    } finally {
      DialogServices.notificeDialog(
        context: context,
        isSuccess: isSuccess,
        content: message,
      );
    }
  }
}
