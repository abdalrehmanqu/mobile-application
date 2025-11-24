import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/member.dart';

class MemberRepositorySupabase implements MemberRepository {
  final SupabaseClient client;

  MemberRepositorySupabase(this.client);

  @override
  Future<List<Member>> getAllMembers() async {
    final data = await client.from('members').select().order('name');
    return data.map<Member>((row) => Member.fromJson(row)).toList();
  }

  @override
  Future<Member> getMember(String memberId) async {
    final data =
        await client.from('members').select().eq('id', memberId).maybeSingle();
    if (data == null) throw Exception('Member with ID $memberId not found');
    return Member.fromJson(data);
  }

  @override
  Future<void> addMember(Member member) async {
    await client.from('members').insert(member.toJson());
  }

  @override
  Future<void> updateMember(Member member) async {
    await client.from('members').update(member.toJson()).eq('id', member.id);
  }

  @override
  Future<List<Member>> searchMembers(String query) async {
    if (query.isEmpty) return getAllMembers();
    final lower = query.toLowerCase();
    final data = await client
        .from('members')
        .select()
        .or('name.ilike.%$query%,email.ilike.%$query%')
        .order('name');
    return data
        .map<Member>((row) => Member.fromJson(row))
        .where((m) =>
            m.name.toLowerCase().contains(lower) ||
            m.email.toLowerCase().contains(lower))
        .toList();
  }

  // Streams
  @override
  Stream<List<Member>> watchAllMembers() {
    return client
        .from('members')
        .stream(primaryKey: ['id'])
        .order('name')
        .map((rows) => rows.map((row) => Member.fromJson(row)).toList());
  }

  @override
  Stream<Member?> watchMember(String memberId) {
    return client
        .from('members')
        .stream(primaryKey: ['id'])
        .eq('id', memberId)
        .map((rows) => rows.isNotEmpty ? Member.fromJson(rows.first) : null);
  }

  @override
  Stream<List<Member>> watchMembersByType(String memberType) {
    return client
        .from('members')
        .stream(primaryKey: ['id'])
        .eq('member_type', memberType)
        .map((rows) => rows.map((row) => Member.fromJson(row)).toList());
  }

  @override
  Stream<List<Member>> watchSearchResults(String query) {
    if (query.isEmpty) return watchAllMembers();
    final lower = query.toLowerCase();
    return watchAllMembers().map((members) => members
        .where((m) =>
            m.name.toLowerCase().contains(lower) ||
            m.email.toLowerCase().contains(lower))
        .toList());
  }

  @override
  Future<void> deleteMember(String memberId) async {
    await client.from('members').delete().eq('id', memberId);
  }
}
