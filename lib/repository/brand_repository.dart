import 'package:app/common/collection_name.dart';
import 'package:app/common/data.dart';
import 'package:app/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandRepository {
  static Future<void> loadBrandData() async {
    for (final brand in brandsData) {
      await FirebaseFirestore.instance
          .collection(CollectionName.brand)
          .add(brand);
    }
  }
  static Future<List<BrandModel>> getBrands() async{
    try{
      final snapshot = await FirebaseFirestore.instance.collection(CollectionName.brand).get();
      return snapshot.docs.map((doc) => BrandModel.fromJson(doc.data())).toList();
    } on FirebaseException catch(e){
      print(e.message);
      return [];
    }
  }
}
