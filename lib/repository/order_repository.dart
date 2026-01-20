import 'package:app/common/collection_name.dart';
import 'package:app/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy tên sản phẩm từ product ID
  Future<String> getProductName(String productId) async {
    try {
      final doc = await _firestore
          .collection(CollectionName.product)
          .doc(productId)
          .get();

      if (doc.exists) {
        return doc['name'] ?? 'Sản phẩm';
      }
      return 'Sản phẩm';
    } catch (e) {
      print('Error getting product name: $e');
      return 'Sản phẩm';
    }
  }

  /// Lấy hình ảnh sản phẩm từ product ID
  Future<String> getProductImage(String productId) async {
    try {
      final doc = await _firestore
          .collection(CollectionName.product)
          .doc(productId)
          .get();

      if (doc.exists) {
        final images = doc['images'];
        if (images is List && images.isNotEmpty) {
          return images[0] ?? '';
        }
      }
      return '';
    } catch (e) {
      print('Error getting product image: $e');
      return '';
    }
  }

  /// Tạo đơn hàng
  Future<String?> createOrder(OrderModel order) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final docRef = await _firestore
          .collection(CollectionName.orders)
          .add(order.toJson());

      return docRef.id;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  /// Lấy danh sách đơn hàng của người dùng hiện tại
  Future<List<OrderModel>> getUserOrders() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      return [];
    }

    try {
      print('Fetching orders for user: ${user.uid}');

      // Query đơn hàng theo userId
      final querySnapshot = await _firestore
          .collection(CollectionName.orders)
          .where('userId', isEqualTo: user.uid)
          .get();

      print('Found ${querySnapshot.docs.length} orders');

      final orders = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();

      // Sắp xếp theo createdAt (descending) ở phía client
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Lấy tên sản phẩm thật từ Firestore cho tất cả items
      for (var order in orders) {
        for (var item in order.items) {
          if (item.productId.isNotEmpty) {
            try {
              final doc = await _firestore
                  .collection(CollectionName.product)
                  .doc(item.productId)
                  .get();
              if (doc.exists && doc['name'] != null) {
                item.productName = doc['name'];
                print(
                  'Fetched product name: ${item.productId} -> ${item.productName}',
                );
              }
            } catch (e) {
              print('Error fetching product name for ${item.productId}: $e');
              // Giữ productName cũ nếu fetch thất bại
            }
          }
        }
      }

      return orders;
    } catch (e) {
      print('Error fetching user orders: $e');
      return [];
    }
  }
}
