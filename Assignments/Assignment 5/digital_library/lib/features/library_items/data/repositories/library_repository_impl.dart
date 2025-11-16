import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/book.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final SupabaseClient _client;
  LibraryRepositoryImpl(this._client);

  /// Load library items from JSON file
  Future<List<Book>> _loadBooks() async {
    try {
      final response = await _client.from('books').select();

      final List<dynamic> data = response as List;
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  @override
  Future<List<Book>> getAllItems() async {
    return await _loadBooks();
  }

  @override
  Future<Book> getItem(String id) async {
    return await _client
        .from('books')
        .select()
        .eq("id", id)
        .single()
        .then((json) => Book.fromJson(json));
  }

  @override
  Future<List<Book>> searchItems(String query) async {
    return await _client
        .from('books')
        .select()
        .ilike('title', '%$query%')
        .then((data) =>
            (data as List).map((json) => Book.fromJson(json)).toList());
  }

  @override
  Future<List<Book>> getItemsByCategory(String category) async {
    return await _client
        .from('books')
        .select()
        .eq('category', category)
        .then((data) =>
            (data as List).map((json) => Book.fromJson(json)).toList());
  }

  @override
  Future<List<Book>> getAvailableItems() async {
    return await _client
        .from('books')
        .select()
        .eq('is_available', true)
        .then((data) =>
            (data as List).map((json) => Book.fromJson(json)).toList());
  }

  @override
  Future<List<Book>> getItemsByAuthor(String authorId) async {
    final response = await _client.from('books').select();
    final List<dynamic> data = response as List;
    return data
        .map((json) => Book.fromJson(json))
        .where((book) => book.authorId == authorId)
        .toList();
  }

  @override
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    await _client
        .from('books')
        .update({'is_available': isAvailable})
        .eq('id', bookId);
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
  Future<void> addItem(Book book) async {
    await _client.from('books').insert(book.toJson());
  }

  @override
  Future<void> updateItem(Book book) async {
    await _client.from('books').update(book.toJson()).eq('id', book.id);
  }

  @override
  Future<void> deleteItem(String id) async {
    await _client.from('books').delete().eq('id', id);
  }
}
