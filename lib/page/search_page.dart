import 'package:app/common/data.dart';
import 'package:app/models/product_model.dart';
import 'package:app/presentation/home/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel> products = [];
  List<ProductModel> searchs = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    products = shoes.map((element) => ProductModel.fromJson(element)).toList();
    searchs = List.from(products);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tìm kiếm sản phẩm')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            TextFormField(
              onChanged: (value) {
                searchs = products
                    .where(
                      (element) => element.name.toLowerCase().contains(
                        value.toLowerCase(),
                      ),
                    )
                    .toList();
                setState(() {});
              },
              controller: _controller,
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
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 250,
                ),
                itemCount: searchs.length,
                itemBuilder: (context, index) {
                  final item = searchs[index];
                  return ProductItemWidget(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
