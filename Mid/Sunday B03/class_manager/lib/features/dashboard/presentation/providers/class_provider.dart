import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/features/dashboard/domain/contracts/class_repo.dart';
import 'package:class_manager/features/dashboard/domain/entities/class.dart';
import 'package:class_manager/features/dashboard/presentation/providers/repo_providers.dart';

class ClassData {
  List<Class> classes;
  ClassData({required this.classes});
}

class ClassNotifier extends AsyncNotifier<ClassData> {
  late final ClassRepository classRepo;

  @override
  Future<ClassData> build() async {
    classRepo = await ref.read(classRepoProvider.future);
    classRepo.getClasses().listen((classes) {
      state = AsyncData(ClassData(classes: classes));
    });
    return ClassData(classes: []);
  }

  Future<Class?> getClassById(int id) async {
    return await classRepo.getClassById(id);
  }
}

final classNotifierProvider = AsyncNotifierProvider<ClassNotifier, ClassData>(
  () => ClassNotifier(),
);
