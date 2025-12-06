import 'package:app/common/constant.dart';
import 'package:app/storage/local_storage.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String brand = '';

  @override
  void initState() {
    brand = LocalStorage.getString(kBrand);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách yêu thích')),
      body: Text(brand),
    );
  }
}
