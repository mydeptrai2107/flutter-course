import 'package:app/common/collection_name.dart';
import 'package:app/common/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandRepository {
  static Future<void> loadBrandData() async {
    for (final brand in brandData) {
      await FirebaseFirestore.instance
          .collection(CollectionName.brand)
          .add(brand);
    }
  }
}
