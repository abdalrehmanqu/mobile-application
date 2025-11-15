import 'package:digital_library/core/database/Daos/transaction_dao.dart';
import '../../domain/contracts/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDao _transactionDao;
  TransactionRepositoryImpl(this._transactionDao);
  
  /// Load transactions from JSON file
  Future<List<Transaction>> _loadTransactions() => _transactionDao.findAllTransactions();

  @override
  Future<List<Transaction>> getAllTransactions() => _loadTransactions();

  @override
  Future<Transaction> getTransaction(String transactionId) => _transactionDao.findTransactionById(transactionId).then((transaction) {
        if (transaction == null) {
          throw Exception('Transaction with ID $transactionId not found');
        }
        return transaction;
      });

  @override
  Future<List<Transaction>> getTransactionsByMember(String memberId) => _loadTransactions().then((transactions) =>
      transactions.where((t) => t.memberId == memberId).toList());

  @override
  Future<List<Transaction>> getTransactionsByBook(String bookId) => _loadTransactions().then((transactions) =>
      transactions.where((t) => t.bookId == bookId).toList());

  @override
  Future<List<Transaction>> getActiveTransactions() => _loadTransactions().then((transactions) =>
      transactions.where((t) => !t.isReturned).toList());

  @override
  Future<List<Transaction>> getOverdueTransactions() => _loadTransactions().then((transactions) {
        final now = DateTime.now();
        return transactions.where((t) => !t.isReturned && t.dueDate.isBefore(now)).toList();
      });

  @override
  Future<void> addTransaction(Transaction transaction) => _transactionDao.insertTransaction(transaction);

  @override
  Future<void> updateTransaction(Transaction transaction) => _transactionDao.updateTransaction(transaction);

  @override
  Future<void> deleteTransaction(String transactionId) => _transactionDao.findTransactionById(transactionId).then((transaction) {
        if (transaction == null) {
          throw Exception('Transaction with ID $transactionId not found');
        }
        return _transactionDao.deleteTransaction(transaction);
      });

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Transaction>> watchAllTransactions() async* {
    yield await getAllTransactions();
  }
  @override
  Stream<Transaction?> watchTransaction(String transactionId) async* {
    try {
      yield await getTransaction(transactionId);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Transaction>> watchTransactionsByMember(String memberId) async* {
    yield await getTransactionsByMember(memberId);
  }

  @override
  Stream<List<Transaction>> watchTransactionsByBook(String bookId) async* {
    yield await getTransactionsByBook(bookId);
  }

  @override
  Stream<List<Transaction>> watchActiveTransactions() async* {
    yield await getActiveTransactions();
  }

  @override
  Stream<List<Transaction>> watchOverdueTransactions() async* {
    yield await getOverdueTransactions();
  }

}
