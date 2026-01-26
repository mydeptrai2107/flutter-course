import 'package:app/common/collection_name.dart';
import 'package:app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _firestore
          .collection(CollectionName.product)
          .get();
      
      return snapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
     
      rethrow; 
    }
  }

  Future<void> addProduct(ProductModel product) async {
    // Lấy số lượng sản phẩm hiện tại
    final snapshot = await _firestore.collection(CollectionName.product).get();
    final newId = snapshot.docs.length + 1; // Tính id mới

    // Tạo sản phẩm mới với id là số thứ tự
    final newProduct = product.copyWith(id: newId.toString());
    await _firestore
        .collection(CollectionName.product)
        .add(newProduct.toJson()); // Sử dụng Firestore tự tạo doc ID
  }

  Future<void> updateProduct(ProductModel product) async{
    try{
      await _firestore.collection(CollectionName.product).doc(product.id).update(product.toJson());
    }catch (e){
      print('Error updating product : $e');
      rethrow;
    }
    
  }

  Future<void> deleteProduct(String id) async {
    try{
      await _firestore.collection(CollectionName.product).doc(id).delete();
    } catch (e) {
    print('Error deleting product: $e');
    rethrow;
  }
  }
}
