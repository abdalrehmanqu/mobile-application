import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/core/data/database/database_provider.dart';
import 'package:class_manager/features/dashboard/data/repository/class_repo_local_db.dart';
import 'package:class_manager/features/dashboard/data/repository/student_repo_local_db.dart';
import 'package:class_manager/features/dashboard/domain/contracts/class_repo.dart';
import 'package:class_manager/features/dashboard/domain/contracts/student_repo.dart';

final classRepoProvider = FutureProvider<ClassRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return ClassRepoLocalDB(database.classDao);
});

final studentRepoProvider = FutureProvider<StudentRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return StudentRepoLocalDB(database.studentDao);
});
