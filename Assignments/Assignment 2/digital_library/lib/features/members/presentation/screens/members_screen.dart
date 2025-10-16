import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/member.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _dataService = DataService();
  List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _members = _dataService.getAllMembers();
  }

  @override
  Widget build(BuildContext context) {

    final totalMembers = _members.length;
    final students = _members.where((m) => m.getMemberType() == 'Student').length;
    final faculty = _members.where((m) => m.getMemberType() == 'Faculty').length;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          //searchBar
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by name or email...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    _members = _dataService.searchMembers(query);
                  });
                },
              ),
            ),
          ),
          //statistics
          Container(
            color: Colors.white,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.lightBlue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$totalMembers', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 24)),
                          Text('Total', style: const TextStyle(color: Colors.teal, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.deepPurple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$students', style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 24)),
                          Text('Students', style: const TextStyle(color: Colors.deepPurple, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$faculty', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 24)),
                          Text('Faculty', style: const TextStyle(color: Colors.orange, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          //members list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return ListTile(
                  onTap: () {
                    context.push('/members/${member.memberId}');
                  },
                  tileColor: Colors.lightBlue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.teal.shade100),
                  ),
                  
                  leading: CircleAvatar(
                    backgroundColor: member.getMemberType() == 'Student' ? Colors.deepPurple.shade700 : Colors.orange.shade700,
                    child: Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(member.name,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.email,textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: member.getMemberType() == 'Student' ? Colors.deepPurple.shade100 : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              member.getMemberType(),
                              style: TextStyle(
                                color: member.getMemberType() == 'Student' ? Colors.deepPurple.shade700 : Colors.orange.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.menu_book,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text('${member.borrowedItems.where((i) => !i.isReturned).length}/${member.maxBorrowLimit}')
                        ],
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }
}
