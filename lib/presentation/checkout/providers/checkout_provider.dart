import 'package:app/common/collection_name.dart';
import 'package:app/models/checkout_info_model.dart';
import 'package:flutter/material.dart';
import 'package:app/models/order_model.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/repository/checkout_repository.dart';

class CheckoutProvider extends ChangeNotifier {
  final CheckoutRepository _repository = CheckoutRepository();

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Checkout info từ Firestore
  CheckoutInfoModel? _checkoutInfo;
  CheckoutInfoModel? get checkoutInfo => _checkoutInfo;

  // Form fields (backup nếu không có checkout info)
  String _fullName = '';
  String _phone = '';
  String _address = '';
  String _city = '';
  String _district = '';

  // Getters
  String get fullName => _checkoutInfo?.name ?? _fullName;
  String get phone => _checkoutInfo?.sdt ?? _phone;
  String get address => _checkoutInfo?.address ?? _address;
  String get city => _checkoutInfo?.city ?? _city;
  String get district => _checkoutInfo?.district ?? _district;

  /// Load thông tin checkout mặc định của user từ Firestore
  Future<void> loadDefaultCheckoutInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _repository.getDefaultCheckoutInfo();
      if (data != null) {
        _checkoutInfo = CheckoutInfoModel.fromJson(data);
      }
    } catch (e) {
      print('Error loading checkout info: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // cập nhập nếu tạo mới checkout info
  Future<bool> updateCheckoutInfo({
    required String name,
    required String sdt,
    required String address,
    required String city,
    required String district,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      bool success;
      if (_checkoutInfo != null && _checkoutInfo!.id != null) {
        success = await _repository.updateCheckoutInfo(
          addressId: _checkoutInfo!.id!,
          name: name,
          sdt: sdt,
          address: address,
          city: city,
          district: district,
          isDefault: true,
        );
        if (success) {
          // cập nhập local
          _checkoutInfo = checkoutInfo!.copyWith(
            name: name,
            sdt: sdt,
            address: address,
            city: city,
            district: district,
          );
        }
      } else {
        // tạo mới địa chỉ
        final addressId = await _repository.addCheckoutInfo(
          name: name,
          sdt: sdt,
          address: address,
          city: city,
          district: district,
          isDefault: true,
        );
        success = addressId != null;
        if (success) {
          _checkoutInfo = CheckoutInfoModel(
            id: addressId,
            name: name,
            sdt: sdt,
            address: address,
            city: city,
            district: district,
            isDefault: true,
            createdAt: DateTime.now(),
          );
        }
      }
      notifyListeners();
      return success;
    } catch (e) {
      print('lỗi cập nhập: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validate form
  bool isFormValid() {
    return fullName.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        city.isNotEmpty &&
        district.isNotEmpty;
  }

  /// Tạo đơn hàng
  Future<String?> createOrder({
    required String userId,
    required List<CartModel> cartItems,
    required double subtotal,
    required double shippingFee,
  }) async {
    if (!isFormValid()) {
      print('Form is not valid');
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Fetch tên sản phẩm và hình ảnh cho mỗi item trong giỏ hàng
      final orderItems = <OrderItem>[];

      for (var cart in cartItems) {
        final productName = await _repository.getProductName(cart.productId);
        final productImage = await _repository.getProductImage(cart.productId);

        orderItems.add(
          OrderItem(
            productId: cart.productId,
            productName: productName,
            quantity: cart.quantity,
            price: cart.productPrice,
            image: productImage,
            size: cart.size.toString(),
            color: cart.color.toString(),
          ),
        );
      }

      final order = OrderModel(
        userId: userId,
        fullName: fullName,
        phone: phone,
        address: address,
        city: city,
        district: district,
        subTotal: subtotal,
        shippingFee: shippingFee,
        total: subtotal + shippingFee,
        items: orderItems,
        createdAt: DateTime.now(),
      );

      final orderId = await _repository.createOrder(order);

      if (orderId != null) {
        // Xóa giỏ hàng sau khi đặt hàng thành công
        await _repository.clearCart();
      }

      return orderId;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset form
  void reset() {
    _fullName = '';
    _phone = '';
    _address = '';
    _city = '';
    _district = '';
    _checkoutInfo = null;
    notifyListeners();
  }
}
