import 'package:app/Admin/presontation/messenger/admin_messenger_page.dart';
import 'package:flutter/material.dart';

class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreensState();
}

class _DashboardScreensState extends State<DashboardScreens> {
  @override
  int _indexSelected = 0;
  final List<Widget> screens = [
    const Center(child: Text('Dashboard')),

    const Center(child: Text('Sản phẩm')),
    const Center(child: Text('Đơn Hàng')),
    const Center(child: Text('Người dùng')),
    const AdminMessengerPage(),
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
            icon: Icon(Icons.insert_emoticon),
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
