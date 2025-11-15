import 'package:digital_library/features/library_items/domain/entities/author.dart';
import 'package:floor/floor.dart';

@dao
abstract class AuthorDao {
  @Query('SELECT * FROM Author WHERE id = :id')
  Future<Author?> findAuthorById(String id);
  
  @Query('SELECT * FROM Author')
  Future<List<Author>> findAllAuthors();

  @insert
  Future<void> insertAuthor(Author author);

  @delete
  Future<void> deleteAuthor(Author author);

  @update
  Future<void> updateAuthor(Author author);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrUpdateAuthor(Author author);

  @Query('SELECT * FROM Author')
  Stream<List<Author>> watchAllAuthors();

  @insert
  Future<void> insertAuthors(List<Author> authors);
}