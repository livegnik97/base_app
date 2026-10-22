import 'dart:convert';

import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/data/datasources/models/user_model.dart';
import 'package:base_app/domain/entities/login_entity.dart';

class LoginModel {
  final String accessToken;
  final UserModel user;

  LoginModel({required this.accessToken, required this.user});

  Map<String, dynamic> toMap() {
    return {'accessToken': accessToken, 'user': user.toMap()};
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      accessToken: map['accessToken']?.toString() ?? '',
      user: DynamicParse.toObjectOrNull(
        map['user'],
        (item) => UserModel.fromMap(item),
      )!,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source));

  LoginEntity toEntity() =>
      LoginEntity(accessToken: accessToken, user: user.toEntity());
}
