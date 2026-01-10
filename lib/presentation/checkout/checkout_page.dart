import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/presentation/checkout/provider/checkout_provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Thanh toán', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactInfo(context),
            const SizedBox(height: 16),
            _buildPaymentMethod(context),
            const SizedBox(height: 16),
            _buildOrderSummary(),
            const SizedBox(height: 20),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin liên hệ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _infoRow(
            icon: Icons.email,
            title: 'Email',
            value: checkoutProvider.name ?? 'Chưa cập nhật',
            onEdit: () async {
              final newValue = await _showEditDialog(
                context,
                title: 'Chỉnh sửa Email',
                initialValue: checkoutProvider.name ?? '',
              );
              if (newValue != null) {
                checkoutProvider.saveContactInfo(
                  newValue,
                  checkoutProvider.phone ?? '',
                  checkoutProvider.address ?? '',
                );
              }
            },
          ),
          _infoRow(
            icon: Icons.phone,
            title: 'Số điện thoại',
            value: checkoutProvider.phone ?? 'Chưa cập nhật',
            onEdit: () async {
              final newValue = await _showEditDialog(
                context,
                title: 'Chỉnh sửa Số điện thoại',
                initialValue: checkoutProvider.phone ?? '',
              );
              if (newValue != null) {
                checkoutProvider.saveContactInfo(
                  checkoutProvider.name ?? '',
                  newValue,
                  checkoutProvider.address ?? '',
                );
              }
            },
          ),
          _infoRow(
            icon: Icons.location_on,
            title: 'Địa chỉ',
            value: checkoutProvider.address ?? 'Chưa cập nhật',
            onEdit: () async {
              final newValue = await _showEditDialog(
                context,
                title: 'Chỉnh sửa Địa chỉ',
                initialValue: checkoutProvider.address ?? '',
              );
              if (newValue != null) {
                checkoutProvider.saveContactInfo(
                  checkoutProvider.name ?? '',
                  checkoutProvider.phone ?? '',
                  newValue,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          RadioListTile(
            value: 1,
            groupValue: checkoutProvider.paymentMethod,
            onChanged: (value) =>
                checkoutProvider.updatePaymentMethod(value as int),
            activeColor: Colors.blue,
            title: const Text('Thanh toán khi nhận hàng'),
            secondary: const Icon(Icons.local_shipping),
          ),
          RadioListTile(
            value: 2,
            groupValue: checkoutProvider.paymentMethod,
            onChanged: (value) =>
                checkoutProvider.updatePaymentMethod(value as int),
            activeColor: Colors.blue,
            title: const Text('Thanh toán qua thẻ'),
            secondary: const Icon(Icons.credit_card),
          ),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(
    BuildContext context, {
    required String title,
    required String initialValue,
  }) {
    String tempValue = initialValue;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) => tempValue = value,
            controller: TextEditingController(text: initialValue),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempValue),
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _priceRow('Thành tiền', '15.300.000 đ'),
          _priceRow('Vận chuyển', '15.000 đ', valueColor: Colors.green),
          const Divider(),
          _priceRow(
            'Tổng cộng',
            '15.415.000 đ',
            isBold: true,
            valueColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Thanh toán',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isBold = false,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
