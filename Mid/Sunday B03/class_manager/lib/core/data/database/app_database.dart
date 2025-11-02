import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';
import 'package:class_manager/core/data/database/daos/class_dao.dart';
import 'package:class_manager/core/data/database/daos/student_dao.dart';
import 'package:class_manager/features/dashboard/domain/entities/class.dart';
import 'package:class_manager/features/dashboard/domain/entities/student.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Class, Student])
abstract class AppDatabase extends FloorDatabase {
  ClassDao get classDao;
  StudentDao get studentDao;
}
