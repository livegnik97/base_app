enum UserRoleEnum {
  superadmin,
  admin,
  moderator,
  client
  ;

  static UserRoleEnum fromString(String value) {
    return UserRoleEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRoleEnum.client,
    );
  }
}
