import '../entities/student.dart';

abstract class StudentRepository {
  Stream<List<Student>> getStudents();
  Future<Student?> getStudentById(int id);
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(Student student);
  Future<List<Student?>> getStudentsByClass(int classId);
}
