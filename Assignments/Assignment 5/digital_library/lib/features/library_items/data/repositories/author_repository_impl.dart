import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/author_repository.dart';
import '../../domain/entities/author.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final SupabaseClient _client;
  AuthorRepositoryImpl(this._client);

  /// Load authors from JSON file
  Future<List<Author>> _loadAuthors() async {
     try {
      final response = await _client.from('authors').select();

      final List<dynamic> data = response as List;
      return data.map((json) => Author.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load authors: $e');
    }
  }

  @override
  Future<List<Author>> getAllAuthors() async {
    return await _loadAuthors();
  }

  @override
  Future<Author> getAuthor(String id) async {
    return await _client
        .from('authors')
        .select()
        .eq("id", id)
        .single()
        .then((json) => Author.fromJson(json));
  }

  @override
  Future<List<Author>> searchAuthors(String query) async {
    return await _client
        .from('authors')
        .select()
        .ilike('name', '%$query%')
        .then((data) =>
            (data as List).map((json) => Author.fromJson(json)).toList());
  }

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
  Future<void> addAuthor(Author author) async {
    await _client.from('authors').insert(author.toJson());
  }

  @override
  Future<void> updateAuthor(Author author) async {
    await _client.from('authors').update(author.toJson()).eq('id', author.id);
  }

  @override
  Future<void> deleteAuthor(String id) async {
    await _client.from('authors').delete().eq('id', id);
  }

}
