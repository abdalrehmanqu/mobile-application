import 'package:digital_library/core/database/Daos/book_dao.dart';
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/book.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final BookDao _bookDao;
  LibraryRepositoryImpl(this._bookDao);

  // Simple in-memory cache of books used by CRUD helpers.
  List<Book>? _books;

  /// Load library items (cached)
  Future<List<Book>> _loadBooks() async {
    if (_books != null) return _books!;
    _books = await _bookDao.findAllBooks();
    return _books!;
  }

  @override
  Future<List<Book>> getAllItems() => _loadBooks();

  @override
  Future<Book> getItem(String id) => _bookDao.findBookById(id).then((book) {
        if (book == null) {
          throw Exception('Book with ID $id not found');
        }
        return book;
      });

  @override
  Future<List<Book>> searchItems(String query) => _loadBooks().then((books) =>
      books.where((b) => b.title.toLowerCase().contains(query.toLowerCase())).toList());
    
  @override
  Future<List<Book>> getItemsByCategory(String category) => _loadBooks().then((books) =>
      books.where((book) => book.category.toLowerCase() == category.toLowerCase()).toList());

  @override
  Future<List<Book>> getAvailableItems() => _loadBooks().then((books) =>
      books.where((book) => book.isAvailable).toList());

  @override
  Future<List<Book>> getItemsByAuthor(String authorId) => _loadBooks().then((books) =>
      books.where((book) => book.authorId == authorId).toList());

  @override
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    final book = await getItem(bookId);
    final updatedBook = Book(
      id: book.id,
      title: book.title,
      authorId: book.authorId,
      category: book.category,
      isAvailable: isAvailable,
      publishedYear: book.publishedYear,
      pageCount: book.pageCount,
      isbn: book.isbn,
      publisher: book.publisher,
    );
    await _bookDao.updateBook(updatedBook);
    if (_books != null) {
      final index = _books!.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _books![index] = updatedBook;
      }
    }
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Book>> watchAllItems() async* {
    yield await getAllItems();
  }

  @override
  Stream<Book?> watchItem(String id) async* {
    try {
      yield await getItem(id);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Book>> watchSearchResults(String query) async* {
    yield await searchItems(query);
  }

  @override
  Stream<List<Book>> watchItemsByCategory(String category) async* {
    yield await getItemsByCategory(category);
  }

  @override
  Stream<List<Book>> watchAvailableItems() async* {
    yield await getAvailableItems();
  }

  @override
  Stream<List<Book>> watchItemsByAuthor(String authorId) async* {
    yield await getItemsByAuthor(authorId);
  }

  // ==================== CRUD operations ====================

  @override
  Future<void> addItem(Book book) => _bookDao.insertBook(book);

  @override
  Future<void> updateItem(Book book) => _bookDao.updateBook(book);

  @override
  Future<void> deleteItem(String id) => _bookDao.findBookById(id).then((book) {
        if (book == null) {
          throw Exception('Book with ID $id not found');
        }
        return _bookDao.deleteBook(book);
      });

}
