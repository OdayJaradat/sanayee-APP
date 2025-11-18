
enum UserRole {
  client('client'),
  professional('professional'); 

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'client':
        return UserRole.client;
      case 'pro':
      case 'professional':
        return UserRole.professional;
      default:
        return UserRole.client;
    }
  }

  bool get isClient => this == UserRole.client;
  bool get isProfessional => this == UserRole.professional;
}
