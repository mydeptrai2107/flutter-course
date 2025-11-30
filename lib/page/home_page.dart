import 'package:app/common/data.dart';
import 'package:app/models/product_model.dart';
import 'package:app/page/search_page.dart';
import 'package:app/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel> products = [];

  @override
  void initState() {
    products = shoes.map((element) => ProductModel.fromJson(element)).toList();

    super.initState();
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromARGB(255, 83, 158, 251),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  width: 25,
                                  height: 25,
                                  child: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/100px-Logo_NIKE.svg.png',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Text(
                                  'Nike',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height: 40,
                          width: 40,
                          child: Image.network(
                            'https://rubee.com.vn/admin/webroot/upload/image//images/tin-tuc/puma-logo-3.jpg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height: 40,
                          width: 40,
                          child: Image.network(
                            'https://jordan1.vn/wp-content/uploads/2023/09/under-armour-logo-700x394_da9de84943ae4c90a693b34480ef20df_1024x1024.png',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height: 40,
                          width: 40,
                          child: Image.network(
                            'https://inkythuatso.com/uploads/thumbnails/800/2021/09/logo-adidas-vector-inkythuatso-01-29-09-08-58.jpg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height: 40,
                          width: 40,
                          child: Image.network(
                            'https://drake.vn/image/catalog/H%C3%ACnh%20content/logo%20gi%C3%A0y%20Converse/logo-gi%C3%A0y-converse-02.jpg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height: 40,
                          width: 40,
                          child: Image.network(
                            'https://rubee.com.vn/admin/webroot/upload/image//images/tin-tuc/puma-logo-3.jpg',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 250,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
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
