import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/member.dart';

class MemberRepositoryImpl implements MemberRepository {
  final SupabaseClient _client;
  MemberRepositoryImpl(this._client);

  /// Load members from JSON file
  Future<List<Member>> _loadMembers() async {
    try {
      final response = await _client.from('members').select();

      final List<dynamic> data = response as List;
      return data.map((json) => Member.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load members: $e');
    }
  }

  @override
  Future<List<Member>> getAllMembers() async {
    return await _loadMembers();
  }

  @override
  Future<Member> getMember(String memberId) async {
    return await _client
        .from('members')
        .select()
        .eq("id", memberId)
        .single()
        .then((json) => Member.fromJson(json));
  }

  @override
  Future<void> addMember(Member member) async {
    await _client.from('members').insert(member.toJson());
  }

  @override
  Future<void> updateMember(Member member) async {
    await _client
        .from('members')
        .update(member.toJson())
        .eq("id", member.id);
  }

  @override
  Future<List<Member>> searchMembers(String query) async {
    return await _client
        .from('members')
        .select()
        .ilike('name', '%$query%')
        .then((response) {
      final List<dynamic> data = response as List;
      return data.map((json) => Member.fromJson(json)).toList();
    });
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Member>> watchAllMembers() async* {
    yield await getAllMembers();
  }

  @override
  Stream<Member?> watchMember(String memberId) async* {
    try {
      yield await getMember(memberId);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Member>> watchMembersByType(String memberType) async* {
    final members = await getAllMembers();
    yield members.where((m) => m.memberType == memberType).toList();
  }

  @override
  Stream<List<Member>> watchSearchResults(String query) async* {
    yield await searchMembers(query);
  }

  // ==================== Additional CRUD ====================

  @override
  Future<void> deleteMember(String memberId) async {
    await _client.from('members').delete().eq("id", memberId);
  }

}
