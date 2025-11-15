import 'package:digital_library/core/database/Daos/staff_dao.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StaffDao _staffDao;
  AuthRepositoryImpl(this._staffDao);

  @override
  Future<List<Staff>> getAllStaff() => _staffDao.findAllStaffs();

  @override
  Future<Staff?> getStaffByUsername(String username) => _staffDao.findStaffByUsername(username);

  @override
  Future<Staff?> authenticate(String username, String password) => _staffDao.findStaffByUsername(username).then((staff) {
        if (staff != null && staff.password == password) {
          return staff;
        }
        return null;
      });

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Staff>> watchAllStaff() => _staffDao.watchAllStaffs();
  @override
  Stream<Staff?> watchStaffByUsername(String username) => Stream.fromFuture(getStaffByUsername(username));

  // ==================== CRUD operations ====================

  @override
  Future<void> addStaff(Staff staff) => _staffDao.insertStaff(staff);

  @override
  Future<void> updateStaff(Staff staff) => _staffDao.updateStaff(staff);

  @override
  Future<void> deleteStaff(String staffId) => _staffDao.findAllStaffs().then((staffs) {
        final staff = staffs.firstWhere((s) => s.staffId == staffId, orElse: () => throw Exception('Staff not found'));
        return _staffDao.deleteStaff(staff);
      });
}
