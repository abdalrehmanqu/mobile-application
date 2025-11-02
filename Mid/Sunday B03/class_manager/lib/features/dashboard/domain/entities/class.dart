import 'package:floor/floor.dart';

@Entity(tableName: 'classes')
class Class {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String subject;
  final String grade;

  Class({
    this.id,
    required this.name,
    required this.subject,
    required this.grade,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as int?,
      name: json['name'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'grade': grade,
    };
  }

  Class copyWith({
    int? id,
    String? name,
    String? subject,
    String? grade,
  }) {
    return Class(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      grade: grade ?? this.grade,
    );
  }

  @override
  String toString() {
    return 'Class{id: $id, name: $name, subject: $subject, grade: $grade}';
  }
}
