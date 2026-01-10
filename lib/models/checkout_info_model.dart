class CheckoutInfoModel {
  String? id;
  final String name;
  final String sdt;
  final String address;
  final String city;
  final String district;
  final bool isDefault;
  final DateTime? createdAt;

  CheckoutInfoModel({
    this.id,
    required this.name,
    required this.sdt,
    required this.address,
    required this.city,
    required this.district,
    this.isDefault = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sdt': sdt,
      'address': address,
      'city': city,
      'district': district,
      'isDefault': isDefault,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory CheckoutInfoModel.fromJson(Map<String, dynamic> json) {
    return CheckoutInfoModel(
      id: json['id'],
      name: json['name'] ?? '',
      sdt: json['sdt'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  CheckoutInfoModel copyWith({
    String? id,
    String? name,
    String? sdt,
    String? address,
    String? city,
    String? district,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return CheckoutInfoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sdt: sdt ?? this.sdt,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}