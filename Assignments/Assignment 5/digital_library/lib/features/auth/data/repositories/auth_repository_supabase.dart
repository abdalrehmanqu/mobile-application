import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

class AuthRepositorySupabase implements AuthRepository {
  final SupabaseClient client;

  AuthRepositorySupabase(this.client);

  Staff _staffFromUser(User user) {
    final meta = user.userMetadata ?? {};
    return Staff(
      staffId: meta['staff_id']?.toString() ?? user.id,
      username: user.email ?? '',
      password: '', // not stored
      fullName: meta['full_name']?.toString() ?? (user.email ?? 'Staff'),
      role: meta['role']?.toString() ?? 'staff',
    );
  }

  @override
  Future<List<Staff>> getAllStaff() async {
    try {
      final data = await client.from('staff').select();
      return data
          .map<Staff>((row) => Staff.fromJson({
                ...row,
                'password': '',
              }))
          .toList();
    } on PostgrestException {
      // If the staff table is missing, fail gracefully with an empty list
      return [];
    }
  }

  @override
  Future<Staff?> getStaffByUsername(String username) async {
    try {
      final data = await client
          .from('staff')
          .select()
          .eq('username', username)
          .maybeSingle();
      if (data == null) return null;
      return Staff.fromJson({...data, 'password': ''});
    } on PostgrestException {
      return null;
    }
  }

  @override
  Future<Staff?> authenticate(String username, String password) async {
    final response = await client.auth.signInWithPassword(
      email: username,
      password: password,
    );
    final user = response.user;
    if (user == null) return null;

    Map<String, dynamic>? profile;
    try {
      profile = await client
          .from('staff')
          .select()
          .or('username.eq.$username,user_id.eq.${user.id}')
          .maybeSingle();
    } on PostgrestException {
      profile = null;
    }

    if (profile != null) {
      return Staff.fromJson({...profile, 'password': ''});
    }

    // Fallback to auth metadata
    return _staffFromUser(user);
  }

  // Streams
  @override
  Stream<List<Staff>> watchAllStaff() {
    try {
      return client
          .from('staff')
          .stream(primaryKey: ['staff_id'])
          .map((rows) => rows
              .map((row) => Staff.fromJson({...row, 'password': ''}))
              .toList());
    } on PostgrestException {
      return const Stream.empty();
    }
  }

  @override
  Stream<Staff?> watchStaffByUsername(String username) {
    try {
      return client
          .from('staff')
          .stream(primaryKey: ['staff_id'])
          .eq('username', username)
          .map((rows) =>
              rows.isNotEmpty ? Staff.fromJson({...rows.first, 'password': ''}) : null);
    } on PostgrestException {
      return const Stream.empty();
    }
  }

  // CRUD
  @override
  Future<void> addStaff(Staff staff) async {
    try {
      await client.from('staff').insert(staff.toJson());
    } on PostgrestException {
      // Ignore if staff table is missing; metadata still exists in auth
    }
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    try {
      await client.from('staff').update(staff.toJson()).eq('staff_id', staff.staffId);
    } on PostgrestException {
      // Ignore if staff table is missing
    }
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    try {
      await client.from('staff').delete().eq('staff_id', staffId);
    } on PostgrestException {
      // Ignore if staff table is missing
    }
  }
}
