import 'package:app/common/collection_name.dart';
import 'package:app/common/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  static Future<void> loadProductData() async {
    try {
      for (final item in shoes) {
        await FirebaseFirestore.instance
            .collection(CollectionName.product)
            .doc()
            .set(item);
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
