class ProductModel {
  String id;
  final int brandId;
  final String name;
  final int price;
  final String images;
  final String description;

  ProductModel({
    required this.id,
    required this.brandId,
    required this.description,
    required this.images,
    required this.name,
    required this.price,
  });

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id']).toString(),
      brandId: json['brands'],
      description: json['descriptions'],
      images: json['image'],
      name: json['name'],
      price: json['price'],
    );
  }
}
