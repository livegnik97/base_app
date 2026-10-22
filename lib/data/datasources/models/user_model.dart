import 'dart:convert';

import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/domain/entities/user_entity.dart';
import 'package:base_app/domain/enums/user_role.enum.dart';

class UserModel {
  final String id;
  final List<UserRoleEnum> roles;
  final bool isValid;
  final bool hasSessionActive;
  final String name;
  final String? lastName;
  final String email;
  final String? phone;
  final String? phoneAlt;
  final String? sessionId;
  final bool hasFreeTrial;

  UserModel({
    required this.id,
    required this.roles,
    required this.isValid,
    required this.hasSessionActive,
    required this.name,
    this.lastName,
    required this.email,
    this.phone,
    this.phoneAlt,
    this.sessionId,
    required this.hasFreeTrial,
  });

  factory UserModel.empty() => UserModel(
    id: '',
    roles: const [],
    isValid: false,
    hasSessionActive: false,
    name: '',
    email: '',
    hasFreeTrial: false,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roles': roles.map((x) => x.name).toList(),
      'isValid': isValid,
      'hasSessionActive': hasSessionActive,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'phoneAlt': phoneAlt,
      'sessionId': sessionId,
      'hasFreeTrial': hasFreeTrial,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      roles: DynamicParse.toList(
        map['roles'],
        (item) => UserRoleEnum.fromString(item.toString()),
      ),
      isValid: DynamicParse.toBool(map['isValid'], false),
      hasSessionActive: DynamicParse.toBool(map['hasSessionActive'], false),
      name: map['name']?.toString() ?? '',
      lastName: map['lastName']?.toString(),
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString(),
      phoneAlt: map['phoneAlt']?.toString(),
      sessionId: map['sessionId']?.toString(),
      hasFreeTrial: DynamicParse.toBool(map['hasFreeTrial'], false),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserEntity toEntity() => UserEntity(
    id: id,
    roles: roles,
    isValid: isValid,
    hasSessionActive: hasSessionActive,
    name: name,
    lastName: lastName,
    email: email,
    phone: phone,
    phoneAlt: phoneAlt,
    sessionId: sessionId,
    hasFreeTrial: hasFreeTrial,
  );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    roles: entity.roles,
    isValid: entity.isValid,
    hasSessionActive: entity.hasSessionActive,
    name: entity.name,
    lastName: entity.lastName,
    email: entity.email,
    phone: entity.phone,
    phoneAlt: entity.phoneAlt,
    sessionId: entity.sessionId,
    hasFreeTrial: entity.hasFreeTrial,
  );
}
