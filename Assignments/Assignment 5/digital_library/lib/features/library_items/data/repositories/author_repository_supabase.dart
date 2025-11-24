import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/author_repository.dart';
import '../../domain/entities/author.dart';

class AuthorRepositorySupabase implements AuthorRepository {
  final SupabaseClient client;

  AuthorRepositorySupabase(this.client);

  @override
  Future<List<Author>> getAllAuthors() async {
    final data = await client.from('authors').select();
    return data.map<Author>((row) => Author.fromJson(row)).toList();
  }

  @override
  Future<Author> getAuthor(String id) async {
    final data = await client.from('authors').select().eq('id', id).maybeSingle();
    if (data == null) throw Exception('Author with ID $id not found');
    return Author.fromJson(data);
  }

  @override
  Future<List<Author>> searchAuthors(String query) async {
    if (query.isEmpty) return getAllAuthors();
    final lower = query.toLowerCase();
    final data = await client
        .from('authors')
        .select()
        .ilike('name', '%$query%');
    return data
        .map<Author>((row) => Author.fromJson(row))
        .where((author) =>
            author.name.toLowerCase().contains(lower) ||
            (author.biography ?? '').toLowerCase().contains(lower))
        .toList();
  }

  // Streams
  @override
  Stream<List<Author>> watchAllAuthors() {
    return client
        .from('authors')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((row) => Author.fromJson(row)).toList());
  }

  @override
  Stream<Author?> watchAuthor(String id) {
    return client
        .from('authors')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) => rows.isNotEmpty ? Author.fromJson(rows.first) : null);
  }

  @override
  Stream<List<Author>> watchSearchResults(String query) {
    if (query.isEmpty) return watchAllAuthors();
    final lower = query.toLowerCase();
    return watchAllAuthors().map((authors) => authors
        .where((author) =>
            author.name.toLowerCase().contains(lower) ||
            (author.biography ?? '').toLowerCase().contains(lower))
        .toList());
  }

  // CRUD
  @override
  Future<void> addAuthor(Author author) async {
    await client.from('authors').insert(author.toJson());
  }

  @override
  Future<void> updateAuthor(Author author) async {
    await client.from('authors').update(author.toJson()).eq('id', author.id);
  }

  @override
  Future<void> deleteAuthor(String id) async {
    await client.from('authors').delete().eq('id', id);
  }
}
