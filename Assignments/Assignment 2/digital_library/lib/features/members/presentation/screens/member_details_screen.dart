import 'package:flutter/material.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/faculty_member.dart';
import '../../domain/entities/student_member.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String memberId;

  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final member = DataService().getMember(memberId);

    if (member == null) {
      return const Scaffold(body: Center(child: Text('Member not found')));
    }

    final currentBorrowed = member.borrowedItems
        .where((i) => !i.isReturned)
        .length;
    final totalBorrowed = member.borrowedItems.length;
    final overdue = member.getOverdueItems().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
        backgroundColor: member.getMemberType() == 'Student'
            ? Colors.deepPurple
            : Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // profile
          Card(
            margin: const EdgeInsets.only(right: 150),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: member.getMemberType() == 'Student'
                        ? Colors.deepPurple
                        : Colors.orange,
                    child: Text(
                      member.name.isNotEmpty
                          ? member.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: member.getMemberType() == 'Student'
                          ? Colors.deepPurple.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      member.getMemberType(),
                      style: TextStyle(
                        color: member.getMemberType() == 'Student'
                            ? Colors.deepPurple
                            : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(member.email, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text('Member ID'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(member.memberId),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text('Join Date'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              member.joinDate.toLocal().toString().split(
                                ' ',
                              )[0],
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text('Max Borrow Limit'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text('${member.maxBorrowLimit}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text('Borrow Period'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text('${member.borrowPeriod} days'),
                          ),
                        ],
                      ),
                      if (member.getMemberType() == 'Student') ...[
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('Student ID'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text((member as StudentMember).studentId),
                            ),
                          ],
                        ),
                      ] else if (member.getMemberType() == 'Faculty') ...[
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('Department'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text((member as FacultyMember).department),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Borrowing Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$currentBorrowed',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Current',
                            style: TextStyle(fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$totalBorrowed',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$overdue',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Overdue',
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (member.getMemberType() == 'Student') ...[
            // fines
            Card(
              color: Colors.lightGreen.shade50,
              margin: const EdgeInsets.only(bottom: 50),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Outstanding Fees',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        Text(
                          'QR${(member as StudentMember).calculateFees().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
