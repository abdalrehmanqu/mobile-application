import 'package:digital_library/core/database/Daos/author_dao.dart';
import '../../domain/contracts/author_repository.dart';
import '../../domain/entities/author.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorDao _authorDao;
  AuthorRepositoryImpl(this._authorDao);

  /// Load authors from JSON file
  Future<List<Author>> _loadAuthors() => _authorDao.findAllAuthors();

  @override
  Future<List<Author>> getAllAuthors() => _loadAuthors();

  @override
  Future<Author> getAuthor(String id) => _authorDao.findAuthorById(id).then((author) {
        if (author == null) {
          throw Exception('Author with ID $id not found');
        }
        return author;
      });

  @override
  Future<List<Author>> searchAuthors(String query) => _loadAuthors().then((authors) =>
      authors.where((a) => a.name.toLowerCase().contains(query.toLowerCase())).toList());

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Author>> watchAllAuthors() async* {
    yield await getAllAuthors();
  }

  @override
  Stream<Author?> watchAuthor(String id) async* {
    try {
      yield await getAuthor(id);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Author>> watchSearchResults(String query) async* {
    yield await searchAuthors(query);
  }

  // ==================== CRUD operations ====================

  @override
  Future<void> addAuthor(Author author) => _authorDao.insertAuthor(author);

  @override
  Future<void> updateAuthor(Author author) => _authorDao.updateAuthor(author);

  @override
  Future<void> deleteAuthor(String id) => _authorDao.findAuthorById(id).then((author) {
        if (author == null) {
          throw Exception('Author with ID $id not found');
        }
        return _authorDao.deleteAuthor(author);
      });

}
