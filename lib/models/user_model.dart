class UserModel {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String phone;

  UserModel({
    required this.id,
    required this.avatar,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId){
    return UserModel(id: docId, avatar: json['avatar'] ?? '',
     email: json['email'] ?? '',
      name: json['name'] ?? '',
       phone: json['phone'] ?? '',
       );
  }

  Map<String, dynamic> toJson() => {
    'email' : email,
    'name'  : name,
    'avatar': avatar,
    'phone': phone,

  };

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
  }){
    return UserModel(id: id?? this.id, avatar: avatar?? this.avatar, email: email?? this.email, name: name?? this.name, phone: phone?? this.name);
  }
  
}