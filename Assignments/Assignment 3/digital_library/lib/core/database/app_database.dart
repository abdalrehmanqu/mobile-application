import 'dart:async';

import 'package:digital_library/core/database/Daos/author_dao.dart';
import 'package:digital_library/core/database/Daos/book_dao.dart';
import 'package:digital_library/core/database/Daos/member_dao.dart';
import 'package:digital_library/core/database/Daos/staff_dao.dart';
import 'package:digital_library/core/database/Daos/transaction_dao.dart';
import 'package:digital_library/core/database/type_converters.dart';
import 'package:digital_library/features/auth/domain/entities/staff.dart';
import 'package:digital_library/features/borrowing/domain/entities/transaction.dart';
import 'package:digital_library/features/library_items/domain/entities/author.dart';
import 'package:digital_library/features/library_items/domain/entities/book.dart';
import 'package:digital_library/features/members/domain/entities/member.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Database(version: 1, entities: [Author, Book, Member, Transaction, Staff ])
abstract class AppDatabase extends FloorDatabase {
  MemberDao get memberDao;
  AuthorDao get authorDao;
  BookDao get bookDao;
  TransactionDao get transactionDao;
  StaffDao get staffDao;
}
