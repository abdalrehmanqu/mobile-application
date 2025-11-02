import 'package:class_manager/features/dashboard/domain/entities/student.dart';
import 'package:class_manager/features/dashboard/presentation/providers/class_provider.dart';
import 'package:class_manager/features/dashboard/presentation/providers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentsByClassScreen extends ConsumerStatefulWidget {
  final int classId;
  const StudentsByClassScreen({super.key, required this.classId});

  @override
  ConsumerState<StudentsByClassScreen> createState() =>
      _StudentsByClassScreenState();
}

class _StudentsByClassScreenState extends ConsumerState<StudentsByClassScreen> {
  late final String c;
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _laodClass(widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Load classes using ref.watch()
    // TODO: Handle loading/error/data states using .when()
    // TODO: Display classes in ListView with cards
    // TODO: Navigate to students screen when class card is tapped
    final studentsesAsyncValue = ref.watch(studentNotifierProvider);
    final db = ref.read(studentNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(c, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: studentsesAsyncValue.when(
        data: (classData) {
          classData.students.removeWhere((s) => s.classId == widget.classId);
          final classes = classData.students;
          return Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final item = classes[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue),
                  ),

                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.profileUrl),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      item.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book, color: Colors.blue, size: 12),
                          const SizedBox(width: 3),
                          Text(item.email, textAlign: TextAlign.start),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.blue, size: 12),
                          const SizedBox(width: 3),
                          Text(item.studentId, textAlign: TextAlign.start),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => (db.deleteStudent(item)),
                            child: Text("delete"),
                          ),

                          ElevatedButton(
                            onPressed: () => (context.push("/student/${item.id}")),
                            child: Text('edit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
        error: (error, stackTrace) => Text("Error: $error"),
        loading: () => CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _laodClass(int classId) async {
    final db = await ref.read(classNotifierProvider.notifier);
    final temp = await db.getClassById(classId);
    c = await temp!.name;
  }
}
