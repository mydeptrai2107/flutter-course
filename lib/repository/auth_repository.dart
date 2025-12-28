import 'package:app/common/collection_name.dart';
import 'package:app/sevices/dialog_sevices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  static get DialogServices => null;

  static Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String confirm,
  }) async {
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: 'Vui lòng điền đầy đủ thông tin',
      );
      return;
    }

    if (password != confirm) {
      DialogSevices.notificeDialog(
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
            .collection(CollectionName.user)
            .doc(uid)
            .set({
              "name": userCredential.user?.displayName,
              "avatar": userCredential.user?.photoURL,
              "email": userCredential.user?.email,
            });
      }

      await DialogSevices.notificeDialog(
        context: context,
        isSuccess: true,
        content: 'Tạo tài khoản thành công',
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      DialogSevices.notificeDialog(
        context: context,
        isSuccess: false,
        content: e.message ?? 'Hệ thống có lỗi. Vui lòng thử lại',
      );
    }
  }
}
