import 'package:class_manager/core/data/database/daos/student_dao.dart';
import 'package:class_manager/features/dashboard/domain/contracts/student_repo.dart';
import 'package:class_manager/features/dashboard/domain/entities/student.dart';

class StudentRepoLocalDB implements StudentRepository {
  final StudentDao _studentDao;

  StudentRepoLocalDB(this._studentDao);

  @override
  Stream<List<Student>> getStudents() => _studentDao.getStudents();

  @override
  Future<void> addStudent(Student student) => _studentDao.addStudent(student);

  @override
  Future<void> deleteStudent(Student student) =>
      _studentDao.deleteStudent(student);

  @override
  Future<Student?> getStudentById(int id) => _studentDao.getStudentById(id);

  @override
  Future<void> updateStudent(Student student) =>
      _studentDao.updateStudent(student);

  @override
  Future<List<Student?>> getStudentsByClass(int classId) =>
      _studentDao.getStudentsByClass(classId);
}
