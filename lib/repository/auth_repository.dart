import 'package:app/common/collection_name.dart';
import 'package:app/services/dialog_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  static Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirm,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      DialogServices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Vui lòng điền đầy đủ thông tin',
      );
      return;
    }

    if (password != confirm) {
      DialogServices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Mật khẩu không khớp',
      );
      return;
    }
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;
      if (uid != null) {
        FirebaseFirestore.instance
            .collection(CollectionName.users)
            .doc(uid)
            .set({
              "name": name,
              "avatar": userCredential.user?.photoURL,
              "email": email,
              "phone": phone,
            });
      }
      await DialogServices.notificeDialog(
        context: context,
        isSuccess: true,
        content: 'Tạo tài khoản thành công',
      );
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      DialogServices.notificeDialog(
        context: context,
        isSuccess: false,
        content: e.message ?? 'Hệ thống có lỗi. Vui lòng thử lại',
      );
    }
  }
}
