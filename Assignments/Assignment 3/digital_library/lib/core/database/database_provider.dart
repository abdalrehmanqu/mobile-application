import 'package:digital_library/core/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = FutureProvider((ref) async {
  return $FloorAppDatabase.databaseBuilder("app_database.db").build();
});