import 'package:digital_library/features/library_items/domain/entities/book.dart';
import 'package:floor/floor.dart';

@dao 
abstract class BookDao {
  @Query('SELECT * FROM Book WHERE id = :id')
  Future<Book?> findBookById(String id);
  
  @Query('SELECT * FROM Book')
  Future<List<Book>> findAllBooks();

  @insert
  Future<void> insertBook(Book book);

  @delete
  Future<void> deleteBook(Book book);

  @update
  Future<void> updateBook(Book book);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrUpdateBook(Book book);

  @Query('SELECT * FROM Book')
  Stream<List<Book>> watchAllBooks();

  @insert
  Future<void> insertBooks(List<Book> books);
}