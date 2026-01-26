import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/product_model.dart';
import 'package:app/admin/presentation/product/provider/admin_product_provider.dart';

class ProductForm extends StatefulWidget {
  final ProductModel? product;

  const ProductForm({Key? key, this.product}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _price;
  late String _imageUrl;
  late String _description;
  late int _brandId;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _price = widget.product?.price ?? 0;
    _imageUrl = widget.product?.images ?? '';
    _description = widget.product?.description ?? '';
    _brandId = widget.product?.brandId ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<AdminProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Giá sản phẩm'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = int.parse(value!),
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: const InputDecoration(labelText: 'URL hình ảnh'),
                onSaved: (value) => _imageUrl = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _brandId.toString(),
                decoration: const InputDecoration(labelText: 'ID thương hiệu'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _brandId = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final product = ProductModel(
                      id: widget.product?.id ?? '',
                      name: _name,
                      price: _price,
                      images: _imageUrl,
                      description: _description,
                      brandId: _brandId,
                    );
                    if (widget.product == null) {
                      productProvider.addProduct(product);
                    } else {
                      productProvider.updateProduct(product);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.product == null ? 'Thêm' : 'Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
