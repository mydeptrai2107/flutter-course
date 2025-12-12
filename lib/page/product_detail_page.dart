import 'package:app/models/product_model.dart';
import 'package:app/services/dialog_services.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductModel item;

  List<int> sizes = [38, 39, 40, 41, 42, 43];
  int sizeSelectIndex = 0;

  List<Color> colors = [Colors.blue, Colors.red, Colors.yellow];
  int colorSelectIndex = 0;

  @override
  void initState() {
    item = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [Flexible(child: Image.network(item.images))],
                ),
              ),
              Text(
                'BÁN CHẠY',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
              Text(item.name, style: TextStyle(fontSize: 20)),
              Text(
                '${item.price} VND',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(item.description),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Màu Sắc', style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  spacing: 20,
                  children: [
                    for (int i = 0; i < colors.length; i++)
                      _buildButtonColor(i, i == colorSelectIndex),
                  ],
                ),
              ),
              Text('Kích thước', style: TextStyle(fontSize: 20)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: [
                    for (int i = 0; i < sizes.length; i++)
                      _buildButtonSize(i, i == sizeSelectIndex),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(244, 243, 241, 241),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text('Giá', style: TextStyle(fontSize: 20)),
                  Text('${item.price} VND', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                DialogServices.notificeDialog(
                  context: context,
                  isSuccess: false,
                  content: 'Thêm vào giỏ hàng thành công',
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(
                'Thêm vào giỏi hàng',
                style: TextStyle(
                  color: const Color.fromARGB(255, 245, 242, 242),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSize(int index, bool isChoose) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        sizeSelectIndex = index;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChoose ? Colors.blue : Colors.white,
        ),
        child: Text(
          sizes[index].toString(),
          style: TextStyle(color: isChoose ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildButtonColor(int index, bool isChoose) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        setState(() {
          colorSelectIndex = index;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: isChoose ? Colors.black : Colors.transparent,
          ),
          color: colors[index],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
