import 'package:app/common/collection_name.dart';
import 'package:app/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> getUserOrders() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      // Loại bỏ orderBy tạm thời để tránh lỗi thiếu index
      final querySnapshot = await _firestore
          .collection(CollectionName.orders)
          .where('userId', isEqualTo: user.uid)
          .get();
      if (querySnapshot.docs.isEmpty) {

        return [];
      }

      final orders = <OrderModel>[];
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;

          final order = OrderModel.fromJson(data);
          orders.add(order);
        } catch (e, stackTrace) {
          print('   Stack: $stackTrace');
        }
      }

      // Sắp xếp theo createdAt trong code thay vì query
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e, stackTrace) {
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    try {

      final querySnapshot = await _firestore
          .collection(CollectionName.orders)
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: status)
          .get();


      final orders = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      print('Error getting orders by status: $e');
      return [];
    }
  }

  Future<OrderModel?> getOrderDetail(String OrderId) async {
    try {
      final docSnapshot = await _firestore
          .collection(CollectionName.orders)
          .doc(OrderId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;
      return OrderModel.fromJson(data);
    } catch (e) {
      print('Lỗi lấy chi tiết đơn hàng $e');
      return null;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      await _firestore.collection(CollectionName.orders).doc(orderId).update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Lỗi hủy đơn hàng');
      return false;
    }
  }


  // Lấy tên một sản phẩm
  Future<String> getProductName(String productId) async {
    try {
      final doc = await _firestore
          .collection(CollectionName.product)
          .doc(productId)
          .get();

      if (doc.exists) {
        final name = doc.data()?['name'];
        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
      return 'Sản phẩm không tồn tại';
    } catch (e) {
      print('Error getting product name for $productId: $e');
      return 'Lỗi tải tên sản phẩm';
    }
  }

  Future<Map<String, String>> getProductNames(List<String> productIds) async {
    final Map<String, String> productNames = {};

    try {
      // Sử dụng Future.wait để tải song song
      final futures = productIds.map(
        (id) => _firestore.collection(CollectionName.product).doc(id).get(),
      );

      final docs = await Future.wait(futures);

      for (int i = 0; i < productIds.length; i++) {
        final doc = docs[i];
        if (doc.exists) {
          productNames[productIds[i]] =
              doc.data()?['name'] ?? 'Sản phẩm không tồn tại';
        } else {
          productNames[productIds[i]] = 'Sản phẩm không tồn tại';
        }
      }

      return productNames;
    } catch (e) {
      print('❌ Error getting product names: $e');
      return {};
    }
  }
}
