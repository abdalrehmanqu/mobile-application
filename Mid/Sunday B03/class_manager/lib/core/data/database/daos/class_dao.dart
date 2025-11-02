import 'package:floor/floor.dart';
import 'package:class_manager/features/dashboard/domain/entities/class.dart';

abstract class ClassDao {
  @Query("SELECT * FROM classes")
  Stream<List<Class>> getClasses();

  @Query("SELECT * FROM classes")
  Future<List<Class>> getAllClasses();

  @Query("SELECT * FROM classes WHERE id =:id")
  Future<Class?> getClassById(int id);

  @insert
  Future<void> addClass(Class classEntity);

  @update
  Future<void> updateClass(Class classEntity);

  @delete
  Future<void> deleteClass(Class classEntity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertClass(Class classEntity);

  @insert
  Future<void> insertClasses(List<Class> classes);

  @Query("DELETE FROM classes")
  Future<void> deleteAllClasses();
}
