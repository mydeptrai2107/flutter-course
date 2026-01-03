import 'package:app/common/collection_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutRepository {
  Future<void> addCheckoutInfo(
    String name,
    String sdt,
    String address,
    bool isDefault,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final checkoutCollect = FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.checkoutInfo);

    try {
      if (isDefault) {
        final inforData = await checkoutCollect.get();

        for (final infor in inforData.docs) {
          await infor.reference.update({"isDefault": false});
        }
      }
      await checkoutCollect.add({
        "name": name,
        "sdt": sdt,
        "address": address,
        "isDefault": isDefault,
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> checkout(String name, String sdt, String address) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final cartCollection = FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.carts);

    final checkoutCollection = FirebaseFirestore.instance
        .collection(CollectionName.user)
        .doc(user.uid)
        .collection(CollectionName.checkout);

    try {
      final cartDocs = await cartCollection.get();
      final carts = cartDocs.docs.map((e) => e.data()).toList();
      await checkoutCollection.add({
        "carts": carts,
        "name": name,
        "sdt": sdt,
        "address": address,
      });
      await cartCollection.doc().delete();
    } catch (_) {
      rethrow;
    }
  }
}
