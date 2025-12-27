import 'package:app/models/product_model.dart';
import 'package:app/presentation/home/widget/product_item_widget.dart';
import 'package:flutter/material.dart';

class ProductListBrandPage extends StatelessWidget {
  const ProductListBrandPage({
    super.key,
    required this.products,
    required this.brandName,
  });
  final List<ProductModel> products;
  final String brandName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(brandName), centerTitle: true),
      body: products.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_stroller_sharp, size: 50),
                  SizedBox(height: 16),
                  Text('Không có sản phẩm nào'),
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 250,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return ProductItemWidget(item:  item);
              },
            ),
    );
  }
}
