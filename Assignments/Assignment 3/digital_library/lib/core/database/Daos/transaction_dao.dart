import 'package:digital_library/features/borrowing/domain/entities/transaction.dart';
import 'package:floor/floor.dart';

@dao
abstract class TransactionDao {
  @Query('SELECT * FROM Transactions WHERE id = :id')
  Future<Transaction?> findTransactionById(String id);

  @Query('SELECT * FROM Transactions')
  Future<List<Transaction>> findAllTransactions();

  @insert
  Future<void> insertTransaction(Transaction transaction);

  @delete
  Future<void> deleteTransaction(Transaction transaction);

  @update
  Future<void> updateTransaction(Transaction transaction);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrUpdateTransaction(Transaction transaction);

  @Query('SELECT * FROM Transactions')
  Stream<List<Transaction>> watchAllBooks();

  @insert
  Future<void> insertTransactions(List<Transaction> transactions);
}
