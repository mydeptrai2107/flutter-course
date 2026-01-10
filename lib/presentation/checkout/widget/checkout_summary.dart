import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  final double subTotal;
  final double shippingFee;
  final VoidCallback? onCheckout;
  final String? buttonText;
  final bool showButton;

  const CheckoutSummary({
    super.key,
    required this.subTotal,
    required this.shippingFee,
    this.onCheckout,
    this.buttonText,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final total = subTotal + shippingFee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('Tạm tính', subTotal),
          const SizedBox(height: 12),
          _buildPriceRow('Phí vận chuyển', shippingFee),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildPriceRow('Tổng cộng', total, isTotal: true),
          if (showButton && onCheckout != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  buttonText ?? 'Thanh toán',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(0)}đ',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.lightBlueAccent : Colors.black,
          ),
        ),
      ],
    );
  }
}