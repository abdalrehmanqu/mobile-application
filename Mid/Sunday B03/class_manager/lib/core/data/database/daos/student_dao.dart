import 'package:floor/floor.dart';
import 'package:class_manager/features/dashboard/domain/entities/student.dart';

abstract class StudentDao {
  @Query("SELECT * FROM students")
  Stream<List<Student>> getStudents();

  @Query("SELECT * FROM students WHERE id =:id")
  Future<Student?> getStudentById(int id);

  @Query("SELECT * FROM students WHERE classId =:classId")
  Future<List<Student?>> getStudentsByClass(int classId);

  @insert
  Future<void> addStudent(Student student);

  @update
  Future<void> updateStudent(Student student);

  @delete
  Future<void> deleteStudent(Student student);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertStudent(Student student);

  @insert
  Future<void> insertStudents(List<Student> students);

  @Query("DELETE FROM students")
  Future<void> deleteAllStudents();
}
