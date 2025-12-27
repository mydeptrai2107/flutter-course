import 'package:app/common/collection_name.dart';
import 'package:app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  static Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection(CollectionName.users)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>, user.uid);
      }
      return null;
    } catch (e) {
      print('Lỗi lấy user: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
