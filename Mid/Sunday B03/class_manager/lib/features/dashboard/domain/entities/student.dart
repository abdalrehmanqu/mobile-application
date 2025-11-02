import 'package:floor/floor.dart';
import 'package:class_manager/features/dashboard/domain/entities/class.dart';

@Entity(
  tableName: 'students',
  foreignKeys: [
    ForeignKey(
      childColumns: ['classId'],
      parentColumns: ['id'],
      entity: Class,
    ),
  ],
)
class Student {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String studentId;
  final String email;
  final String profileUrl;
  final int classId;

  Student({
    this.id,
    required this.name,
    required this.studentId,
    required this.email,
    required this.profileUrl,
    required this.classId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int?,
      name: json['name'] as String,
      studentId: json['studentId'] as String,
      email: json['email'] as String,
      profileUrl: json['profileUrl'] as String,
      classId: json['classId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'email': email,
      'profileUrl': profileUrl,
      'classId': classId,
    };
  }

  Student copyWith({
    int? id,
    String? name,
    String? studentId,
    String? email,
    String? profileUrl,
    int? classId,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      classId: classId ?? this.classId,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, studentId: $studentId, email: $email, profileUrl: $profileUrl, classId: $classId}';
  }
}
