class ProductModel {
  final int brandId;
  final String name;
  final int price;
  final String images;
  final String description;

  const ProductModel({
    required this.brandId,
    required this.description,
    required this.images,
    required this.name,
    required this.price,
  });

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      brandId: json['brands'],
      description: json['descriptions'],
      images: json['image'],
      name: json['name'],
      price: json['price'],
    );
  }
}
