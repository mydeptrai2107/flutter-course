import 'package:app/presentation/favorite/favorite_page.dart';
import 'package:app/presentation/home/home_page.dart';
import 'package:flutter/material.dart';

class BottomNavBasic extends StatefulWidget {
  const BottomNavBasic({super.key});

  @override
  State<BottomNavBasic> createState() => _BottomNavBasicState();
}

class _BottomNavBasicState extends State<BottomNavBasic> {
  int _indexSelected = 0;
  final List<Widget> screens = [
    HomePage(),
    FavoritePage(),
    Center(child: Text('Notification')),
    Center(child: Text('Persion')),
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
        selectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Person'),
        ],
      ),
    );
  }
}
