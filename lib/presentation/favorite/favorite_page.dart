import 'package:app/common/collection_name.dart';
import 'package:app/repository/favorite_repository.dart';
import 'package:app/presentation/home/widgets/product_item_widget.dart';
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
    CollectionName.users,
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
          future: FavoriteRepository.getProductsByIds(ids),
          builder: (context, dataFuture) {
            return Scaffold(
              appBar: AppBar(title: Text('Yêu thích'), centerTitle: true),
              body: dataFuture.data?.isEmpty ?? false
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
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 250,
                      ),
                      itemCount: dataFuture.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = dataFuture.data![index];
                        return ProductItemWidget(item: item);
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
