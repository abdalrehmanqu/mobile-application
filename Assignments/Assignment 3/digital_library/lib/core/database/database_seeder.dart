import 'dart:convert';

import 'package:digital_library/core/database/app_database.dart';
import 'package:digital_library/features/auth/domain/entities/staff.dart';
import 'package:digital_library/features/borrowing/domain/entities/transaction.dart';
import 'package:digital_library/features/library_items/domain/entities/author.dart';
import 'package:digital_library/features/library_items/domain/entities/book.dart';
import 'package:digital_library/features/members/domain/entities/member.dart';
import 'package:flutter/services.dart';

class DatabaseSeeder {
    static Future<void> seedDatabase(AppDatabase database) async {
        try {
            // ✅ Check if database is already seeded
            final bookCount = await database.bookDao.findAllBooks();

            if (bookCount.isNotEmpty) {
                return; // Already seeded, skip
            }

            // ✅ Seed Categories
            await _seedAuthor(database);

            // ✅ Seed Books
            await _seedBooks(database);

            await _seedMembers(database);

            await _seedStaff(database);

            await _seedTransactions(database);
        } catch (e) {
            rethrow;
        }
    }

    static Future<void> _seedAuthor(AppDatabase database) async {
        final jsonString = await rootBundle.loadString(
            'assets/data/authors_json.json',
        );

        final List<dynamic> jsonData = json.decode(jsonString);

        final authors = jsonData.map((json) => Author.fromJson(json)).toList();

        await database.authorDao.insertAuthors(authors);
    }
    static Future<void> _seedBooks(AppDatabase database) async {
        final jsonString = await rootBundle.loadString('assets/data/library_catalog_json.json');

        final List<dynamic> jsonData = json.decode(jsonString);

        final books = jsonData.map((json) => Book.fromJson(json)).toList();

        await database.bookDao.insertBooks(books);
    }
    static Future<void> _seedMembers(AppDatabase database) async {
        final jsonString = await rootBundle.loadString(
            'assets/data/members_json.json',
        );

        final List<dynamic> jsonData = json.decode(jsonString);
        
        final members = jsonData.map((json) => Member.fromJson(json)).toList();
        
        await database.memberDao.insertMembers(members);
    }
    static Future<void> _seedStaff(AppDatabase database) async {
        final jsonString = await rootBundle.loadString(
            'assets/data/staff_json.json',
        );

        final List<dynamic> jsonData = json.decode(jsonString);

        final staffs = jsonData.map((json) => Staff.fromJson(json)).toList();

        await database.staffDao.insertStaffs(staffs);
    }
    static Future<void> _seedTransactions(AppDatabase database) async {
        final jsonString = await rootBundle.loadString(
            'assets/data/transactions_json.json',
        );

        final List<dynamic> jsonData = json.decode(jsonString);

        final transactions = jsonData.map((json) => Transaction.fromJson(json)).toList();

        await database.transactionDao.insertTransactions(transactions);
    }

}