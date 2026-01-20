import 'package:app/models/order_model.dart';
import 'package:app/presentation/order/provider/order_history_provider.dart';
import 'package:app/presentation/order/widget/order_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Định nghĩa trạng thái đơn hàng
class OrderStatus {
  static const String pending = 'pending';
  static const String processing = 'processing';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

class OrderHistoryPage extends StatefulWidget {
  final int initialTabIndex;
  const OrderHistoryPage({super.key, this.initialTabIndex = 0});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Chờ xác nhận', 'status': OrderStatus.pending},
    {'label': 'Đang vận chuyển', 'status': OrderStatus.processing},
    {'label': 'Hoàn thành', 'status': OrderStatus.completed},
    {'label': 'Đã hủy', 'status': OrderStatus.cancelled},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // Lắng nghe để cập nhật UI khi chuyển tab (quan trọng cho phần custom TabBar)
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryProvider>().fetchOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Lịch sử mua hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Consumer<OrderHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(provider.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchOrders(),
                  child: const Text('Thử lại'),
                ),
              ],
            );
          }
          return Center(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.lightBlueAccent,
                    labelColor: Colors.lightBlueAccent,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: _tabs.map((tab) {
                      final count = provider
                          .getOrdersByStatus(tab['status'] as String)
                          .length;
                      return Tab(
                        text: count > 0
                            ? '${tab['label']} ($count)'
                            : tab['label'] as String,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs.map((tab) {
                      final filteredOrders = provider.getOrdersByStatus(
                        tab['status'] as String,
                      );
                      return _buildOrderList(filteredOrders);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Không có đơn hàng nào',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return OrderCartWidget(order: orders[index]);
        },
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
      ),
      onRefresh: () => context.read<OrderHistoryProvider>().fetchOrders(),
    );
  }
}
