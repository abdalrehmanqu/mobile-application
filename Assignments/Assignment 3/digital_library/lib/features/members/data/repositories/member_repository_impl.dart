import 'package:digital_library/core/database/Daos/member_dao.dart';
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/member.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberDao _memberDao;
  MemberRepositoryImpl(this._memberDao);

  /// Load members from JSON file
  Future<List<Member>> _loadMembers() => _memberDao.findAllMembers();

  @override
  Future<List<Member>> getAllMembers() => _loadMembers();

  @override
  Future<Member> getMember(String memberId) =>
      _memberDao.findMemberById(memberId).then((member) {
        if (member == null) {
          throw Exception('Member with ID $memberId not found');
        }
        return member;
      });

  @override
  Future<void> addMember(Member member) => _memberDao.insertMember(member);

  @override
  Future<void> updateMember(Member member) => _memberDao.updateMember(member);

  @override
  Future<List<Member>> searchMembers(String query) => _loadMembers().then(
    (members) => members
        .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
        .toList(),
  );

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
  Future<void> deleteMember(String memberId) =>
      _memberDao.findMemberById(memberId).then((member) {
        if (member == null) {
          throw Exception('Member with ID $memberId not found');
        }
        return _memberDao.deleteMember(member);
      });
}
