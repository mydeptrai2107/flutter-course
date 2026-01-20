import 'package:app/common/collection_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  Future<bool> checAdmin() async {
    final admin = await FirebaseFirestore.instance
        .collection(CollectionName.admins)
        .get();
    final idAdmin = admin.docs.first['id'];
    final auth = FirebaseAuth.instance.currentUser;
    return idAdmin == auth?.uid;
  }
}
