import 'package:app/models/product_model.dart';
import 'package:app/page/product_detail_page.dart';
import 'package:flutter/material.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({super.key, required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: item),
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
                  Positioned.fill(child: Image.network(item.images)),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Text('BÁN CHẠY', style: TextStyle(color: Colors.blue)),
            Text(item.name),
            Text(
              '${item.price} đ',
              style: TextStyle(color: const Color.fromARGB(255, 253, 142, 24)),
            ),
          ],
        ),
      ),
    );
  }
}
