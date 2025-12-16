import 'package:app/common/collection_name.dart';
import 'package:app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository {
  static final user = FirebaseAuth.instance.currentUser;
  static final firebaseStore = FirebaseFirestore.instance;

  static Future<void> addProductToFavorite(String productId) async {
    if (user == null) {
      return;
    }
    final favorite = firebaseStore
        .collection(CollectionName.users)
        .doc(user!.uid)
        .collection(CollectionName.favorite);

    final isFavorited = await favorite.doc(productId).get();
    if (isFavorited.exists) {
      favorite.doc(productId).delete();
    } else {
      favorite.doc(productId).set({"createAt": DateTime.now()});
    }
  }

  static Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    List<ProductModel> products = [];

    final snapshot = await firebaseStore
        .collection(CollectionName.product)
        .get();

    for (final item in snapshot.docs) {
      if (ids.contains(item.id)) {
        final product = ProductModel.fromJson(item.data());
        product.id = item.id;
        products.add(product);
      }
    }
    return products;
  }
}
