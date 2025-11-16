// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MemberDao? _memberDaoInstance;

  AuthorDao? _authorDaoInstance;

  BookDao? _bookDaoInstance;

  TransactionDao? _transactionDaoInstance;

  StaffDao? _staffDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Author` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `profileImageUrl` TEXT, `biography` TEXT, `birthYear` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Book` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `authorId` TEXT NOT NULL, `publishedYear` INTEGER NOT NULL, `category` TEXT NOT NULL, `isAvailable` INTEGER NOT NULL, `coverImageUrl` TEXT, `description` TEXT, `pageCount` INTEGER NOT NULL, `isbn` TEXT NOT NULL, `publisher` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Member` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `memberType` TEXT NOT NULL, `memberSince` INTEGER NOT NULL, `profileImageUrl` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Transactions` (`id` TEXT NOT NULL, `memberId` TEXT NOT NULL, `bookId` TEXT NOT NULL, `borrowDate` INTEGER NOT NULL, `dueDate` INTEGER NOT NULL, `returnDate` INTEGER, `isReturned` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Staff` (`staffId` TEXT NOT NULL, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `fullName` TEXT NOT NULL, `role` TEXT NOT NULL, PRIMARY KEY (`staffId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MemberDao get memberDao {
    return _memberDaoInstance ??= _$MemberDao(database, changeListener);
  }

  @override
  AuthorDao get authorDao {
    return _authorDaoInstance ??= _$AuthorDao(database, changeListener);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }

  @override
  StaffDao get staffDao {
    return _staffDaoInstance ??= _$StaffDao(database, changeListener);
  }
}

