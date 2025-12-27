import 'package:app/common/constant.dart';
import 'package:app/common/data.dart';
import 'package:app/models/brand_model.dart';
import 'package:app/repository/brand_repository.dart';
import 'package:app/storage/local_storage.dart';
import 'package:flutter/material.dart';

class ListBrandWidget extends StatefulWidget {
  const ListBrandWidget({super.key, required this.voidCallback});

  final void Function(int id) voidCallback;
  @override
  State<ListBrandWidget> createState() => _ListBrandWidgetState();
}

class _ListBrandWidgetState extends State<ListBrandWidget> {
  List<BrandModel> brands = [];
bool isLoading = true;
  int brandSelected = 1;

  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    _loadBrands();
  }
Future<void> _loadBrands() async{
  final data = await BrandRepository.getBrands();
  setState(() {
    brands = data;
    isLoading = false;
  });

}
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: const Center(child: CircularProgressIndicator(),),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [for (final brand in brands) _buildBrandItem(brand)],
        ),
      ),
    );
  }

  Widget _buildBrandItem(BrandModel brand) {
    return InkWell(
      onTap: () {
        LocalStorage.setString(kBrand, brand.name);
        widget.voidCallback.call(brand.id);
        brandSelected = brand.id;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: brand.id == brandSelected ? Colors.blue : Colors.transparent,
        ),
        child: Row(
          spacing: 5,
          children: [
            ClipOval(
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                height: 40,
                width: 40,
                child: Image.network(brand.image),
              ),
            ),
            if (brand.id == brandSelected)
              Text(brand.name, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
