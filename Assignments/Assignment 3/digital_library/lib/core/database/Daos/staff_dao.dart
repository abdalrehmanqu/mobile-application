import 'package:digital_library/features/auth/domain/entities/staff.dart';
import 'package:floor/floor.dart';

@dao 
abstract class StaffDao {
  @Query('SELECT * FROM Staff WHERE username = :username')
  Future<Staff?> findStaffByUsername(String username);
  
  @Query('SELECT * FROM Staff')
  Future<List<Staff>> findAllStaffs();

  @insert
  Future<void> insertStaff(Staff staff);

  @delete
  Future<void> deleteStaff(Staff staff);

  @update
  Future<void> updateStaff(Staff staff);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrUpdateStaff(Staff staff);

  @Query('SELECT * FROM Staff')
  Stream<List<Staff>> watchAllStaffs();

  @insert
  Future<void> insertStaffs(List<Staff> staffs);
}