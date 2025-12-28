class BrandModel {
  final int id;
  final String name;
  final String image;

  BrandModel({required this.id, required this.name, required this.image});
  static BrandModel fromJson(Map<String,dynamic> json){
    return BrandModel(id: json['id'], name: json['name'], image: json['image']);
  }
}
