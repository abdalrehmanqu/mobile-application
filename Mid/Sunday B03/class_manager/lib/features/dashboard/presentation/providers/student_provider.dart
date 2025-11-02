import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/features/dashboard/domain/contracts/student_repo.dart';
import 'package:class_manager/features/dashboard/domain/entities/student.dart';
import 'package:class_manager/features/dashboard/presentation/providers/repo_providers.dart';

class StudentData {
  List<Student> students;
  StudentData({required this.students});
}

class StudentNotifier extends AsyncNotifier<StudentData> {
  late final StudentRepository studentRepo;

  @override
  Future<StudentData> build() async {
    studentRepo = await ref.read(studentRepoProvider.future);
    studentRepo.getStudents().listen((students) {
      state = AsyncData(StudentData(students: students));
    });
    return StudentData(students: []);
  }

  Future<List<Student?>> getStudentsByClass(int classId) async {
    return await studentRepo.getStudentsByClass(classId);
  }

  Future<void> addStudent(Student student) async {
    return studentRepo.addStudent(student);
  }

  Future<void> updateStudent(Student student) async {
    studentRepo.updateStudent(student);
  }

  Future<void> deleteStudent(Student student) async {
    studentRepo.deleteStudent(student);
  }

  Future<Student?> getStudentById(int id) async {
    return studentRepo.getStudentById(id);
  }
}

final studentNotifierProvider =
    AsyncNotifierProvider<StudentNotifier, StudentData>(
      () => StudentNotifier(),
    );
