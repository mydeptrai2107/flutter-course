import 'package:flutter/material.dart';
import 'package:app/models/order_model.dart';
import '../models/order_status.dart';
import '../utils/order_status_helper.dart';
import 'order_item_row_widget.dart';

class OrderSection extends StatelessWidget {
  final String date;
  final String orderId;
  final String price;
  final OrderStatus status;
  final List<OrderItem> items;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String district;
  final double subTotal;
  final double shippingFee;

  const OrderSection({
    super.key,
    required this.date,
    required this.orderId,
    required this.price,
    required this.status,
    required this.items,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.district,
    required this.subTotal,
    required this.shippingFee,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        OrderCard(
          orderId: orderId,
          price: price,
          status: status,
          items: items,
          fullName: fullName,
          phone: phone,
          address: address,
          city: city,
          district: district,
          subTotal: subTotal,
          shippingFee: shippingFee,
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String price;
  final OrderStatus status;
  final List<OrderItem> items;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String district;
  final double subTotal;
  final double shippingFee;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.price,
    required this.status,
    required this.items,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.district,
    required this.subTotal,
    required this.shippingFee,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = getOrderStatusInfo(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(14),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn hàng: $orderId',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusData.bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(statusData.icon, size: 14, color: statusData.color),
                  const SizedBox(width: 4),
                  Text(
                    statusData.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusData.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin người nhận
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin người nhận',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InfoRow(label: 'Tên:', value: fullName),
                      const SizedBox(height: 6),
                      InfoRow(label: 'Số điện thoại:', value: phone),
                      const SizedBox(height: 6),
                      InfoRow(
                        label: 'Địa chỉ:',
                        value: '$address, $district, $city',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Chi tiết sản phẩm
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sản phẩm',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductItem(item: item),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Chi tiết chi phí
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chi tiết chi phí',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CostRow(
                        label: 'Tiền hàng:',
                        value: '${subTotal.toStringAsFixed(0)} đ',
                      ),
                      const SizedBox(height: 6),
                      CostRow(
                        label: 'Tiền giao hàng:',
                        value: '${shippingFee.toStringAsFixed(0)} đ',
                      ),
                      const Divider(height: 12),
                      CostRow(label: 'Tổng cộng:', value: price, isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
