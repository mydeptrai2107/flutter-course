import 'package:app/common/collection_name.dart';
import 'package:app/repository/favorite_reposity.dart';
import 'package:app/presentation/home/widget/product_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final user = FirebaseAuth.instance.currentUser;
  final collectUser = FirebaseFirestore.instance.collection(
    CollectionName.user,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: collectUser
          .doc(user?.uid)
          .collection(CollectionName.favorite)
          .snapshots(),
      builder: (context, snapshot) {
        List<String> ids = [];
        for (final item in snapshot.data?.docs ?? []) {
          ids.add(item.id);
        }

        return FutureBuilder(
          future: FavoriteReposity.getProductsByIds(ids),
          builder: (context, dataFure) {
            return Scaffold(
              appBar: AppBar(title: const Text('Yêu thích'), centerTitle: true),
              body: dataFure.data?.isEmpty ?? false
                  ? const Center(
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
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {},
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 250,
                              ),
                          itemCount: dataFure.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = dataFure.data![index];
                            return ProductItemWidget(item: item);
                          },
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
