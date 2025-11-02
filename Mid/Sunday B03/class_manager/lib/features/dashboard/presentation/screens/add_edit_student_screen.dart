import 'package:class_manager/features/dashboard/presentation/providers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditStudentScreen extends ConsumerStatefulWidget {
  final int classId;
  final int? studentId;

  const AddEditStudentScreen({
    super.key,
    required this.classId,
    this.studentId,
  });

  @override
  ConsumerState<AddEditStudentScreen> createState() =>
      _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends ConsumerState<AddEditStudentScreen> {
  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create form with TextFormField for name, studentId, email, profileUrl
    // TODO: If studentId exists, load and populate form with student data
    // TODO: Implement save button that adds or updates student
    // TODO: Navigate back after save
    final db = ref.read(studentNotifierProvider);
    return Scaffold(
      body: db.when(
        data: (classData) {
          final classes = classData.students.firstWhere((s)=>s.id==widget.studentId);
          return Expanded(
            child: Form(child: Text('data')
            )
          );
        },
        error: (error, stackTrace) => Text("Error: $error"),
        loading: () => CircularProgressIndicator(),
      ),
    );
  }
}
