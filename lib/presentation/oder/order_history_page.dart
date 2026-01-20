import 'package:app/models/order_model.dart';
import 'package:app/presentation/oder/provider/order_provider.dart';
import 'package:app/presentation/oder/models/order_status.dart';
import 'package:app/presentation/oder/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});
  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late PageController _pageController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchUserOrders();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Tab bar filter
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    _buildFilterTab('Tất cả', 0, orderProvider.orders.length),
                    _buildFilterTab(
                      'Chờ xử lý',
                      1,
                      _getOrdersByStatus(orderProvider.orders, 'pending').length,
                    ),
                    _buildFilterTab(
                      'Đang giao',
                      2,
                      _getOrdersByStatus(orderProvider.orders, 'shipping').length,
                    ),
                    _buildFilterTab(
                      'Đã hủy',
                      3,
                      _getOrdersByStatus(orderProvider.orders, 'cancelled').length,
                    ),
                  ],
                ),
              ),
              // Order list
              Expanded(
                child: _buildOrderList(
                  _getFilteredOrders(orderProvider.orders, _selectedTabIndex),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterTab(String label, int index, int count) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(_selectedTabIndex),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Column(
          children: [
            OrderSection(
              date: order.createdAt.toLocal().toString().split(' ')[0],
              orderId: '#${order.id}',
              price: '${order.total.toStringAsFixed(0)} đ',
              status: _mapOrderStatus(order.status),
              items: order.items,
              fullName: order.fullName,
              phone: order.phone,
              address: order.address,
              city: order.city,
              district: order.district,
              subTotal: order.subTotal,
              shippingFee: order.shippingFee,
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  List<OrderModel> _getOrdersByStatus(List<OrderModel> orders, String status) {
    return orders.where((order) => order.status.toLowerCase() == status).toList();
  }

  List<OrderModel> _getFilteredOrders(List<OrderModel> orders, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return orders;
      case 1:
        return _getOrdersByStatus(orders, 'pending');
      case 2:
        return _getOrdersByStatus(orders, 'shipping');
      case 3:
        return _getOrdersByStatus(orders, 'cancelled');
      default:
        return orders;
    }
  }

  String _getEmptyMessage(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Chưa có đơn hàng nào';
      case 1:
        return 'Không có đơn hàng chờ xử lý';
      case 2:
        return 'Không có đơn hàng đang giao';
      case 3:
        return 'Không có đơn hàng đã hủy';
      default:
        return 'Chưa có đơn hàng nào';
    }
  }

  OrderStatus _mapOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.processing;
      case 'shipping':
        return OrderStatus.shipping;
      case 'processing':
        return OrderStatus.processing;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.processing;
    }
  }
}
