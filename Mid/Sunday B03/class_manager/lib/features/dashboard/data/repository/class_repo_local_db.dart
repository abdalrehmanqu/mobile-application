import 'package:class_manager/core/data/database/daos/class_dao.dart';
import 'package:class_manager/features/dashboard/domain/contracts/class_repo.dart';
import 'package:class_manager/features/dashboard/domain/entities/class.dart';

class ClassRepoLocalDB implements ClassRepository {
  final ClassDao _classDao;

  ClassRepoLocalDB(this._classDao);

  @override
  Stream<List<Class>> getClasses() => _classDao.getClasses();

  @override
  Future<Class?> getClassById(int id) => _classDao.getClassById(id);

  @override
  Future<void> addClass(Class classEntity) => _classDao.addClass(classEntity);

  @override
  Future<void> updateClass(Class classEntity) =>
      _classDao.updateClass(classEntity);

  @override
  Future<void> deleteClass(Class classEntity) =>
      _classDao.deleteClass(classEntity);
}
