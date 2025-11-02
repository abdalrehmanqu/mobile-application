import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../features/dashboard/domain/entities/class.dart';
import '../../../features/dashboard/domain/entities/student.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(AppDatabase database) async {
    try {
      final classCount = await database.classDao.getAllClasses();

      if (classCount.isNotEmpty) {
        return; // Already seeded, skip
      }

      await _seedClasses(database);
      await _seedStudents(database);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _seedClasses(AppDatabase database) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/classes.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    final classes = jsonData.map((json) => Class.fromJson(json)).toList();
    await database.classDao.insertClasses(classes);
  }

  static Future<void> _seedStudents(AppDatabase database) async {
    final jsonString = await rootBundle.loadString('assets/data/students.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final students = jsonData.map((json) => Student.fromJson(json)).toList();
    await database.studentDao.insertStudents(students);
  }

  static Future<void> clearDatabase(AppDatabase database) async {
    await database.studentDao.deleteAllStudents();
    await database.classDao.deleteAllClasses();
  }
}
