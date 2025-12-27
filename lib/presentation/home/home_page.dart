import 'package:app/common/collection_name.dart';
import 'package:app/common/data.dart';
import 'package:app/models/product_model.dart';
import 'package:app/page/product_list_brand_page.dart';
import 'package:app/page/search_page.dart';
import 'package:app/repository/product_repository.dart';
import 'package:app/widgets/list_brand_widget.dart';
import 'package:app/presentation/home/widget/product_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel> products = [];
  List<ProductModel> productByBrand = [];
  int brandSelected = 1;
  String brandName = 'Nike';
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    products = await ProductRepository.fetchProduct();
    productByBrand = List.from(products);
    setState(() {});
  }

  String getBrandName(int brandId) {
    switch (brandId) {
      case 1:
        return 'Nike';
      case 2:
        return 'Puma';
      case 3:
        return 'Jordan';
      case 4:
        return 'Adidas';
      case 5:
        return 'Converse';
      default:
        return 'Tất cả';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const Positioned.fill(child: Icon(Icons.grid_view_rounded, size: 20)),
              ],
            ),
            const Text(
              style: TextStyle(fontSize: 15, color: Colors.black),
              'Khám phá',
            ),
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const Positioned.fill(
                  child: Icon(Icons.shopping_bag_outlined, size: 20),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 254, 69, 69),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchPage()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm giày',
                    prefixIcon: const Icon(Icons.search_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 83, 158, 251),
                      ),
                    ),
                  ),
                ),
              ),
              ListBrandWidget(
                voidCallback: (id) {
                  brandSelected = id;
                  brandName = getBrandName(id);
                  productByBrand = products
                      .where((element) => element.brandId == brandSelected)
                      .toList();
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Giày phổ biến'),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListBrandPage(
                            products: productByBrand,
                            brandName: brandName,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 83, 158, 251),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 500,
                  child: productByBrand.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.no_stroller_sharp),
                              Text('Không có sản phẩm nào'),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 250,
                              ),
                          itemCount: productByBrand.length,
                          itemBuilder: (context, index) {
                            final item = productByBrand[index];
                            return ProductItemWidget(item: item);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
