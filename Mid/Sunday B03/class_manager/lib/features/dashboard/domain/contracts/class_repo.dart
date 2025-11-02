import '../entities/class.dart';

abstract class ClassRepository {
  Stream<List<Class>> getClasses();
  Future<Class?> getClassById(int id);
  Future<void> addClass(Class classEntity);
  Future<void> updateClass(Class classEntity);
  Future<void> deleteClass(Class classEntity);
}
