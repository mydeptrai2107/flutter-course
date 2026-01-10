import 'package:app/common/collection_name.dart';
import 'package:app/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ================= QUẢN LÝ ĐỊA CHỈ GIAO HÀNG =================

  // Thêm địa chỉ mới
  Future<String?> addCheckoutInfo({
    required String name,
    required String sdt,
    required String address,
    required String city,
    required String district,
    required bool isDefault,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final checkoutCollection = _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo);

      if (isDefault) {
        final querySnapshot = await checkoutCollection
            .where('isDeufalt', isEqualTo: true)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.update({"isDefault": false});
        }
      }

      final docRef = await checkoutCollection.add({
        'name': name,
        'sdt': sdt,
        'address': address,
        'city': city,
        'district': district,
        'isDefault': isDefault,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      print('Error adding checkout info: $e');
      return null;
    }
  }

  // Lấy danh sách địa chỉ
  Future<List<Map<String, dynamic>>> getCheckoutInfoList() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final querySnapshot = await _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting checkout info list: $e');
      return [];
    }
  }

  // Lấy địa chỉ mặc định
  Future<Map<String, dynamic>?> getDefaultCheckoutInfo() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final querySnapshot = await _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo)
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return data;
      }

      // nếu không có địa chỉ mặc định thì lấy địa chỉ đầu tiên
      final allAddresses = await _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      if (allAddresses.docs.isNotEmpty) {
        final data = allAddresses.docs.first.data();
        data['id'] = allAddresses.docs.first.id;

        //đặt làm mặc định
        await allAddresses.docs.first.reference.update({'isDeult': true});
        return data;
      }

      return null;
    } catch (e) {
      print('Error getting default checkout info: $e');
      return null;
    }
  }

  // Cập nhật địa chỉ
  Future<bool> updateCheckoutInfo({
    required String addressId,
    required String name,
    required String sdt,
    required String address,
    required String city,
    required String district,
    required bool isDefault,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final checkoutCollection = _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo);
      // chỉ update khi mà isdefault = true
      if (isDefault) {
        final querySnapshot = await checkoutCollection
            .where('isDeult', isEqualTo: true)
            .get();
        for (var doc in querySnapshot.docs) {
          if (doc.id != addressId) {
            await doc.reference.update({"isDefault": false});
          }
        }
      }

      await checkoutCollection.doc(addressId).update({
        'name': name,
        'sdt': sdt,
        'address': address,
        'city': city,
        'district': district,
        'isDefault': isDefault,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error updating checkout info: $e');
      return false;
    }
  }

  //set địa chỉ làm mặc định
  Future<bool> setDefaultAddress(String addressId) async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      final checkoutCollection = _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo);

      //bỏ địa chỉ mặc định của tất cả
      final allAddresses = await checkoutCollection
          .where('isDefault', isEqualTo: true)
          .get();
      for (var doc in allAddresses.docs) {
        await doc.reference.update({'isDefault': false});
      }
      //đặt địa chỉ mới làm default
      await checkoutCollection.doc(addressId).update({'isDefault': true});
      return true;
    } catch (e) {
      print('lỗi đặt địa chỉ mặc định $e');
      return false;
    }
  }

  // Xóa địa chỉ
  Future<bool> deleteCheckoutInfo(String addressId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final checkoutCollection = await _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo);
      // kiểm tra xem địa chỉ đang xóa có phải địa chri mặc định hay không
      final docSnapshot = await checkoutCollection.doc(addressId).get();
      final wasDefault = docSnapshot.data()?['isDefault'] == true;
      //xóa địa chỉ
      await checkoutCollection.doc(addressId).delete();

      //nếu xóa địa chỉ default ,set địa chỉ khác làm default
      if (wasDefault) {
        final remainingAddresses = await checkoutCollection
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();
        if (remainingAddresses.docs.isNotEmpty) {
          await remainingAddresses.docs.first.reference.update({
            'isDefault': true,
          });
        }
      }
      return true;
    } catch (e) {
      print('Error deleting checkout info: $e');
      return false;
    }
  }

  /// ================= QUẢN LÝ ĐƠN HÀNG =================

  // Tạo đơn hàng
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

  // Xóa giỏ hàng sau khi đặt hàng
  Future<bool> clearCart() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final cartCollection = _firestore
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.carts);

      final cartDocs = await cartCollection.get();
      for (var doc in cartDocs.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }
}
