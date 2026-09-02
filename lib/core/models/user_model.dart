import 'package:ketabto_test/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String password;

  const UserModel({
    int? id,
    String? name,
    required String phoneNumber,
    required String email,
    required String token,
    required this.password,
  }) : super(
         id: id,
         name: name,
         phoneNumber: phoneNumber,
         email: email,
         token: token,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      password: '',
    );
  }

  Map<String, dynamic> toSignupJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'token': token,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name ?? '',
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      token: entity.token,
      password: '',
    );
  }
}
