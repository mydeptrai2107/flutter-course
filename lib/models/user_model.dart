class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? avatar;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });

  
  static UserModel fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      name: json['name'] ?? 'Chưa cập nhật',
      email: json['email'] ?? '',
      phone: json['phone'] ?? 'Chưa cập nhật',
      avatar: json['avatar'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'avatar': avatar};
  }
}
