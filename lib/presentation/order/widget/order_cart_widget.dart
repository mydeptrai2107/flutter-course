import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/models/order_model.dart';
import 'package:app/presentation/order/provider/order_history_provider.dart';
import 'package:app/repository/order_repository.dart';
import 'package:provider/provider.dart';

class OrderCartWidget extends StatefulWidget {
  final OrderModel order;

  const OrderCartWidget({super.key, required this.order});

  @override
  State<OrderCartWidget> createState() => _OrderCartWidgetState();
}

class _OrderCartWidgetState extends State<OrderCartWidget> {
  final OrderRepository _orderRepository = OrderRepository();
  final Map<String, String> _productNameCache = {};
  bool _isLoadingNames = false;

  @override
  void initState() {
    super.initState();
    _loadProductNames();
  }

  /// Tải tên tất cả sản phẩm trong order
  Future<void> _loadProductNames() async {
    if (_isLoadingNames) return;

    setState(() => _isLoadingNames = true);

    try {
      // Lấy danh sách productId
      final productIds = widget.order.items
          .map((item) => item.productId)
          .toList();

      final names = await _orderRepository.getProductNames(productIds);

      if (mounted) {
        setState(() {
          _productNameCache.addAll(names);
          _isLoadingNames = false;
        });
      }
    } catch (e) {
      print('❌ Error loading product names: $e');
      if (mounted) {
        setState(() => _isLoadingNames = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.receipt_long,
          size: 18,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đơn hàng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '#${widget.order.id ?? "N/A"}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: widget.order.getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.order.getStatusText(),
            style: TextStyle(
              color: widget.order.getStatusColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    Text(
      dateFormat.format(widget.order.createdAt),
      style: TextStyle(color: Colors.grey[600], fontSize: 13),
    ),
  ],
),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.order.items.length} sản phẩm',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Tổng: ',
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(
                        text: currencyFormat.format(widget.order.total),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Thông tin giao hàng
            _buildInfoSection('Thông tin giao hàng', [
              _buildInfoRow(Icons.person, 'Người nhận', widget.order.fullName),
              _buildInfoRow(Icons.phone, 'SĐT', widget.order.phone),
              _buildInfoRow(
                Icons.location_on,
                'Địa chỉ',
                '${widget.order.address}, ${widget.order.district}, ${widget.order.city}',
              ),
            ]),

            const SizedBox(height: 16),

            _buildInfoSection(
              'Sản phẩm (${widget.order.items.length})',
              widget.order.items
                  .map((item) => _buildProductItem(item, currencyFormat))
                  .toList(),
            ),

            const SizedBox(height: 16),

            _buildSummary(currencyFormat),

            if (widget.order.status == 'pending')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCancelDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hủy đơn hàng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderItem item, NumberFormat currencyFormat) {
    final productName = _productNameCache[item.productId] ?? item.productName;
    final isLoading =
        _isLoadingNames && !_productNameCache.containsKey(item.productId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'x${item.quantity}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget tổng kết thanh toán
  Widget _buildSummary(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Tạm tính',
            currencyFormat.format(widget.order.subTotal),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Phí vận chuyển',
            currencyFormat.format(widget.order.shippingFee),
          ),
          const Divider(height: 16),
          _buildSummaryRow(
            'Tổng cộng',
            currencyFormat.format(widget.order.total),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  // Widget từng dòng trong tổng kết
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.red : Colors.black87,
          ),
        ),
      ],
    );
  }

  // Dialog xác nhận hủy đơn
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = context.read<OrderHistoryProvider>();
              final success = await provider.cancelOrder(widget.order.id!);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Đã hủy đơn hàng' : 'Hủy đơn thất bại',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hủy đơn', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
