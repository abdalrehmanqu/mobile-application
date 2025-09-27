class Author {
  String id;
  String name;
  String? profileImageUrl;
  String? biography;
  int? birthYear;

  Author({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.biography,
    this.birthYear,
  });

  String getDisplayName() {
    return name;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'biography': biography,
      'birthYear': birthYear,
    };
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
      biography: json['biography'],
      birthYear: json['birthYear'],
    );
  }

  int calculateAge() {
    if (birthYear != null) {
      return DateTime.now().year - birthYear!;
    }
    throw Exception('Birth year is not available');
  }


}
