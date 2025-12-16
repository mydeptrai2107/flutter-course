import 'package:app/common/collection_name.dart';
import 'package:app/models/product_model.dart';
import 'package:app/page/product_detail_page.dart';
import 'package:app/repository/favorite_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({
    super.key,
    required this.item,
  });

  final ProductModel item;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
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
        // final isFavorite =
        //     snapshot.data?.docs
        //         .map((e) => e.id)
        //         .toList()
        //         .contains(widget.item.id) ??
        //     false;
        List<String> ids = [];
        for (final item in snapshot.data?.docs ?? []) {
          ids.add(item.id);
        }
        final isFavorite = ids.contains(widget.item.id);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: widget.item),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      Positioned.fill(child: Image.network(widget.item.images)),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            await FavoriteRepository.addProductToFavorite(
                              widget.item.id,
                            );
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text('BÁN CHẠY', style: TextStyle(color: Colors.blue)),
                Text(widget.item.name),
                Text(
                  '${widget.item.price} đ',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 253, 142, 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
