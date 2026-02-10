import 'package:flutter/widgets.dart';

import 'package:base_app/domain/enums/user_role.enum.dart';

class UserEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int? age;
  final double? weight;
  final UserRoleEnum role;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.age,
    this.weight,
    required this.role,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    ValueGetter<int?>? age,
    ValueGetter<double?>? weight,
    UserRoleEnum? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age != null ? age() : this.age,
      weight: weight != null ? weight() : this.weight,
      role: role ?? this.role,
    );
  }
}
