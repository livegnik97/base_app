import 'package:base_app/domain/enums/user_role.enum.dart';

class UserEntity {
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

  UserEntity({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  //* Roles session
  bool get isSuperAdmin => roles.contains(UserRoleEnum.superadmin);
  bool get isAdmin => roles.contains(UserRoleEnum.admin) || isSuperAdmin;
  bool get isModerator =>
      roles.contains(UserRoleEnum.moderator) || isAdmin || isSuperAdmin;
  bool get isClient => true;

  String fullName() {
    final lastName = this.lastName ?? '';
    return lastName.isEmpty ? name : '$name $lastName';
  }
}
