import 'package:app/common/collection_name.dart';
import 'package:app/common/data.dart';
import 'package:app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  static Future<void> loadProductData() async {
    try {
      for(final item in shoes){
        await FirebaseFirestore.instance
            .collection(CollectionName.product)
            .doc().set(item);
      }
      
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
  static Future<List<ProductModel>> fetchProduct() async {
    List<ProductModel> products = [];
    final snapshot = await FirebaseFirestore.instance
        .collection(CollectionName.product)
        .get();
    // products = snapshot.docs
    //     .map((e) => ProductModel.fromJson(e.data()))
    //     .toList();
    // productByBrand = List.from(products);

    for (final item in snapshot.docs) {
      final product = ProductModel.fromJson(item.data());
      product.id = item.id;
      products.add(product);
    }
    return products;
  }
}
