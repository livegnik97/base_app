enum UserRoleEnum {
  admin,
  moderator,
  client;

  factory UserRoleEnum.fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'admin':
        return admin;
      case 'moderator':
        return moderator;
      case 'client':
        return client;
      default:
        return client;
    }
  }

  @override
  String toString() {
    return name;
  }

  String toFormalString() {
    switch (this) {
      case admin:
        return 'Administrador';
      case moderator:
        return 'Moderador';
      case client:
        return 'Cliente';
    }
  }
}
