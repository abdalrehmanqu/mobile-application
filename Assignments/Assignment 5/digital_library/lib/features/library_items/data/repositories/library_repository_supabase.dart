import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/book.dart';

class LibraryRepositorySupabase implements LibraryRepository {
  final SupabaseClient client;

  LibraryRepositorySupabase(this.client);

  @override
  Future<List<Book>> getAllItems() async {
    final data = await client.from('books').select();
    return data.map<Book>((row) => Book.fromJson(row)).toList();
  }

  @override
  Future<Book> getItem(String id) async {
    final data = await client.from('books').select().eq('id', id).maybeSingle();
    if (data == null) throw Exception('Book with ID $id not found');
    return Book.fromJson(data);
  }

  @override
  Future<List<Book>> searchItems(String query) async {
    if (query.isEmpty) return getAllItems();
    final data = await client
        .from('books')
        .select()
        .ilike('title', '%$query%')
        .order('title');
    // Also search description if needed by filtering client-side.
    return data
        .map<Book>((row) => Book.fromJson(row))
        .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            (book.description ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<Book>> getItemsByCategory(String category) async {
    final data = await client
        .from('books')
        .select()
        .ilike('category', category);
    return data.map<Book>((row) => Book.fromJson(row)).toList();
  }

  @override
  Future<List<Book>> getAvailableItems() async {
    final data = await client.from('books').select().eq('is_available', true);
    return data.map<Book>((row) => Book.fromJson(row)).toList();
  }

  @override
  Future<List<Book>> getItemsByAuthor(String authorId) async {
    final data = await client.from('books').select().eq('author_id', authorId);
    return data.map<Book>((row) => Book.fromJson(row)).toList();
  }

  @override
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    await client.from('books').update({'is_available': isAvailable}).eq('id', bookId);
  }

  // Streams
  @override
  Stream<List<Book>> watchAllItems() {
    return client
        .from('books')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((row) => Book.fromJson(row)).toList());
  }

  @override
  Stream<Book?> watchItem(String id) {
    return client
        .from('books')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) => rows.isNotEmpty ? Book.fromJson(rows.first) : null);
  }

  @override
  Stream<List<Book>> watchSearchResults(String query) {
    if (query.isEmpty) return watchAllItems();
    final lower = query.toLowerCase();
    return watchAllItems().map((books) => books
        .where((book) =>
            book.title.toLowerCase().contains(lower) ||
            (book.description ?? '').toLowerCase().contains(lower))
        .toList());
  }

  @override
  Stream<List<Book>> watchItemsByCategory(String category) {
    return client
        .from('books')
        .stream(primaryKey: ['id'])
        .eq('category', category)
        .map((rows) => rows.map((row) => Book.fromJson(row)).toList());
  }

  @override
  Stream<List<Book>> watchAvailableItems() {
    return client
        .from('books')
        .stream(primaryKey: ['id'])
        .eq('is_available', true)
        .map((rows) => rows.map((row) => Book.fromJson(row)).toList());
  }

  @override
  Stream<List<Book>> watchItemsByAuthor(String authorId) {
    return client
        .from('books')
        .stream(primaryKey: ['id'])
        .eq('author_id', authorId)
        .map((rows) => rows.map((row) => Book.fromJson(row)).toList());
  }

  // CRUD
  @override
  Future<void> addItem(Book book) async {
    await client.from('books').insert(book.toJson());
  }

  @override
  Future<void> updateItem(Book book) async {
    await client.from('books').update(book.toJson()).eq('id', book.id);
  }

  @override
  Future<void> deleteItem(String id) async {
    await client.from('books').delete().eq('id', id);
  }
}
