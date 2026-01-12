import 'package:app/admin/presentation/messenger/admin_messender_page.dart';
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
    const Center(child: Text('Sản phẩm')),
    const Center(child: Text('Đơn hàng')),
    const Center(child: Text('Người dùng')),
    const AdminMessenderPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_indexSelected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexSelected,
        onTap: (value) {
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
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Sản phẩm'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: 'Người dùng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Tin nhắn'),
        ],
      ),
    );
  }
}
