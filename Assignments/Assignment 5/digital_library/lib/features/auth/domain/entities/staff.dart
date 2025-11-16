class Staff {
  final String staffId;
  final String username;
  final String password;
  final String fullName;
  final String role;

  Staff({
    required this.staffId,
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    String readValue(List<String> keys, String fieldName) {
      for (final key in keys) {
        final value = json[key];
        if (value is String) {
          return value;
        }
        if (value != null) {
          return value.toString();
        }
      }
      throw FormatException('Missing "$fieldName" in staff JSON data.');
    }

    return Staff(
      staffId: readValue(['staffId', 'staff_id'], 'staffId'),
      username: readValue(['username'], 'username'),
      password: readValue(['password'], 'password'),
      fullName: readValue(['fullName', 'full_name'], 'fullName'),
      role: readValue(['role'], 'role'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'username': username,
      'password': password,
      'full_name': fullName,
      'role': role,
    };
  }
}
