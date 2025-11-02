import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/core/data/database/app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FloorAppDatabase.databaseBuilder('class_manager.db').build();
});
