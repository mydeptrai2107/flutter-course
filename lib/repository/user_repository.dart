import 'package:app/common/collection_name.dart';
import 'package:app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<UserModel?> getCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final doc = await _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data() ?? {}, doc.id);
    } catch (e) {
      print('Lỗi không xác định : $e');
      return null;
    }
  }

  static Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection(CollectionName.user).doc(user.uid).update({
        'name': name,
        'phone': phone,
      });
      return true;
    } catch (e) {
      print('Lỗi cập nhật Profile : $e');
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('Error logging out: $e');
      return false;
    }
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) return false;

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
}
