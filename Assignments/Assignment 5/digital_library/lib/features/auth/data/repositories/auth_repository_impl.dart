import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

class AuthRepositoryImpl implements AuthRepository {
  SupabaseClient _client;
  AuthRepositoryImpl(this._client);

  @override
  Future<List<Staff>> getAllStaff() async {
    try {
      return await _client
          .from('staff')
          .select()
          .then(
            (data) =>
                (data as List).map((json) => Staff.fromJson(json)).toList(),
          );
    } catch (e) {
      throw Exception('Failed to load staff: $e');
    }
  }

  @override
  Future<Staff?> getStaffByUsername(String username) async {
    return await _client
        .from('staff')
        .select()
        .eq("username", username)
        .single()
        .then((json) => Staff.fromJson(json));
  }

  @override
  Future<Staff?> authenticate(String username, String password) async {
    return await _client
        .from('staff')
        .select()
        .eq("username", username)
        .eq("password", password)
        .single()
        .then((json) => Staff.fromJson(json));
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Staff>> watchAllStaff() async* {
    yield await getAllStaff();
  }

  @override
  Stream<Staff?> watchStaffByUsername(String username) async* {
    yield await getStaffByUsername(username);
  }

  // ==================== CRUD operations ====================

  @override
  Future<void> addStaff(Staff staff) async {
    await _client.from('staff').insert(staff.toJson());
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    await _client
        .from('staff')
        .update(staff.toJson())
        .eq('staff_id', staff.staffId);
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    await _client
        .from('staff')
        .delete()
        .eq('staff_id', staffId);
  }
}
