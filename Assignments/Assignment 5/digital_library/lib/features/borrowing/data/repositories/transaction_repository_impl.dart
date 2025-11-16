import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseClient _client;
  TransactionRepositoryImpl(this._client);

  /// Load transactions from JSON file
  Future<List<Transaction>> _loadTransactions() async {
    try {
      final response = await _client.from('borrowtransactions').select();
      final List<dynamic> data = response as List;
      return data.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return await _loadTransactions();
  }

  @override
  Future<Transaction> getTransaction(String transactionId) async {
    return await _client
        .from('borrowtransactions')
        .select()
        .eq("id", transactionId)
        .single()
        .then((json) => Transaction.fromJson(json));
  }

  @override
  Future<List<Transaction>> getTransactionsByMember(String memberId) async {
    return await _client
        .from('borrowtransactions')
        .select()
        .eq("member_id", memberId)
        .then((data) =>
            (data as List).map((json) => Transaction.fromJson(json)).toList());
  }

  @override
  Future<List<Transaction>> getTransactionsByBook(String bookId) async {
    return await _client
        .from('borrowtransactions')
        .select()
        .eq("book_id", bookId)
        .then((data) =>
            (data as List).map((json) => Transaction.fromJson(json)).toList());
  }

  @override
  Future<List<Transaction>> getActiveTransactions() async {
    return await _client
        .from('borrowtransactions')
        .select()
        .eq("is_returned", false)
        .then((data) =>
            (data as List).map((json) => Transaction.fromJson(json)).toList());
  }

  @override
  Future<List<Transaction>> getOverdueTransactions() async {
    final now = DateTime.now().toIso8601String();
    return await _client
        .from('borrowtransactions')
        .select()
        .lt("due_date", now)
        .eq("is_returned", false)
        .then((data) =>
            (data as List).map((json) => Transaction.fromJson(json)).toList());
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _client.from('borrowtransactions').insert(transaction.toJson());
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await _client
        .from('borrowtransactions')
        .update(transaction.toJson())
        .eq('id', transaction.id);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _client
        .from('borrowtransactions')
        .delete()
        .eq('id', transactionId);
  }

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
