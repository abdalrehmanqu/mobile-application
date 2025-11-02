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

  ClassDao? _classDaoInstance;

  StudentDao? _studentDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `classes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `subject` TEXT NOT NULL, `grade` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `students` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `studentId` TEXT NOT NULL, `email` TEXT NOT NULL, `profileUrl` TEXT NOT NULL, `classId` INTEGER NOT NULL, FOREIGN KEY (`classId`) REFERENCES `classes` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ClassDao get classDao {
    return _classDaoInstance ??= _$ClassDao(database, changeListener);
  }

  @override
  StudentDao get studentDao {
    return _studentDaoInstance ??= _$StudentDao(database, changeListener);
  }
}

class _$ClassDao extends ClassDao {
  _$ClassDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _classInsertionAdapter = InsertionAdapter(
            database,
            'classes',
            (Class item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'subject': item.subject,
                  'grade': item.grade
                },
            changeListener),
        _classUpdateAdapter = UpdateAdapter(
            database,
            'classes',
            ['id'],
            (Class item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'subject': item.subject,
                  'grade': item.grade
                },
            changeListener),
        _classDeletionAdapter = DeletionAdapter(
            database,
            'classes',
            ['id'],
            (Class item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'subject': item.subject,
                  'grade': item.grade
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Class> _classInsertionAdapter;

  final UpdateAdapter<Class> _classUpdateAdapter;

  final DeletionAdapter<Class> _classDeletionAdapter;

  @override
  Stream<List<Class>> getClasses() {
    return _queryAdapter.queryListStream('SELECT * FROM classes',
        mapper: (Map<String, Object?> row) => Class(
            id: row['id'] as int?,
            name: row['name'] as String,
            subject: row['subject'] as String,
            grade: row['grade'] as String),
        queryableName: 'classes',
        isView: false);
  }

  @override
  Future<List<Class>> getAllClasses() async {
    return _queryAdapter.queryList('SELECT * FROM classes',
        mapper: (Map<String, Object?> row) => Class(
            id: row['id'] as int?,
            name: row['name'] as String,
            subject: row['subject'] as String,
            grade: row['grade'] as String));
  }

  @override
  Future<Class?> getClassById(int id) async {
    return _queryAdapter.query('SELECT * FROM classes WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Class(
            id: row['id'] as int?,
            name: row['name'] as String,
            subject: row['subject'] as String,
            grade: row['grade'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllClasses() async {
    await _queryAdapter.queryNoReturn('DELETE FROM classes');
  }

  @override
  Future<void> addClass(Class classEntity) async {
    await _classInsertionAdapter.insert(classEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertClass(Class classEntity) async {
    await _classInsertionAdapter.insert(
        classEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertClasses(List<Class> classes) async {
    await _classInsertionAdapter.insertList(classes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateClass(Class classEntity) async {
    await _classUpdateAdapter.update(classEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteClass(Class classEntity) async {
    await _classDeletionAdapter.delete(classEntity);
  }
}

class _$StudentDao extends StudentDao {
  _$StudentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _studentInsertionAdapter = InsertionAdapter(
            database,
            'students',
            (Student item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'studentId': item.studentId,
                  'email': item.email,
                  'profileUrl': item.profileUrl,
                  'classId': item.classId
                },
            changeListener),
        _studentUpdateAdapter = UpdateAdapter(
            database,
            'students',
            ['id'],
            (Student item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'studentId': item.studentId,
                  'email': item.email,
                  'profileUrl': item.profileUrl,
                  'classId': item.classId
                },
            changeListener),
        _studentDeletionAdapter = DeletionAdapter(
            database,
            'students',
            ['id'],
            (Student item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'studentId': item.studentId,
                  'email': item.email,
                  'profileUrl': item.profileUrl,
                  'classId': item.classId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Student> _studentInsertionAdapter;

  final UpdateAdapter<Student> _studentUpdateAdapter;

  final DeletionAdapter<Student> _studentDeletionAdapter;

  @override
  Stream<List<Student>> getStudents() {
    return _queryAdapter.queryListStream('SELECT * FROM students',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            name: row['name'] as String,
            studentId: row['studentId'] as String,
            email: row['email'] as String,
            profileUrl: row['profileUrl'] as String,
            classId: row['classId'] as int),
        queryableName: 'students',
        isView: false);
  }

  @override
  Future<Student?> getStudentById(int id) async {
    return _queryAdapter.query('SELECT * FROM students WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            name: row['name'] as String,
            studentId: row['studentId'] as String,
            email: row['email'] as String,
            profileUrl: row['profileUrl'] as String,
            classId: row['classId'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Student?>> getStudentsByClass(int classId) async {
    return _queryAdapter.queryList('SELECT * FROM students WHERE classId = ?1',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            name: row['name'] as String,
            studentId: row['studentId'] as String,
            email: row['email'] as String,
            profileUrl: row['profileUrl'] as String,
            classId: row['classId'] as int),
        arguments: [classId]);
  }

  @override
  Future<void> deleteAllStudents() async {
    await _queryAdapter.queryNoReturn('DELETE FROM students');
  }

  @override
  Future<void> addStudent(Student student) async {
    await _studentInsertionAdapter.insert(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertStudent(Student student) async {
    await _studentInsertionAdapter.insert(student, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertStudents(List<Student> students) async {
    await _studentInsertionAdapter.insertList(
        students, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudent(Student student) async {
    await _studentUpdateAdapter.update(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStudent(Student student) async {
    await _studentDeletionAdapter.delete(student);
  }
}
