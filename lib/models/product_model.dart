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
      id: json['id'].toString(),
      brandId: json['brands'],
      description: json['descriptions'],
      images: json['image'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brands': brandId,
      'descriptions': description,
      'image': images,
      'name': name,
      'price': price,
    };
  }

  ProductModel copyWith({
    String? id,
    int? brandId,
    String? name,
    int? price,
    String? images,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      price: price ?? this.price,
      images: images ?? this.images,
      description: description ?? this.description,
    );
  }
}
