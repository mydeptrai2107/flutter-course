import 'package:app/common/collection_name.dart';
import 'package:app/models/product_model.dart';
import 'package:app/page/search_page.dart';
import 'package:app/widgets/list_brands_widget.dart';
import 'package:app/widgets/product_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(CollectionName.product)
        .get();
    // products = snapshot.docs
    //     .map((e) => ProductModel.fromJson(e.data()))
    //     .toList();
    for (final item in snapshot.docs) {
      final product = ProductModel.fromJson(item.data());
      products.add(product);
    }
    productByBrand = List.from(products);
    setState(() {});
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Positioned.fill(child: Icon(Icons.grid_view_rounded, size: 20)),
              ],
            ),
            Text(
              style: TextStyle(fontSize: 15, color: Colors.black),
              'Khám phá',
            ),
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                Positioned.fill(
                  child: Icon(Icons.shopping_bag_outlined, size: 20),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 254, 69, 69),
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
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm giày',
                    prefixIcon: Icon(Icons.search_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 1,
                        color: const Color.fromARGB(255, 83, 158, 251),
                      ),
                    ),
                  ),
                ),
              ),
              ListBrandsWidget(
                voidCallback: (id) {
                  brandSelected = id;
                  productByBrand = products
                      .where((element) => element.brandId == brandSelected)
                      .toList();
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Giày phổ biến'),
                  Text(
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 83, 158, 251),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 500,
                  child: productByBrand.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.abc),
                              Text('Không có sản phẩm nào!'),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
