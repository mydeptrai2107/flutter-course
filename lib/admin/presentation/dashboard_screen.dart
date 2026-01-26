import 'package:app/admin/presentation/messager/admin_mesager_page.dart';
import 'package:app/admin/presentation/product/admin_product_page.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _indexSelected = 0;
  final List<Widget> screens = [
    const Center(child: Text('Dashboard')),
    const AdminProductPage(),
    const Center(child: Text('Đơn hàng')),
    const Center(child: Text('Người dùng')),
    const AdminMesagerPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_indexSelected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexSelected,
        onTap: (value) {
          print(value);
          _indexSelected = value;
          setState(() {});
        },
        selectedIconTheme: const IconThemeData(color: Colors.blue),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_iridescent_outlined),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Người dùng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Tin nhắn'),
        ],
      ),
    );
  }
}
