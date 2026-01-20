import 'package:app/presentation/checkout/widget/checkout_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/presentation/cart/providers/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/checkout_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final double shippingFee = 15000;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CheckoutProvider>();
      if (provider.checkoutInfo == null) {
        provider.loadDefaultCheckoutInfo();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCheckoutInfo(),
                  const SizedBox(height: 12),

                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          _buildCheckoutSummary(),
        ],
      ),
    );
  }

  Widget _buildCheckoutInfo() {
    return Consumer<CheckoutProvider>(
      builder: (context, value, child) {
        final info = value.checkoutInfo;
        if (value.isLoading && info == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin liên hệ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Email Field
                _buildInfoField(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: info?.name ?? 'Chưa có email',
                  isEmpty: info?.name.isEmpty ?? true,
                  onEdit: () =>
                      _showEditDialog(context, 'name', info?.name ?? ''),
                ),

                const SizedBox(height: 12),

                // Phone Field
                _buildInfoField(
                  icon: Icons.phone,
                  label: 'Số điện thoại',
                  value: info?.sdt ?? 'Chưa có số điện thoại',
                  isEmpty: info?.sdt.isEmpty ?? true,
                  onEdit: () =>
                      _showEditDialog(context, 'sdt', info?.sdt ?? ''),
                ),

                const SizedBox(height: 12),

                // Address Field
                _buildInfoField(
                  icon: Icons.location_on,
                  label: 'Địa chỉ',
                  value:
                      info != null &&
                          info.address.isNotEmpty &&
                          info.district.isNotEmpty &&
                          info.city.isNotEmpty
                      ? '${info.address}, ${info.district}, ${info.city}'
                      : 'Chưa có địa chỉ',
                  isEmpty: info?.address.isEmpty ?? true,
                  maxLines: 2,
                  onEdit: () => _showEditAddressDialog(context, info),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoField({
    required IconData icon,
    required String label,
    required String value,
    required bool isEmpty,
    required VoidCallback onEdit,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon bên trái
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),

          // Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Nút Edit bên phải
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_note,
                color: Colors.blueAccent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog chỉnh sửa tên hoặc SĐT
  void _showEditDialog(
    BuildContext context,
    String field,
    String currentValue,
  ) {
    final controller = TextEditingController(text: currentValue);
    final provider = context.read<CheckoutProvider>();
    final info = provider.checkoutInfo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Chỉnh sửa ${field == 'name' ? 'gamil' : 'số điện thoại'}'),
        content: TextField(
          controller: controller,
          keyboardType: field == 'sdt'
              ? TextInputType.phone
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: field == 'name' ? 'Gmail' : 'Số điện thoại',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập thông tin')),
                );
                return;
              }

              final success = await provider.updateCheckoutInfo(
                name: field == 'name' ? newValue : (info?.name ?? ''),
                sdt: field == 'sdt' ? newValue : (info?.sdt ?? ''),
                address: info?.address ?? '',
                city: info?.city ?? '',
                district: info?.district ?? '',
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Cập nhật thành công' : 'Cập nhật thất bại',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Dialog chỉnh sửa địa chỉ đầy đủ
  void _showEditAddressDialog(BuildContext context, info) {
    final addressController = TextEditingController(text: info?.address ?? '');
    final districtController = TextEditingController(
      text: info?.district ?? '',
    );
    final cityController = TextEditingController(text: info?.city ?? '');
    final provider = context.read<CheckoutProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chỉnh sửa địa chỉ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: districtController,
                decoration: InputDecoration(
                  labelText: 'Quận/Huyện',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'Tỉnh/Thành phố',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (addressController.text.trim().isEmpty ||
                  districtController.text.trim().isEmpty ||
                  cityController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập đầy đủ thông tin'),
                  ),
                );
                return;
              }

              final success = await provider.updateCheckoutInfo(
                name: info?.name ?? '',
                sdt: info?.sdt ?? '',
                address: addressController.text.trim(),
                district: districtController.text.trim(),
                city: cityController.text.trim(),
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Cập nhật thành công' : 'Cập nhật thất bại',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ================= CHECKOUT SUMMARY =================
  Widget _buildCheckoutSummary() {
    return Consumer2<CartProvider, CheckoutProvider>(
      builder: (context, cartProvider, checkoutProvider, child) {
        return CheckoutSummary(
          subTotal: cartProvider.subTotal,
          shippingFee: shippingFee,

          buttonText: checkoutProvider.isLoading ? 'Đang xử lý...' : 'Đặt hàng',
          onCheckout: checkoutProvider.isLoading
              ? null
              : () =>
                    _handlePlaceOrder(context, cartProvider, checkoutProvider),
        );
      },
    );
  }

  /// ================= PLACE ORDER =================
  Future<void> _handlePlaceOrder(
    BuildContext context,
    CartProvider cartProvider,
    CheckoutProvider checkoutProvider,
  ) async {
    final info = checkoutProvider.checkoutInfo;

    if (info == null ||
        info.name.isEmpty ||
        info.sdt.isEmpty ||
        info.address.isEmpty ||
        info.city.isEmpty ||
        info.district.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tinn'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cartProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giỏ hàng trống'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để đặt hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final orderId = await checkoutProvider.createOrder(
      userId: userId,
      cartItems: cartProvider.cartItems,
      subtotal: cartProvider.subTotal,
      shippingFee: shippingFee,
      status: 'pending',
    );

    if (orderId != null) {
      // Xóa giỏ hàng sau khi đặt hàng thành công
      await cartProvider.deleteAllCartItems();

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.redAccent, width: 1),
                  ),
                  child: Icon(
                    Icons.celebration,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  maxLines: 2,
                  'Đặt hàng thành công',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: const Text(
                    'Tiếp tục mua sắm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 16),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt hàng thất bại. Vui lòng thử lại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
