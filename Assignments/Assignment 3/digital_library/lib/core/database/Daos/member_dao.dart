import 'package:digital_library/features/members/domain/entities/member.dart';
import 'package:floor/floor.dart';

@dao 
abstract class MemberDao {
  @Query('SELECT * FROM Member WHERE memberId = :memberId')
  Future<Member?> findMemberById(String memberId);
  
  @Query('SELECT * FROM Member')
  Future<List<Member>> findAllMembers();

  @insert
  Future<void> insertMember(Member member);

  @delete
  Future<void> deleteMember(Member member);

  @update
  Future<void> updateMember(Member member);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrUpdateMember(Member member);

  @Query('SELECT * FROM Member')
  Stream<List<Member>> watchAllMembers();

  @insert 
  Future<void> insertMembers(List<Member> members);
}