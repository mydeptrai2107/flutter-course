import 'package:app/common/constant.dart';
import 'package:app/models/product_model.dart';
import 'package:app/page/product_detail_page.dart';
import 'package:app/storage/local_storage.dart';
import 'package:flutter/material.dart';

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({
    super.key,
    required this.item,
    this.onFavoriteChanged,
  });

  final ProductModel item;
  final VoidCallback? onFavoriteChanged;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = LocalStorage.getListString(
      kListFavorite,
    ).contains(widget.item.id.toString());
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
                        List<String> favorite = LocalStorage.getListString(
                          kListFavorite,
                        );
                        if (favorite.contains(widget.item.id.toString())) {
                          favorite.remove(widget.item.id.toString());
                        } else {
                          favorite.add(widget.item.id.toString());
                        }

                        await LocalStorage.setListString(
                          kListFavorite,
                          favorite,
                        );
                        setState(() {});

                        // Gọi callback để thông báo thay đổi
                        widget.onFavoriteChanged?.call();
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
              style: TextStyle(color: const Color.fromARGB(255, 253, 142, 24)),
            ),
          ],
        ),
      ),
    );
  }
}
