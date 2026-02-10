import 'dart:convert';

import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/domain/entities/user_entity.dart';
import 'package:base_app/domain/enums/user_role.enum.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int? age;
  final double? weight;
  final UserRoleEnum role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.age,
    this.weight,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'weight': weight,
      'role': role.toString(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: DynamicParse.toInt(map['id'], 0),
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      age: DynamicParse.toIntOrNull(map['age']),
      weight: DynamicParse.toDoubleOrNull(map['weight']),
      role: DynamicParse.toObject(
        map['role'],
        (item) => UserRoleEnum.fromString(item),
        UserRoleEnum.client,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    phone: phone,
    age: age,
    weight: weight,
    role: role,
  );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    name: entity.name,
    email: entity.email,
    phone: entity.phone,
    age: entity.age,
    weight: entity.weight,
    role: entity.role,
  );
}
