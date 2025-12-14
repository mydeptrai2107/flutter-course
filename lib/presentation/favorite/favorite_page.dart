import 'package:app/common/constant.dart';
import 'package:app/common/data.dart';
import 'package:app/models/product_model.dart';
import 'package:app/storage/local_storage.dart';
import 'package:app/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ProductModel> allProducts = [];
  List<ProductModel> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    allProducts = shoes.map((e) => ProductModel.fromJson(e)).toList();
    _loadFavorites();
  }

  void _loadFavorites() {
    List<String> favoriteIds = LocalStorage.getListString(kListFavorite);
    favoriteProducts = allProducts
        .where((product) => favoriteIds.contains(product.id.toString()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yêu thích'),
        centerTitle: true,
      ),
      body: favoriteProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có sản phẩm yêu thích',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _loadFavorites();
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 250,
                  ),
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final item = favoriteProducts[index];
                    return ProductItemWidget(
                      item: item,
                      onFavoriteChanged: () {
                        _loadFavorites();
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}