import 'dart:convert';
import 'dart:io';

import '../../domain/entities/member.dart';
import '../../domain/entities/student_member.dart';
import '../../domain/entities/faculty_member.dart';
import '../../domain/contracts/member_repository.dart';

class JsonMemberRepository implements MemberRepository {
  @override
  Future<List<Member>> getAllMembers() async {
    const filePath = 'assets/data/members_json.json';
    final file = File(filePath);
    if (!file.existsSync()) {
      return [];
    }
    final content = file.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((data) {
      if (data['type'] == 'StudentMember') {
        return StudentMember(
          memberId: data['memberId'],
          name: data['name'],
          email: data['email'],
          joinDate: DateTime.parse(data['joinDate']),
          borrowedItems: [],
          studentId: data['studentId'],
        );
      } else if (data['type'] == 'FacultyMember') {
        return FacultyMember(
          memberId: data['memberId'],
          name: data['name'],
          email: data['email'],
          joinDate: DateTime.parse(data['joinDate']),
          borrowedItems: [],
          department: data['department'],
        );
      } else {
        throw Exception('Unknown member type: ${data['type']}');
      }
    }).toList();
  }

  @override
  Future<Member?> getMember(String memberId) async {
    final members = await getAllMembers();
    try {
      return members.firstWhere((member) => member.memberId == memberId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addMember(Member member) async {
    final members = await getAllMembers();
    members.add(member);
    _saveMembers(members);
  }

  @override
  Future<void> updateMember(Member member) async {
    final members = await getAllMembers();
    final index = members.indexWhere((m) => m.memberId == member.memberId);
    if (index != -1) {
      members[index] = member;
      _saveMembers(members);
    } else {
      throw Exception('Member not found');
    }
  }

  Future<void> _saveMembers(List<Member> members) async {
    const filePath = 'assets/data/members_json.json';
    final file = File(filePath);
    final jsonData = members.map((member) {
      if (member is StudentMember) {
        return {
          'type': 'StudentMember',
          'memberId': member.memberId,
          'name': member.name,
          'email': member.email,
          'joinDate': member.joinDate.toIso8601String(),
          'borrowedItems': [],
          'studentId': member.studentId,
        };
      } else if (member is FacultyMember) {
        return {
          'type': 'FacultyMember',
          'memberId': member.memberId,
          'name': member.name,
          'email': member.email,
          'joinDate': member.joinDate.toIso8601String(),
          'borrowedItems': [],
          'department': member.department,
        };
      } else {
        throw Exception('Unknown member type');
      }
    }).toList();

    final jsonString = jsonEncode(jsonData);
    file.writeAsStringSync(jsonString);
  }
}
