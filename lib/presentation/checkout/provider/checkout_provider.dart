import 'package:app/common/collection_name.dart';
import 'package:app/repository/checkout_repository.dart';
import 'package:app/presentation/cart/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  final CheckoutRepository _checkoutRepository = CheckoutRepository();
  final CartProvider _cartProvider;

  CheckoutProvider(this._cartProvider) {
    _initialize();
  }

  String? _name;
  String? _phone;
  String? _address;
  int _paymentMethod = 1;

  String? get name => _name;
  String? get phone => _phone;
  String? get address => _address;
  int get paymentMethod => _paymentMethod;
  @override
  double get subTotal => _cartProvider.subTotal;

  Future<void> _initialize() async {
    await loadDefaultContactInfo();
  }

  Future<void> loadDefaultContactInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final checkoutInfoCollection = FirebaseFirestore.instance
          .collection(CollectionName.user)
          .doc(user.uid)
          .collection(CollectionName.checkoutInfo);

      final defaultInfo = await checkoutInfoCollection
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (defaultInfo.docs.isNotEmpty) {
        final data = defaultInfo.docs.first.data();
        _name = data['name'];
        _phone = data['sdt'];
        _address = data['address'];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading default contact info: $e');
    }
  }

  Future<void> saveContactInfo(
    String name,
    String phone,
    String address,
  ) async {
    try {
      await _checkoutRepository.addCheckoutInfo(name, phone, address, true);
      _name = name;
      _phone = phone;
      _address = address;
      notifyListeners();
    } catch (e) {
      print('Error saving contact info: $e');
    }
  }

  void updatePaymentMethod(int method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void updateContactInfo(String? name, String? phone, String? address) {
    _name = name;
    _phone = phone;
    _address = address;
    notifyListeners();
  }
}