class _$MemberDao extends MemberDao {
  _$MemberDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _memberInsertionAdapter = InsertionAdapter(
            database,
            'Member',
            (Member item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'memberType': item.memberType,
                  'memberSince': _dateTimeConverter.encode(item.memberSince),
                  'profileImageUrl': item.profileImageUrl
                },
            changeListener),
        _memberUpdateAdapter = UpdateAdapter(
            database,
            'Member',
            ['id'],
            (Member item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'memberType': item.memberType,
                  'memberSince': _dateTimeConverter.encode(item.memberSince),
                  'profileImageUrl': item.profileImageUrl
                },
            changeListener),
        _memberDeletionAdapter = DeletionAdapter(
            database,
            'Member',
            ['id'],
            (Member item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'memberType': item.memberType,
                  'memberSince': _dateTimeConverter.encode(item.memberSince),
                  'profileImageUrl': item.profileImageUrl
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Member> _memberInsertionAdapter;

  final UpdateAdapter<Member> _memberUpdateAdapter;

  final DeletionAdapter<Member> _memberDeletionAdapter;

  @override
  Future<Member?> findMemberById(String memberId) async {
    return _queryAdapter.query('SELECT * FROM Member WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Member(
            id: row['id'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            memberType: row['memberType'] as String,
            memberSince: _dateTimeConverter.decode(row['memberSince'] as int),
            profileImageUrl: row['profileImageUrl'] as String?),
        arguments: [memberId]);
  }

  @override
  Future<List<Member>> findAllMembers() async {
    return _queryAdapter.queryList('SELECT * FROM Member',
        mapper: (Map<String, Object?> row) => Member(
            id: row['id'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            memberType: row['memberType'] as String,
            memberSince: _dateTimeConverter.decode(row['memberSince'] as int),
            profileImageUrl: row['profileImageUrl'] as String?));
  }

  @override
  Stream<List<Member>> watchAllMembers() {
    return _queryAdapter.queryListStream('SELECT * FROM Member',
        mapper: (Map<String, Object?> row) => Member(
            id: row['id'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            memberType: row['memberType'] as String,
            memberSince: _dateTimeConverter.decode(row['memberSince'] as int),
            profileImageUrl: row['profileImageUrl'] as String?),
        queryableName: 'Member',
        isView: false);
  }

  @override
  Future<void> insertMember(Member member) async {
    await _memberInsertionAdapter.insert(member, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertOrUpdateMember(Member member) async {
    await _memberInsertionAdapter.insert(member, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertMembers(List<Member> members) async {
    await _memberInsertionAdapter.insertList(members, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMember(Member member) async {
    await _memberUpdateAdapter.update(member, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMember(Member member) async {
    await _memberDeletionAdapter.delete(member);
  }
}

class _$AuthorDao extends AuthorDao {
  _$AuthorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _authorInsertionAdapter = InsertionAdapter(
            database,
            'Author',
            (Author item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'profileImageUrl': item.profileImageUrl,
                  'biography': item.biography,
                  'birthYear': item.birthYear
                },
            changeListener),
        _authorUpdateAdapter = UpdateAdapter(
            database,
            'Author',
            ['id'],
            (Author item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'profileImageUrl': item.profileImageUrl,
                  'biography': item.biography,
                  'birthYear': item.birthYear
                },
            changeListener),
        _authorDeletionAdapter = DeletionAdapter(
            database,
            'Author',
            ['id'],
            (Author item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'profileImageUrl': item.profileImageUrl,
                  'biography': item.biography,
                  'birthYear': item.birthYear
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Author> _authorInsertionAdapter;

  final UpdateAdapter<Author> _authorUpdateAdapter;

  final DeletionAdapter<Author> _authorDeletionAdapter;

  @override
  Future<Author?> findAuthorById(String id) async {
    return _queryAdapter.query('SELECT * FROM Author WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Author(
            id: row['id'] as String,
            name: row['name'] as String,
            profileImageUrl: row['profileImageUrl'] as String?,
            biography: row['biography'] as String?,
            birthYear: row['birthYear'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Author>> findAllAuthors() async {
    return _queryAdapter.queryList('SELECT * FROM Author',
        mapper: (Map<String, Object?> row) => Author(
            id: row['id'] as String,
            name: row['name'] as String,
            profileImageUrl: row['profileImageUrl'] as String?,
            biography: row['biography'] as String?,
            birthYear: row['birthYear'] as int?));
  }

  @override
  Stream<List<Author>> watchAllAuthors() {
    return _queryAdapter.queryListStream('SELECT * FROM Author',
        mapper: (Map<String, Object?> row) => Author(
            id: row['id'] as String,
            name: row['name'] as String,
            profileImageUrl: row['profileImageUrl'] as String?,
            biography: row['biography'] as String?,
            birthYear: row['birthYear'] as int?),
        queryableName: 'Author',
        isView: false);
  }

  @override
  Future<void> insertAuthor(Author author) async {
    await _authorInsertionAdapter.insert(author, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertOrUpdateAuthor(Author author) async {
    await _authorInsertionAdapter.insert(author, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAuthors(List<Author> authors) async {
    await _authorInsertionAdapter.insertList(authors, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAuthor(Author author) async {
    await _authorUpdateAdapter.update(author, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAuthor(Author author) async {
    await _authorDeletionAdapter.delete(author);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _bookInsertionAdapter = InsertionAdapter(
            database,
            'Book',
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'authorId': item.authorId,
                  'publishedYear': item.publishedYear,
                  'category': item.category,
                  'isAvailable': item.isAvailable ? 1 : 0,
                  'coverImageUrl': item.coverImageUrl,
                  'description': item.description,
                  'pageCount': item.pageCount,
                  'isbn': item.isbn,
                  'publisher': item.publisher
                },
            changeListener),
        _bookUpdateAdapter = UpdateAdapter(
            database,
            'Book',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'authorId': item.authorId,
                  'publishedYear': item.publishedYear,
                  'category': item.category,
                  'isAvailable': item.isAvailable ? 1 : 0,
                  'coverImageUrl': item.coverImageUrl,
                  'description': item.description,
                  'pageCount': item.pageCount,
                  'isbn': item.isbn,
                  'publisher': item.publisher
                },
            changeListener),
        _bookDeletionAdapter = DeletionAdapter(
            database,
            'Book',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'authorId': item.authorId,
                  'publishedYear': item.publishedYear,
                  'category': item.category,
                  'isAvailable': item.isAvailable ? 1 : 0,
                  'coverImageUrl': item.coverImageUrl,
                  'description': item.description,
                  'pageCount': item.pageCount,
                  'isbn': item.isbn,
                  'publisher': item.publisher
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

  final UpdateAdapter<Book> _bookUpdateAdapter;

  final DeletionAdapter<Book> _bookDeletionAdapter;

  @override
  Future<Book?> findBookById(String id) async {
    return _queryAdapter.query('SELECT * FROM Book WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as String,
            title: row['title'] as String,
            authorId: row['authorId'] as String,
            publishedYear: row['publishedYear'] as int,
            category: row['category'] as String,
            isAvailable: (row['isAvailable'] as int) != 0,
            coverImageUrl: row['coverImageUrl'] as String?,
            description: row['description'] as String?,
            pageCount: row['pageCount'] as int,
            isbn: row['isbn'] as String,
            publisher: row['publisher'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Book>> findAllBooks() async {
    return _queryAdapter.queryList('SELECT * FROM Book',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as String,
            title: row['title'] as String,
            authorId: row['authorId'] as String,
            publishedYear: row['publishedYear'] as int,
            category: row['category'] as String,
            isAvailable: (row['isAvailable'] as int) != 0,
            coverImageUrl: row['coverImageUrl'] as String?,
            description: row['description'] as String?,
            pageCount: row['pageCount'] as int,
            isbn: row['isbn'] as String,
            publisher: row['publisher'] as String));
  }

  @override
  Stream<List<Book>> watchAllBooks() {
    return _queryAdapter.queryListStream('SELECT * FROM Book',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as String,
            title: row['title'] as String,
            authorId: row['authorId'] as String,
            publishedYear: row['publishedYear'] as int,
            category: row['category'] as String,
            isAvailable: (row['isAvailable'] as int) != 0,
            coverImageUrl: row['coverImageUrl'] as String?,
            description: row['description'] as String?,
            pageCount: row['pageCount'] as int,
            isbn: row['isbn'] as String,
            publisher: row['publisher'] as String),
        queryableName: 'Book',
        isView: false);
  }

  @override
  Future<void> insertBook(Book book) async {
    await _bookInsertionAdapter.insert(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertOrUpdateBook(Book book) async {
    await _bookInsertionAdapter.insert(book, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertBooks(List<Book> books) async {
    await _bookInsertionAdapter.insertList(books, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBook(Book book) async {
    await _bookUpdateAdapter.update(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBook(Book book) async {
    await _bookDeletionAdapter.delete(book);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _transactionInsertionAdapter = InsertionAdapter(
            database,
            'Transactions',
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'memberId': item.memberId,
                  'bookId': item.bookId,
                  'borrowDate': _dateTimeConverter.encode(item.borrowDate),
                  'dueDate': _dateTimeConverter.encode(item.dueDate),
                  'returnDate':
                      _nullableDateTimeConverter.encode(item.returnDate),
                  'isReturned': item.isReturned ? 1 : 0
                },
            changeListener),
        _transactionUpdateAdapter = UpdateAdapter(
            database,
            'Transactions',
            ['id'],
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'memberId': item.memberId,
                  'bookId': item.bookId,
                  'borrowDate': _dateTimeConverter.encode(item.borrowDate),
                  'dueDate': _dateTimeConverter.encode(item.dueDate),
                  'returnDate':
                      _nullableDateTimeConverter.encode(item.returnDate),
                  'isReturned': item.isReturned ? 1 : 0
                },
            changeListener),
        _transactionDeletionAdapter = DeletionAdapter(
            database,
            'Transactions',
            ['id'],
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'memberId': item.memberId,
                  'bookId': item.bookId,
                  'borrowDate': _dateTimeConverter.encode(item.borrowDate),
                  'dueDate': _dateTimeConverter.encode(item.dueDate),
                  'returnDate':
                      _nullableDateTimeConverter.encode(item.returnDate),
                  'isReturned': item.isReturned ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Transaction> _transactionInsertionAdapter;

  final UpdateAdapter<Transaction> _transactionUpdateAdapter;

  final DeletionAdapter<Transaction> _transactionDeletionAdapter;

  @override
  Future<Transaction?> findTransactionById(String id) async {
    return _queryAdapter.query('SELECT * FROM Transactions WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as String,
            memberId: row['memberId'] as String,
            bookId: row['bookId'] as String,
            borrowDate: _dateTimeConverter.decode(row['borrowDate'] as int),
            dueDate: _dateTimeConverter.decode(row['dueDate'] as int),
            returnDate:
                _nullableDateTimeConverter.decode(row['returnDate'] as int?),
            isReturned: (row['isReturned'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Transaction>> findAllTransactions() async {
    return _queryAdapter.queryList('SELECT * FROM Transactions',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as String,
            memberId: row['memberId'] as String,
            bookId: row['bookId'] as String,
            borrowDate: _dateTimeConverter.decode(row['borrowDate'] as int),
            dueDate: _dateTimeConverter.decode(row['dueDate'] as int),
            returnDate:
                _nullableDateTimeConverter.decode(row['returnDate'] as int?),
            isReturned: (row['isReturned'] as int) != 0));
  }

  @override
  Stream<List<Transaction>> watchAllBooks() {
    return _queryAdapter.queryListStream('SELECT * FROM Transactions',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as String,
            memberId: row['memberId'] as String,
            bookId: row['bookId'] as String,
            borrowDate: _dateTimeConverter.decode(row['borrowDate'] as int),
            dueDate: _dateTimeConverter.decode(row['dueDate'] as int),
            returnDate:
                _nullableDateTimeConverter.decode(row['returnDate'] as int?),
            isReturned: (row['isReturned'] as int) != 0),
        queryableName: 'Transactions',
        isView: false);
  }

  @override
  Future<void> insertTransaction(Transaction transaction) async {
    await _transactionInsertionAdapter.insert(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertOrUpdateTransaction(Transaction transaction) async {
    await _transactionInsertionAdapter.insert(
        transaction, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTransactions(List<Transaction> transactions) async {
    await _transactionInsertionAdapter.insertList(
        transactions, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionUpdateAdapter.update(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTransaction(Transaction transaction) async {
    await _transactionDeletionAdapter.delete(transaction);
  }
}

class _$StaffDao extends StaffDao {
  _$StaffDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _staffInsertionAdapter = InsertionAdapter(
            database,
            'Staff',
            (Staff item) => <String, Object?>{
                  'staffId': item.staffId,
                  'username': item.username,
                  'password': item.password,
                  'fullName': item.fullName,
                  'role': item.role
                },
            changeListener),
        _staffUpdateAdapter = UpdateAdapter(
            database,
            'Staff',
            ['staffId'],
            (Staff item) => <String, Object?>{
                  'staffId': item.staffId,
                  'username': item.username,
                  'password': item.password,
                  'fullName': item.fullName,
                  'role': item.role
                },
            changeListener),
        _staffDeletionAdapter = DeletionAdapter(
            database,
            'Staff',
            ['staffId'],
            (Staff item) => <String, Object?>{
                  'staffId': item.staffId,
                  'username': item.username,
                  'password': item.password,
                  'fullName': item.fullName,
                  'role': item.role
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Staff> _staffInsertionAdapter;

  final UpdateAdapter<Staff> _staffUpdateAdapter;

  final DeletionAdapter<Staff> _staffDeletionAdapter;

  @override
  Future<Staff?> findStaffByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM Staff WHERE username = ?1',
        mapper: (Map<String, Object?> row) => Staff(
            staffId: row['staffId'] as String,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String,
            role: row['role'] as String),
        arguments: [username]);
  }

  @override
  Future<List<Staff>> findAllStaffs() async {
    return _queryAdapter.queryList('SELECT * FROM Staff',
        mapper: (Map<String, Object?> row) => Staff(
            staffId: row['staffId'] as String,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String,
            role: row['role'] as String));
  }

  @override
  Stream<List<Staff>> watchAllStaffs() {
    return _queryAdapter.queryListStream('SELECT * FROM Staff',
        mapper: (Map<String, Object?> row) => Staff(
            staffId: row['staffId'] as String,
            username: row['username'] as String,
            password: row['password'] as String,
            fullName: row['fullName'] as String,
            role: row['role'] as String),
        queryableName: 'Staff',
        isView: false);
  }

  @override
  Future<void> insertStaff(Staff staff) async {
    await _staffInsertionAdapter.insert(staff, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertOrUpdateStaff(Staff staff) async {
    await _staffInsertionAdapter.insert(staff, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertStaffs(List<Staff> staffs) async {
    await _staffInsertionAdapter.insertList(staffs, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    await _staffUpdateAdapter.update(staff, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStaff(Staff staff) async {
    await _staffDeletionAdapter.delete(staff);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();
