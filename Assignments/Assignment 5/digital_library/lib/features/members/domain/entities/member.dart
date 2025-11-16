// Flat entity - no borrowedItems list, that's in transactions table
class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String memberType; // 'student' or 'faculty'
  final DateTime memberSince;
  final String? profileImageUrl;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberType,
    required this.memberSince,
    this.profileImageUrl,
  });

  /// Returns member type
  String getMemberType() => memberType;

  /// Get max borrow limit based on member type
  int getMaxBorrowLimit() => memberType == 'student' ? 5 : 10;

  /// Get borrow period in days based on member type
  int getBorrowPeriod() => memberType == 'student' ? 14 : 30;

  factory Member.fromJson(Map<String, dynamic> json) {
    String readString(List<String> keys, String fieldName,
        {String? defaultValue}) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        return value.toString();
      }
      if (defaultValue != null) return defaultValue;
      throw FormatException('Missing "$fieldName" in member JSON data.');
    }

    String? readOptionalString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        return value.toString();
      }
      return null;
    }

    DateTime readDate(List<String> keys, String fieldName) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        if (value is DateTime) return value;
        if (value is String) {
          final parsed = DateTime.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
      throw FormatException('Missing "$fieldName" in member JSON data.');
    }

    return Member(
      id: readString(['id', 'memberId', 'member_id'], 'id'),
      name: readString(['name', 'fullName', 'full_name'], 'name'),
      email: readString(['email'], 'email'),
      phone: readString(['phone', 'contactNumber', 'contact_number'], 'phone',
          defaultValue: ''),
      memberType: readString(
        ['memberType', 'member_type', 'type'],
        'memberType',
        defaultValue: 'student',
      ),
      memberSince: readDate(
        ['memberSince', 'member_since', 'joinDate', 'join_date', 'created_at'],
        'memberSince',
      ),
      profileImageUrl: readOptionalString(
        ['profileImageUrl', 'profile_image_url'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'member_type': memberType,
        'member_since': memberSince.toIso8601String(),
        'profile_image_url': profileImageUrl,
      };

  Member copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? memberType,
    DateTime? memberSince,
    String? profileImageUrl,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      memberType: memberType ?? this.memberType,
      memberSince: memberSince ?? this.memberSince,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  String toString() => 'Member(id: $id, name: $name, type: $memberType)';
}
